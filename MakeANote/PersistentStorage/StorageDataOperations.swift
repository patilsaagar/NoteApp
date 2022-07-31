import Foundation

protocol StorageDataOperations {
    associatedtype T
    func fetchEntityDetails() -> [T]
    func storeEntityDetails()
    func updateEntityDetails(id: String, noteContent: String)
    func deleteEntityDetails(id: String)
}

protocol TranslateToEntity {
    associatedtype Entity
    associatedtype ManagedObject
    func translateToDTO(from managedObject: ManagedObject) -> Entity?
}

protocol TranslateToMO {
    associatedtype Entity
    associatedtype ManagedObject
    func translateToManagedObject(from dto: Entity) -> ManagedObject
}
