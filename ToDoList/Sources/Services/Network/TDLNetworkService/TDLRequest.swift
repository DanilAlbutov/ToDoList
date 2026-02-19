//
//  TDLRequest.swift
//  ToDoList
//
//  Created by Данил Албутов on 20.02.2026.
//

import Foundation
import Alamofire

enum TDLRequest: URLRequestConvertible {
    case getList
    
    var baseURL: URL {
        return Constants.Api.tdlBaseUrl
    }
    
    var path: String {
        switch self {
        case .getList:
            return "/todos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        return request
    }
}
