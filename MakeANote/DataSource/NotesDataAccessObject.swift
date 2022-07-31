import Foundation

struct NotesDataAccessObject<S: StorageDataOperations, T: TranslateToMO, U:TranslateToEntity> {
    
    private let storageOperation: S
    private let translateToMO: T
    private let translateToEntity: U
    
    init(storageOperation: S,
         translateToMO: T,
         translateToEntity: U) {
        self.storageOperation = storageOperation
        self.translateToMO = translateToMO
        self.translateToEntity = translateToEntity
    }
    
    func fetchAllNotes() -> [U.T] {
        return storageOperation.fetchEntityDetails().compactMap { self.translateToEntity.translateToDTO(from: $0 as! U.U) }
    }
    
    func storeNote(noteDetails: U.T) {
        let _ = self.translateToMO.translateToManagedObject(from: noteDetails as! T.T)
        storageOperation.storeEntityDetails()
    }
    
    func updateNote(noteId: String, noteContent: String) {
        storageOperation.updateEntityDetails(noteId: noteId, noteContent: noteContent)
    }
    
    func deleteNote(noteId: String) {
        storageOperation.deleteEntityDetails(noteId: noteId)
    }
}
