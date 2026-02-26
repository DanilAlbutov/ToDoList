//
//  ToDoListResponse.swift
//  ToDoList
//
//  Created by Данил Албутов on 19.02.2026.
//

import Foundation

// MARK: - ToDoListResponse
struct ToDoListResponse: Codable {
    struct Item: Codable {
        let id: Int
        let todo: String
        let completed: Bool
        let userID: Int

        enum CodingKeys: String, CodingKey {
            case id, todo, completed
            case userID = "userId"
        }
    }
    
    let todos: [Item]
    let total, skip, limit: Int
}
