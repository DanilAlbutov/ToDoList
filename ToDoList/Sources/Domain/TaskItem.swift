import Foundation

struct TaskItem {
    let id: String
    let todo: String
    let completed: Bool
    let userID: Int
    let detailsText: String?
    let createdAt: Date?
}

extension TaskItem {
    init(responseItem: ToDoListResponse.Item) {
        self.id = "\(responseItem.id)"
        self.todo = responseItem.todo
        self.completed = responseItem.completed
        self.userID = responseItem.userID
        self.detailsText = "User id: \(userID), task id: \(id)"
        self.createdAt = Date()
    }
}
