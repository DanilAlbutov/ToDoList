import CoreData
import Foundation

final class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(containerName: String = "ToDoListModel", inMemory: Bool = false) {
        let model = Self.makeModel()
        persistentContainer = NSPersistentContainer(name: containerName, managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.persistentStoreDescriptions.forEach {
            $0.shouldMigrateStoreAutomatically = true
            $0.shouldInferMappingModelAutomatically = true
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = CoreDataTaskItemsStorage.Entity.name
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)

        let idAttribute = NSAttributeDescription()
        idAttribute.name = CoreDataTaskItemsStorage.Attribute.id
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false

        let todoAttribute = NSAttributeDescription()
        todoAttribute.name = CoreDataTaskItemsStorage.Attribute.todo
        todoAttribute.attributeType = .stringAttributeType
        todoAttribute.isOptional = false
        
        let detailsTextAttribute = NSAttributeDescription()
        detailsTextAttribute.name = CoreDataTaskItemsStorage.Attribute.detailsText
        detailsTextAttribute.attributeType = .stringAttributeType
        detailsTextAttribute.isOptional = true

        let completedAttribute = NSAttributeDescription()
        completedAttribute.name = CoreDataTaskItemsStorage.Attribute.completed
        completedAttribute.attributeType = .booleanAttributeType
        completedAttribute.isOptional = false

        let userIDAttribute = NSAttributeDescription()
        userIDAttribute.name = CoreDataTaskItemsStorage.Attribute.userID
        userIDAttribute.attributeType = .integer64AttributeType
        userIDAttribute.isOptional = false

        entity.properties = [
            idAttribute,
            todoAttribute,
            detailsTextAttribute,
            completedAttribute,
            userIDAttribute
        ]

        let uniqueConstraint = [CoreDataTaskItemsStorage.Attribute.id]
        entity.uniquenessConstraints = [uniqueConstraint]

        model.entities = [entity]
        return model
    }
}
