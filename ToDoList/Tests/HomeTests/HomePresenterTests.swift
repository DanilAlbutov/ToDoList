import Testing
import Foundation
@testable import ToDoList

@Suite("HomePresenter")
struct HomePresenterTests {
    
    func makePresenter() -> (HomePresenter, MockView, MockInteractor, MockRouter) {
        let presenter = HomePresenter()
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        return (presenter, view, interactor, router)
    }

    func makeTask(id: String = "1", todo: String = "Test", completed: Bool = false) -> TaskItem {
        TaskItem(id: id, todo: todo, completed: completed, userID: 1, detailsText: "Details", createdAt: Date())
    }

    // MARK: - Тесты

    @Test("viewDidLoad вызывает setupInitialState, showLoading и onLoad")
    func test_viewDidLoad() async throws {
        let (presenter, view, interactor, _) = makePresenter()
        presenter.viewDidLoad()
        #expect(view.setupInitialStateCalled)
        #expect(view.showLoadingCalled)
        #expect(interactor.onLoadCalled)
    }

    @Test("viewWillAppear вызывает loadStoredTasks")
    func test_viewWillAppear() async throws {
        let (presenter, _, interactor, _) = makePresenter()
        presenter.viewWillAppear()
        #expect(interactor.loadStoredTasksCalled)
    }

    @Test("searchTextDidChange фильтрует видимые элементы")
    func test_searchTextDidChange() async throws {
        let (presenter, view, _, _) = makePresenter()
        let item1 = makeTask(id: "1", todo: "Купить молоко")
        let item2 = makeTask(id: "2", todo: "Сделать дз")
        presenter.listLoaded(items: [item1, item2])
        presenter.searchTextDidChange("молоко")
        #expect(view.displayListItems?.count == 1)
        #expect(view.displayListItems?.first?.id == item1.id)
    }

    @Test("taskSelectionDidChange обновляет выбор, вызывает interactor и view")
    func test_taskSelectionDidChange() async throws {
        let (presenter, view, interactor, _) = makePresenter()
        let item = makeTask(id: "123", completed: false)
        presenter.listLoaded(items: [item])
        presenter.taskSelectionDidChange(taskID: "123", isSelected: true)
        #expect(interactor.saveTaskSelectionArgs?.taskID == "123")
        #expect(interactor.saveTaskSelectionArgs?.isSelected == true)
        #expect(view.updateItemArgs?.id == "123")
        #expect(view.updateItemArgs?.items != nil)
    }

    @Test("checkButtonTapped инвертирует completed")
    func test_checkButtonTapped() async throws {
        let (presenter, _, interactor, _) = makePresenter()
        let item = makeTask(id: "321", completed: false)
        presenter.listLoaded(items: [item])
        presenter.checkButtonTapped(taskID: "321")
        #expect(interactor.saveTaskSelectionArgs?.isSelected == true)
    }

    @Test("didTapCreateTask вызывает openCreateTask у router")
    func test_didTapCreateTask() async throws {
        let (presenter, _, _, router) = makePresenter()
        presenter.didTapCreateTask()
        #expect(router.openCreateTaskCalled)
    }

    @Test("didTapEdit вызывает openEditTask у router")
    func test_didTapEdit() async throws {
        let (presenter, _, _, router) = makePresenter()
        presenter.didTapEdit(taskID: "555")
        #expect(router.openEditTaskArgs?.taskID == "555")
    }

    @Test("didTapShare вызывает openShareSheet c текстом задачи")
    func test_didTapShare() async throws {
        let (presenter, _, _, router) = makePresenter()
        let item = makeTask(id: "1", todo: "Buy eggs", completed: false)
        presenter.listLoaded(items: [item])
        presenter.didTapShare(taskID: "1")
        #expect(router.openShareSheetArg?.contains("Buy eggs") == true)
        #expect(router.openShareSheetArg?.contains("Details") == true)
    }

    @Test("didTapDelete удаляет элемент, вызывает interactor и обновляет view")
    func test_didTapDelete() async throws {
        let (presenter, view, interactor, _) = makePresenter()
        let item = makeTask(id: "1")
        presenter.listLoaded(items: [item])
        presenter.didTapDelete(taskID: "1")
        #expect(interactor.deleteTaskArg == "1")
        #expect(view.displayListItems?.count == 0)
    }

    @Test("listLoaded обновляет состояние и скрывает лоадер")
    func test_listLoaded() async throws {
        let (presenter, view, _, _) = makePresenter()
        let items = [makeTask(id: "1"), makeTask(id: "2")]
        presenter.listLoaded(items: items)
        #expect(view.displayListItems?.count == 2)
        #expect(view.hideLoadingCalled)
    }

    @Test("listLoadingFailed скрывает лоадер и вызывает алерт")
    func test_listLoadingFailed() async throws {
        let (presenter, _, _, router) = makePresenter()
        presenter.listLoadingFailed(message: "Ошибка")
        #expect(router.openErrorAlertArg == "Ошибка")
    }

    @Test("detailsModuleDidFinishCreatingTask вызывает reload tasks")
    func test_detailsModuleDidFinishCreatingTask() async throws {
        let (presenter, _, interactor, _) = makePresenter()
        presenter.detailsModuleDidFinishCreatingTask()
        #expect(interactor.loadStoredTasksCalled)
    }

    @Test("detailsModuleDidFinishEditing вызывает reload и обновляет элемент")
    func test_detailsModuleDidFinishEditing() async throws {
        let (presenter, view, interactor, _) = makePresenter()
        presenter.detailsModuleDidFinishEditing(taskWith: "77")
        #expect(interactor.loadStoredTasksCalled)
        #expect(view.updateItemArgs?.id == "77")
    }
}
