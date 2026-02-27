import Foundation

final class DetailsInteractor: DetailsInteractorInput {
    weak var output: DetailsInteractorOutput?
    var taskItemsStorage: TaskItemsStorage?
    
    func loadTask(taskID: String?) {
        guard let taskID else {
            output?.didLoadTask(item: nil)
            return
        }
        taskItemsStorage?.loadItem(with: taskID) { [weak self] item in
            self?.output?.didLoadTask(item: item)
        }
    }
    
    func saveTask(taskID: String?, title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            return
        }
        let trimmedDetailsText = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let detailsText = trimmedDetailsText.isEmpty ? nil : trimmedDetailsText

        if let taskID {
            taskItemsStorage?.loadItem(with: taskID) { [weak self] existing in
                guard let self else { return }
                if let existing {
                    let updated = TaskItem(
                        id: existing.id,
                        todo: trimmedTitle,
                        completed: existing.completed,
                        userID: existing.userID,
                        detailsText: detailsText,
                        createdAt: existing.createdAt
                    )
                    self.taskItemsStorage?.insert(item: updated) { [weak self] in
                        self?.output?.didSaveTask()
                    }
                    return
                }
                self.createTask(
                    title: trimmedTitle,
                    detailsText: detailsText
                )
            }
            return
        }

        createTask(
            title: trimmedTitle,
            detailsText: detailsText
        )
    }
}

private extension DetailsInteractor {
    func createTask(title: String, detailsText: String?) {
        taskItemsStorage?.loadItems { [weak self] _ in
            guard let self else { return }
            let newItem = TaskItem(
                id: UUID().uuidString,
                todo: title,
                completed: false,
                userID: .zero,
                detailsText: detailsText,
                createdAt: Date()
            )
            self.taskItemsStorage?.insert(item: newItem) { [weak self] in
                self?.output?.didSaveTask()
            }
        }
    }
}
