import Testing
@testable import ToDoList
import CoreData

@Suite("CoreDataTaskItemsStorage")
struct CoreDataTaskItemsStorageTests : ~Copyable {
    var coreDataStack: CoreDataStack
    var storage: CoreDataTaskItemsStorage

    init() async throws {
        coreDataStack = CoreDataStack(inMemory: true)
        storage = CoreDataTaskItemsStorage(coreDataStack: coreDataStack)
    }

    private func makeTask(
        id: String = UUID().uuidString,
        completed: Bool = false
    ) -> TaskItem {
        TaskItem(
            id: id,
            todo: "Test Task",
            completed: completed,
            userID: 42,
            detailsText: "Some details",
            createdAt: Date()
        )
    }

    @Test("Вставка и загрузка")
    func insertAndLoad() async throws {
        let task = makeTask()
        let storage = self.storage

        await withCheckedContinuation { cont in
            storage.insert(item: task) {
                storage.loadItems { items in
                    #expect(items.count == 1)
                    #expect(items.first?.id == task.id)
                    cont.resume()
                }
            }
        }
    }

    @Test("Загрузка по id")
    func loadByID() async throws {
        let task = makeTask()
        let storage = self.storage

        await withCheckedContinuation { cont in
            storage.insert(item: task) {
                storage.loadItem(with: task.id) { fetched in
                    #expect(fetched != nil)
                    #expect(fetched?.id == task.id)
                    cont.resume()
                }
            }
        }
    }

    @Test("Обновление completed")
    func updateCompletion() async throws {
        let task = makeTask(completed: false)
        let storage = self.storage

        await withCheckedContinuation { cont in
            storage.insert(item: task) {
                storage.updateCompletion(for: task.id, isCompleted: true) {
                    storage.loadItem(with: task.id) { changed in
                        #expect(changed?.completed == true)
                        cont.resume()
                    }
                }
            }
        }
    }

    @Test("Удаление задачи")
    func deleteItem() async throws {
        let task = makeTask()
        let storage = self.storage

        await withCheckedContinuation { cont in
            storage.insert(item: task) {
                storage.deleteItem(with: task.id) {
                    storage.loadItems { items in
                        #expect(items.isEmpty)
                        cont.resume()
                    }
                }
            }
        }
    }
}
