//
//  Date+formattedString.swift
//  ToDoList
//
//  Created by Данил Албутов on 26.02.2026.
//

import Foundation

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
}
