import CoreData
import Foundation

protocol TaskItemsStorage {
    func loadItems(completion: @escaping ([TaskItem]) -> Void)
    func loadItem(with taskID: String, completion: @escaping (TaskItem?) -> Void)
    func save(items: [TaskItem], overrideOldCompletion: Bool, completion: (() -> Void)?)
    func insert(item: TaskItem, completion: (() -> Void)?)
    func updateCompletion(for taskID: String, isCompleted: Bool, completion: (() -> Void)?)
    func deleteItem(with taskID: String, completion: (() -> Void)?)
}

final class CoreDataTaskItemsStorage: TaskItemsStorage {
    enum Entity {
        static let name = "TaskItem"
    }

    enum Attribute: String {
        case id, todo, detailsText, createdAt, completed, userID
    }

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func loadItems(completion: @escaping ([TaskItem]) -> Void) {
        performRead(
            operationName: "fetch task items",
            defaultValue: []
        ) { context in
            let request = TaskItemManagedObject.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: Attribute.id.rawValue, ascending: true)]
            let objects = try context.fetch(request)
            return objects.map(\.domainModel)
        } completion: { items in
            completion(items)
        }
    }

    func loadItem(with taskID: String, completion: @escaping (TaskItem?) -> Void) {
        performRead(
            operationName: "fetch task item",
            defaultValue: nil
        ) { context in
            let request = self.makeFetchRequest(forID: taskID)
            return try context.fetch(request).first?.domainModel
        } completion: { item in
            completion(item)
        }
    }

    func save(items: [TaskItem], overrideOldCompletion: Bool, completion: (() -> Void)? = nil) {
        performWrite(
            operationName: "save task items",
            completion: completion
        ) { context in
            for item in items {
                let request = self.makeFetchRequest(forID: item.id)
                let existingObject = try context.fetch(request).first
                let object = existingObject ?? TaskItemManagedObject(context: context)

                if existingObject == nil {
                    object.apply(item, fallbackDate: Date())
                } else if overrideOldCompletion {
                    object.completed = item.completed
                }
            }
        }
    }

    func insert(item: TaskItem, completion: (() -> Void)? = nil) {
        performWrite(
            operationName: "upsert task item",
            completion: completion
        ) { context in
            let request = self.makeFetchRequest(forID: item.id)
            let existingObject = try context.fetch(request).first
            let object = existingObject ?? TaskItemManagedObject(context: context)
            object.apply(item, fallbackDate: existingObject?.createdAt ?? Date())
        }
    }

    func updateCompletion(for taskID: String, isCompleted: Bool, completion: (() -> Void)? = nil) {
        performWrite(
            operationName: "update task completion",
            completion: completion
        ) { context in
            let request = self.makeFetchRequest(forID: taskID)
            guard let object = try context.fetch(request).first else {
                return
            }
            object.completed = isCompleted
        }
    }

    func deleteItem(with taskID: String, completion: (() -> Void)? = nil) {
        performWrite(
            operationName: "delete task item",
            completion: completion
        ) { context in
            let request = self.makeFetchRequest(forID: taskID)
            guard let object = try context.fetch(request).first else {
                return
            }
            context.delete(object)
        }
    }

    private func completeOnMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }

    private func performRead<T>(
        operationName: String,
        defaultValue: T,
        _ operation: @escaping (NSManagedObjectContext) throws -> T,
        completion: @escaping (T) -> Void
    ) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            let value: T
            do {
                value = try operation(context)
            } catch {
                print("Failed to \(operationName): \(error)")
                value = defaultValue
            }
            self.completeOnMain {
                completion(value)
            }
        }
    }

    private func performWrite(
        operationName: String,
        completion: (() -> Void)?,
        _ operation: @escaping (NSManagedObjectContext) throws -> Void
    ) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            do {
                try operation(context)
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to \(operationName): \(error)")
            }
            self.completeOnMain {
                completion?()
            }
        }
    }

    private func makeFetchRequest(forID id: String) -> NSFetchRequest<TaskItemManagedObject> {
        let request = TaskItemManagedObject.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %@", Attribute.id.rawValue, id)
        return request
    }
}
