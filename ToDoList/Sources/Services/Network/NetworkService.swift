//
//  NetworkService.swift
//  ToDoList
//
//  Created by Данил Албутов on 19.02.2026.
//

import Foundation
import Alamofire

protocol NetworkServiceI {    
    func makeRequest<Response: Decodable>(
        request: URLRequestConvertible,
        completion: @escaping (Result<Response, AFError>) -> Void
    )
}


extension NetworkServiceI {
    
    func makeRequest<Response: Decodable>(
        request: URLRequestConvertible,
        completion: @escaping (Result<Response, AFError>) -> Void
    ) {
        AF.request(request)
            .validate()
            .responseDecodable(of: Response.self) { response in                 
                completion(response.result)
            }
    }
}
