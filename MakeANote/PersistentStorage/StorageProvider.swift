import Foundation
import CoreData

enum StorageType {
    case inMemory
    case persisted
}

class StorageProvider {
    static let instance = StorageProvider()
    
    private let coreDateModelFileName = "MyNotes"
    var persistentContainer: NSPersistentContainer
    
    static var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: StorageProvider.self)
        guard let url = bundle.url(forResource: "MyNotes", withExtension: ".momd") else {
            fatalError("Failed to locate momd file")
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to locate momd file")
        }
        return model
    }()
    
    
    init(storageType: StorageType = .persisted) {
        persistentContainer = NSPersistentContainer(name: coreDateModelFileName, managedObjectModel: Self.managedObjectModel)
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load with \(error)")
            }
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
