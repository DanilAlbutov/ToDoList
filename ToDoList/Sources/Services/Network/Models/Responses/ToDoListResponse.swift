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
        let detailsText: String?

        enum CodingKeys: String, CodingKey {
            case id, todo, completed, detailsText
            case userID = "userId"
        }
        
        init(id: Int, todo: String, completed: Bool, userID: Int, detailsText: String? = nil) {
            self.id = id
            self.todo = todo
            self.completed = completed
            self.userID = userID
            self.detailsText = detailsText
        }
    }
    
    let todos: [Item]
    let total, skip, limit: Int
}
