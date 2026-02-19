//
//  TDLNetworkService.swift
//  ToDoList
//
//  Created by Данил Албутов on 20.02.2026.
//

import Foundation
import Alamofire

protocol TDLNetworkServiceI: NetworkServiceI {
    func getList(completion: @escaping (Result<ToDoListResponse, AFError>) -> Void)
}

final class TDLNetworkService: TDLNetworkServiceI {
    
    func getList(completion: @escaping (Result<ToDoListResponse, AFError>) -> Void) {
        makeRequest(request: TDLRequest.getList, completion: completion)
    }    
    
}
