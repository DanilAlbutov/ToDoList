import Testing
import Foundation
import Alamofire
@testable import ToDoList

@Suite("HomeInteractor Unit Tests")
struct HomeInteractorTests {
    func makeSUT() -> (HomeInteractor, MockNetworkService, MockTaskItemsStorage, MockHomeInteractorOutput) {
        let interactor = HomeInteractor()
        let network = MockNetworkService()
        let storage = MockTaskItemsStorage()
        let output = MockHomeInteractorOutput()
        interactor.networkService = network
        interactor.taskItemsStorage = storage
        interactor.output = output
        return (interactor, network, storage, output)
    }
    
    private func makeTask(id: String = "1", title: String = "Test", completed: Bool = false) -> TaskItem {
        TaskItem(id: id, todo: title, completed: completed, userID: 1, detailsText: "Details", createdAt: Date())
    }
    
    @Test("onLoad: ошибка сети — грузит из хранилища и фейлит если нет")
    func test_onLoad_failure() async throws {
        let (sut, network, storage, output) = makeSUT()
        let ecpectedErrorMessage = AFError.explicitlyCancelled.localizedDescription
        network.resultToReturn = .failure(AFError.explicitlyCancelled)
        sut.onLoad()
        
        #expect(output.listLoadingFailedMessage == ecpectedErrorMessage)
    }
    
    @Test("loadStoredTasks вызывает loadItems и output.listLoaded")
    func test_loadStoredTasks() async throws {
        let (sut, _, storage, output) = makeSUT()
        let task = makeTask()
        storage.itemsToReturn = [task]
        await withCheckedContinuation { cont in
            sut.loadStoredTasks()
            storage.loadItems { _ in cont.resume() }
        }
        #expect(output.listLoadedItems?.count == 1)
        #expect(output.listLoadedItems?.first?.id == task.id)
    }
    
    @Test("saveTaskSelection вызывает updateCompletion")
    func test_saveTaskSelection() async throws {
        let (sut, _, storage, _) = makeSUT()
        sut.saveTaskSelection(taskID: "1", isSelected: true)
        #expect(storage.updateCompletionArgs?.taskID == "1")
        #expect(storage.updateCompletionArgs?.isCompleted == true)
    }
    
    @Test("deleteTask вызывает deleteItem")
    func test_deleteTask() async throws {
        let (sut, _, storage, _) = makeSUT()
        sut.deleteTask(taskID: "2")
        #expect(storage.deleteItemArg == "2")
    }
}

