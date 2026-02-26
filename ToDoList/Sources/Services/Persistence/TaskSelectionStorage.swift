import CoreData
import Foundation

protocol TaskItemsStorage {
    func loadItems() -> [TaskItem]
    func loadItem(with taskID: String) -> TaskItem?
    func save(items: [TaskItem], overrideOldCompletion: Bool)
    func upsert(item: TaskItem)
    func updateCompletion(for taskID: String, isCompleted: Bool)
    func deleteItem(with taskID: String)
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

    func loadItems() -> [TaskItem] {
        let context = coreDataStack.viewContext
        let request = TaskItemManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: Attribute.id, ascending: true)]

        var items: [TaskItem] = []
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                items = objects.map(\.domainModel)
            } catch {
                print("Failed to fetch task items: \(error)")
            }
        }

        return items
    }

    func loadItem(with taskID: String) -> TaskItem? {
        let context = coreDataStack.viewContext

        var item: TaskItem?
        context.performAndWait {
            do {
                let request = makeFetchRequest(forID: taskID)
                item = try context.fetch(request).first?.domainModel
            } catch {
                print("Failed to fetch task item: \(error)")
            }
        }

        return item
    }

    func save(items: [TaskItem], overrideOldCompletion: Bool) {
        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                for item in items {
                    let request = makeFetchRequest(forID: item.id)
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
        }
    }

    func upsert(item: TaskItem) {
        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                let request = makeFetchRequest(forID: item.id)
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
        }
    }

    func updateCompletion(for taskID: String, isCompleted: Bool) {

        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                let request = makeFetchRequest(forID: taskID)
                guard let object = try context.fetch(request).first else {
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
        }
    }

    func deleteItem(with taskID: String) {
        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                let request = makeFetchRequest(forID: taskID)
                guard let object = try context.fetch(request).first else {
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
        }
    }

    private func makeFetchRequest(forID id: String) -> NSFetchRequest<TaskItemManagedObject> {
        let request = TaskItemManagedObject.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "%K == %@", Attribute.id, id)
        return request
    }
}
