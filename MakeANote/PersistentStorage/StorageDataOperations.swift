import Foundation

protocol StorageDataOperations {
    associatedtype T
    func fetchEntityDetails() -> [T]
    func storeEntityDetails()
    func updateEntityDetails(id: String, noteContent: String)
    func deleteEntityDetails(id: String)
}

protocol TranslateToEntity {
    associatedtype T
    associatedtype U
    func translateToDTO(from managedObject: U) -> T?
}

protocol TranslateToMO {
    associatedtype T
    associatedtype U
    func translateToManagedObject(from dto: T) -> U
}
