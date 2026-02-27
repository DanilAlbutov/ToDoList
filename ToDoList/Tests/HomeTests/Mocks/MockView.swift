//
//  MockView.swift
//  ToDoList
//
//  Created by Данил Албутов on 27.02.2026.
//

@testable import ToDoList

final class MockView: HomeViewInput {
    var setupInitialStateCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayListItems: [TaskCollectionViewCellConfiguration]?
    var updateItemArgs: (id: String, items: [TaskCollectionViewCellConfiguration]?)?

    func setupInitialState() { setupInitialStateCalled = true }
    func showLoading() { showLoadingCalled = true }
    func hideLoading() { hideLoadingCalled = true }
    func displayList(items: [TaskCollectionViewCellConfiguration]) {
        displayListItems = items
    }
    func updateItem(with id: String, for items: [TaskCollectionViewCellConfiguration]?) {
        updateItemArgs = (id, items)
    }
}
