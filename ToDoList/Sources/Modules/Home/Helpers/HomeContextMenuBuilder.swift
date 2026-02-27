//
//  HomeContextMenuBuilder.swift
//  ToDoList
//
//  Created by Данил Албутов on 26.02.2026.
//

import UIKit

struct HomeContextMenuBuilder {
    static func makeContextMenuAction(
        identifier: any NSCopying,
        previewProvider: UIContextMenuContentPreviewProvider?,
        onEdit: @escaping UIActionHandler,
        onShare: @escaping UIActionHandler,
        onDelete: @escaping UIActionHandler
    ) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: previewProvider) { _ in
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil"),
                handler: onEdit
            )

            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up"),
                handler: onShare
            )

            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive,
                handler: onDelete
            )

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
