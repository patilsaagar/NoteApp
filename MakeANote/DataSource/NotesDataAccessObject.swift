import Foundation

struct NotesDataAccessObject {
    
    private let notesRepository: NotesDataRepository
    private let moTranslator: MOTranslator
    private let entityTranslator: EntityTranslator
    
    init(notesRepository: NotesDataRepository,
         mocTranslator: MOTranslator,
         entityTranslator: EntityTranslator) {
        self.notesRepository = notesRepository
        self.moTranslator = mocTranslator
        self.entityTranslator = entityTranslator
    }
    
    func fetchAllNotes() -> [NoteDetails] {
        return notesRepository.fetchAllNotes().compactMap { self.entityTranslator.translateToDTO(from: $0) }
    }
    
    func storeNote(noteDetails: NoteDetails) {
        let _ = self.moTranslator.translateToManagedObject(from: noteDetails)
        notesRepository.storeNote()
    }
    
    func updateNote(noteDetails: NoteDetails) {
        notesRepository.updateNote(noteId: noteDetails.id, noteContent: noteDetails.description)
    }
    
    func deleteNote(note: NoteDetails) {
        notesRepository.deleteNote(noteId: note.id)
    }
}
