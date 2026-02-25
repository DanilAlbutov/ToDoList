import CoreData
import Foundation

protocol TaskItemsStorage {
    func loadItems() -> [ToDoListResponse.Item]
    func save(items: [ToDoListResponse.Item], overrideOldCompletion: Bool)
    func updateCompletion(for taskID: String, isCompleted: Bool)
}

final class CoreDataTaskItemsStorage: TaskItemsStorage {
    enum Entity {
        static let name = "TaskItem"
    }

    enum Attribute {
        static let id = "id"
        static let todo = "todo"
        static let completed = "completed"
        static let userID = "userID"
    }

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func loadItems() -> [ToDoListResponse.Item] {
        let context = coreDataStack.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: Entity.name)
        request.sortDescriptors = [NSSortDescriptor(key: Attribute.id, ascending: true)]

        var items: [ToDoListResponse.Item] = []
        context.performAndWait {
            do {
                let objects = try context.fetch(request)
                for object in objects {
                    guard
                        let id = object.value(forKey: Attribute.id) as? Int64,
                        let todo = object.value(forKey: Attribute.todo) as? String,
                        let completed = object.value(forKey: Attribute.completed) as? Bool,
                        let userID = object.value(forKey: Attribute.userID) as? Int64
                    else {
                        continue
                    }
                    items.append(
                        .init(
                            id: Int(id),
                            todo: todo,
                            completed: completed,
                            userID: Int(userID)
                        )
                    )
                }
            } catch {
                print("Failed to fetch task items: \(error)")
            }
        }

        return items
    }

    func save(items: [ToDoListResponse.Item], overrideOldCompletion: Bool) {
        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                for item in items {
                    let request = NSFetchRequest<NSManagedObject>(entityName: Entity.name)
                    request.fetchLimit = 1
                    request.predicate = NSPredicate(format: "%K == %d", Attribute.id, item.id)

                    let object = try context.fetch(request).first
                        ?? NSEntityDescription.insertNewObject(forEntityName: Entity.name, into: context)

                    object.setValue(Int64(item.id), forKey: Attribute.id)
                    object.setValue(item.todo, forKey: Attribute.todo)
                    if overrideOldCompletion {
                        object.setValue(item.completed, forKey: Attribute.completed)
                    }
                    object.setValue(Int64(item.userID), forKey: Attribute.userID)
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

    func updateCompletion(for taskID: String, isCompleted: Bool) {
        guard let id = Int64(taskID) else {
            return
        }

        let context = coreDataStack.viewContext

        context.performAndWait {
            do {
                let request = NSFetchRequest<NSManagedObject>(entityName: Entity.name)
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "%K == %d", Attribute.id, id)

                guard let object = try context.fetch(request).first else {
                    return
                }

                object.setValue(isCompleted, forKey: Attribute.completed)

                if context.hasChanges {
                    try context.save()
                }
            } catch {
                context.rollback()
                print("Failed to update task completion: \(error)")
            }
        }
    }
}
