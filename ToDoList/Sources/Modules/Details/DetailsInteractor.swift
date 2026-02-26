import Foundation

final class DetailsInteractor: DetailsInteractorInput {
    weak var output: DetailsInteractorOutput?
    var taskItemsStorage: TaskItemsStorage?
    
    func loadTask(taskID: String?) {
        guard let taskID else {
            output?.didLoadTask(item: nil)
            return
        }
        let item = taskItemsStorage?.loadItem(with: taskID)
        output?.didLoadTask(item: item)
    }
    
    func saveTask(taskID: String?, title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            return
        }
        let trimmedDetailsText = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let detailsText = trimmedDetailsText.isEmpty ? nil : trimmedDetailsText

        if let taskID,
           let existing = taskItemsStorage?.loadItem(with: taskID) {
            let updated = TaskItem(
                id: existing.id,
                todo: trimmedTitle,
                completed: existing.completed,
                userID: existing.userID,
                detailsText: detailsText,
                createdAt: existing.createdAt
            )
            taskItemsStorage?.upsert(item: updated)
            output?.didSaveTask()
            return
        }
        
        let existingItems = taskItemsStorage?.loadItems() ?? []
        let nextID = (existingItems.compactMap({ Int($0.id) }).max() ?? .zero) + 1
        let newItem = TaskItem(
            id: "\(nextID)",
            todo: trimmedTitle,
            completed: false,
            userID: .zero,
            detailsText: detailsText,
            createdAt: Date()
        )
        taskItemsStorage?.upsert(item: newItem)
        output?.didSaveTask()
    }
}
