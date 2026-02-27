import CoreData
import Foundation

@objc(TaskItemManagedObject)
final class TaskItemManagedObject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var todo: String
    @NSManaged var detailsText: String?
    @NSManaged var createdAt: Date?
    @NSManaged var completed: Bool
    @NSManaged var userID: Int64
}

extension TaskItemManagedObject {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<TaskItemManagedObject> {
        NSFetchRequest<TaskItemManagedObject>(entityName: CoreDataTaskItemsStorage.Entity.name)
    }
}

extension TaskItemManagedObject {
    func apply(_ item: TaskItem, fallbackDate: Date = Date()) {
        id = item.id
        todo = item.todo
        detailsText = item.detailsText
        createdAt = item.createdAt ?? fallbackDate
        completed = item.completed
        userID = Int64(item.userID)
    }

    var domainModel: TaskItem {
        .init(
            id: id,
            todo: todo,
            completed: completed,
            userID: Int(userID),
            detailsText: detailsText,
            createdAt: createdAt
        )
    }
}
