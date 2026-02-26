//
//  UICollectionViewLayout+createSingleListLayout.swift
//  ToDoList
//
//  Created by Данил Албутов on 24.02.2026.
//

import UIKit

extension UICollectionViewLayout {
    static func createSingleListLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = true
        config.separatorConfiguration.color = .appSeparator
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
