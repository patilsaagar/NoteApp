import Foundation

protocol StorageDataOperations {
    associatedtype T
    func fetchAllNotes() -> [T]
    func storeNote()
    func updateNote(noteId: String, noteContent: String)
    func deleteNote(noteId: String)
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
