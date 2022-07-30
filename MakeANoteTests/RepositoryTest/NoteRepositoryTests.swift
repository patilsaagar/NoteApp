import XCTest
import CoreData
@testable import MakeANote

class NoteRepositoryTests: XCTestCase {
    var storeProviderStack: StorageProviderStack!
    var noteRepository: NotesDataRepository!
    
    override func setUp() {
        super.setUp()
        storeProviderStack = StorageProviderStack()
        noteRepository = NotesDataRepository(viewContext: storeProviderStack.persistentContainer.viewContext)
    }
    
    func test_create_note() {
        // Arrange
        let noteDetails = NoteDetails(id: UUID().uuidString, dateCreated: Date.now, description: "This is first note")
        let _ = translateToManagedObject(from: noteDetails)
        noteRepository.storeNote()
        
        // Act
        let fetchedNoteDetails = noteRepository.fetchAllNotes()
        
        // Assert
        XCTAssertEqual(fetchedNoteDetails.first?.noteContent, "This is first note")
    }
    
    func test_update_note() {
        // Arrange
        let noteDetails = NoteDetails(id: UUID().uuidString, dateCreated: Date.now, description: "This is first note")
        let _ = translateToManagedObject(from: noteDetails)
        noteRepository.storeNote()

        // Act
        noteRepository.updateNote(noteId: noteDetails.id, noteContent: "This is updated note")
        
        let fetchedNoteDetailsAfterUpdate = noteRepository.fetchAllNotes()

        // Assert
        XCTAssertEqual(fetchedNoteDetailsAfterUpdate.first?.noteContent, "This is updated note")
    }
    
    func test_delete_note() {
        // Arrange
        let secondNote = NoteDetails(id: UUID().uuidString, dateCreated: Date.now, description: "This is second note")
        let _ = translateToManagedObject(from: secondNote)
        
        let thirdNote = NoteDetails(id: UUID().uuidString, dateCreated: Date.now, description: "This is third note")
        let _ = translateToManagedObject(from: thirdNote)

        noteRepository.storeNote()

        // Act
        noteRepository.deleteNote(noteId: secondNote.id)

        let fetchedNoteDetailsAfterDeletion = noteRepository.fetchAllNotes()

        // Assert
        XCTAssertEqual(fetchedNoteDetailsAfterDeletion.count, 1)
        XCTAssertEqual(fetchedNoteDetailsAfterDeletion.first?.noteContent, "This is third note")
    }

        
    private func translateToManagedObject(from dto: NoteDetails) -> NoteStorageData {
        
        let noteStorage = NoteStorageData(context: storeProviderStack.persistentContainer.viewContext)
        noteStorage.noteId = dto.id
        noteStorage.noteContent = dto.description
        noteStorage.lastCreated = dto.dateCreated
        
        return noteStorage
    }
}
