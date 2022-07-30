import Foundation
import CoreData

struct NotesDataRepository: StorageDataOperations {
    typealias T = NoteStorageData
    
    private let viewContext: NSManagedObjectContext
    
    init (viewContext: NSManagedObjectContext = StorageProvider.instance.persistentContainer.viewContext) {
        self.viewContext = viewContext
    }
    // MARK: Public Methods
    
    func fetchAllNotes() -> [NoteStorageData] {
        let fetchRequest: NSFetchRequest<NoteStorageData> = NoteStorageData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \NoteStorageData.noteId, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let noteStorageData:[NoteStorageData] = (try? viewContext.fetch(fetchRequest)) ?? []
        
        return noteStorageData
    }
    
    
    func storeNote() {
        StorageProvider.instance.saveContext()
    }
    
    func updateNote(noteId: String, noteContent: String) {
        let objectToBeModified = getNote(by: noteId)

        objectToBeModified?.noteContent = noteContent
        objectToBeModified?.lastCreated = Date.now
        
        StorageProvider.instance.saveContext()
        
    }
    
    func deleteNote(noteId: String) {
        guard let objectToBeDeleted = getNote(by: noteId) else { return }
        
        viewContext.delete(objectToBeDeleted)
        StorageProvider.instance.saveContext()
    }
    
    private func getNote(by id: String) -> NoteStorageData? {
        let fetchRequest: NSFetchRequest<NoteStorageData> = NoteStorageData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "noteId == %@", id)
        
        guard let objectToBeModified =  try? viewContext.fetch(fetchRequest).first else { return nil }
        
        return objectToBeModified
    }
}
