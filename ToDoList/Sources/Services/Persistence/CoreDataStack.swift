import CoreData
import Foundation

final class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func makeBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
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
        
        let attributesInfo: [(CoreDataTaskItemsStorage.Attribute, NSAttributeType, Bool)] = [
            (.id, .stringAttributeType, false),
            (.todo, .stringAttributeType, false),
            (.detailsText, .stringAttributeType, true),
            (.createdAt, .dateAttributeType, true),
            (.completed, .booleanAttributeType, false),
            (.userID, .integer64AttributeType, false)
        ]            

        let entity = NSEntityDescription()
        entity.name = CoreDataTaskItemsStorage.Entity.name
        entity.managedObjectClassName = NSStringFromClass(TaskItemManagedObject.self)

        entity.properties = attributesInfo.map({
            let attribute = NSAttributeDescription()
            attribute.name = $0.0.rawValue
            attribute.attributeType = $0.1
            attribute.isOptional = $0.2
            return attribute
        })

        let uniqueConstraint = [CoreDataTaskItemsStorage.Attribute.id.rawValue]
        entity.uniquenessConstraints = [uniqueConstraint]

        model.entities = [entity]
        return model
    }
}
