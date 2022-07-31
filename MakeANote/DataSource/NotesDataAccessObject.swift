import Foundation

struct NotesDataAccessObject<StorageData: StorageDataOperations, Entity: TranslateToMO, ManagedObject:TranslateToEntity> {
    
    private let storageOperation: StorageData
    private let translateToMO: Entity
    private let translateToEntity: ManagedObject
    
    init(storageOperation: StorageData,
         translateToMO: Entity,
         translateToEntity: ManagedObject) {
        self.storageOperation = storageOperation
        self.translateToMO = translateToMO
        self.translateToEntity = translateToEntity
    }
    
    func fetchAllNotes() -> [ManagedObject.Entity] {
        return storageOperation.fetchEntityDetails().compactMap { self.translateToEntity.translateToDTO(from: $0 as! ManagedObject.ManagedObject) }
    }
    
    func storeNote(noteDetails: ManagedObject.Entity) {
        let _ = self.translateToMO.translateToManagedObject(from: noteDetails as! Entity.Entity)
        storageOperation.storeEntityDetails()
    }
    
    func updateNote(noteId: String, noteContent: String) {
        storageOperation.updateEntityDetails(id: noteId, noteContent: noteContent)
    }
    
    func deleteNote(noteId: String) {
        storageOperation.deleteEntityDetails(id: noteId)
    }
}
