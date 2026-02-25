//
//  UIView+Extension.swift
//  ToDoList
//
//  Created by Данил Албутов on 20.02.2026.
//

import UIKit

extension UIView {
    @nonobjc static var reuseIdentifier: String {
      String(describing: self)
    }
}
