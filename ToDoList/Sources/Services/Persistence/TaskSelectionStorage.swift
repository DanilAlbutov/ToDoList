import CoreData
import Foundation

protocol TaskItemsStorage {
    func loadItems(completion: @escaping ([TaskItem]) -> Void)
    func loadItem(with taskID: String, completion: @escaping (TaskItem?) -> Void)
    func save(items: [TaskItem], overrideOldCompletion: Bool, completion: (() -> Void)?)
    func upsert(item: TaskItem, completion: (() -> Void)?)
    func updateCompletion(for taskID: String, isCompleted: Bool, completion: (() -> Void)?)
    func deleteItem(with taskID: String, completion: (() -> Void)?)
}

final class CoreDataTaskItemsStorage: TaskItemsStorage {
    enum Entity {
        static let name = "TaskItem"
    }

    enum Attribute {
        static let id = "id"
        static let todo = "todo"
        static let detailsText = "detailsText"
        static let createdAt = "createdAt"
        static let completed = "completed"
        static let userID = "userID"
    }

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func loadItems(completion: @escaping ([TaskItem]) -> Void) {
        let context = coreDataStack.makeBackgroundContext()
        let request = TaskItemManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Attribute.id, ascending: true)]

        context.perform {
            var items: [TaskItem] = []
            do {
                let objects = try context.fetch(request)
                items = objects.map(\.domainModel)
            } catch {
                print("Failed to fetch task items: \(error)")
            }
            DispatchQueue.main.async {
                completion(items)
            }
        }
    }

    func loadItem(with taskID: String, completion: @escaping (TaskItem?) -> Void) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            print("-- thresd is main \(Thread.current.isMainThread)")
            var item: TaskItem?
            do {
                let request = self.makeFetchRequest(forID: taskID)
                item = try context.fetch(request).first?.domainModel
            } catch {
                print("Failed to fetch task item: \(error)")
            }
            DispatchQueue.main.async {
                completion(item)
            }
        }
    }

    func save(items: [TaskItem], overrideOldCompletion: Bool, completion: (() -> Void)? = nil) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            do {
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

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to save task items: \(error)")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func upsert(item: TaskItem, completion: (() -> Void)? = nil) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            do {
                let request = self.makeFetchRequest(forID: item.id)
                let existingObject = try context.fetch(request).first
                let object = existingObject ?? TaskItemManagedObject(context: context)
                object.apply(item, fallbackDate: existingObject?.createdAt ?? Date())

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to upsert task item: \(error)")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func updateCompletion(for taskID: String, isCompleted: Bool, completion: (() -> Void)? = nil) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            do {
                let request = self.makeFetchRequest(forID: taskID)
                guard let object = try context.fetch(request).first else {
                    DispatchQueue.main.async {
                        completion?()
                    }
                    return
                }

                object.completed = isCompleted

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to update task completion: \(error)")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func deleteItem(with taskID: String, completion: (() -> Void)? = nil) {
        let context = coreDataStack.makeBackgroundContext()
        context.perform {
            do {
                let request = self.makeFetchRequest(forID: taskID)
                guard let object = try context.fetch(request).first else {
                    DispatchQueue.main.async {
                        completion?()
                    }
                    return
                }

                context.delete(object)

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to delete task item: \(error)")
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    private func makeFetchRequest(forID id: String) -> NSFetchRequest<TaskItemManagedObject> {
        let request = TaskItemManagedObject.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %@", Attribute.id, id)
        return request
    }
}
