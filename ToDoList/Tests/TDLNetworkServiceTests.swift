//
//  TDLNetworkServiceTests.swift
//  ToDoList
//
//  Created by Данил Албутов on 27.02.2026.
//

import Testing
@testable import ToDoList
import Alamofire

final class MockNetworkService: TDLNetworkServiceI {
    var lastRequest: URLRequestConvertible?
    var resultToReturn: Result<ToDoListResponse, AFError>?
    
    func getList(completion: @escaping (Result<ToDoListResponse, AFError>) -> Void) {
        makeRequest(request: TDLRequest.getList, completion: completion)
    } 
    
    func makeRequest<Response: Decodable>(
        request: URLRequestConvertible,
        completion: @escaping (Result<Response, AFError>) -> Void
    ) {
        lastRequest = request
        if let resultToReturn = resultToReturn as? Result<Response, AFError> {
            completion(resultToReturn)
        }
    }
}

@Suite("TDLNetworkService Unit Tests")
struct TDLNetworkServiceTests {

    @Test("успешный ответ getList")
    func testGetListSuccess() async throws {
        // Arrange
        let sut = MockNetworkService()
        let expectedResponse = ToDoListResponse(
            todos: [
                .init(id: 1, todo: "Task", completed: false, userID: 1)
            ],
            total: 1, skip: 0, limit: 10
        )
        sut.resultToReturn = .success(expectedResponse)
        var capturedResult: Result<ToDoListResponse, AFError>?
        
        sut.getList { result in capturedResult = result }
        
        switch capturedResult {
        case .success(let response):
            #expect(response.todos.first?.todo == "Task")
        case .failure, .none:
            Issue.record("Response failure or nil")
        }
    }
    
    @Test("ошибка сети getList")
    func testGetListFailure() async throws {
        let sut = MockNetworkService()
        sut.resultToReturn = .failure(AFError.explicitlyCancelled)
        
        var capturedResult: Result<ToDoListResponse, AFError>?
        sut.getList { result in capturedResult = result }
        switch capturedResult {
        case .failure(let error):
            #expect("\(error)" == "\(AFError.explicitlyCancelled)")
        default:
            Issue.record("Response success but expected failure")
        }
    }
}

