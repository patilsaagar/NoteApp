//
//  Translator.swift
//  MakeANote
//
//  Created by sagar patil on 30/07/2022.
//

import Foundation

class MOTranslator: TranslateToMO {
    typealias T = NoteDetails
    typealias U = NoteStorageData
        
    func translateToManagedObject(from dto: NoteDetails) -> NoteStorageData {
        let noteStorage = NoteStorageData(context: StorageProvider.instance.persistentContainer.viewContext)
        noteStorage.noteId = dto.id
        noteStorage.noteContent = dto.description
        noteStorage.lastCreated = dto.dateCreated
        
        return noteStorage
    }
}

class EntityTranslator: TranslateToEntity {
    func translateToDTO(from noteStorageData: NoteStorageData) -> NoteDetails? {
        guard let noteId = noteStorageData.noteId,
              let noteCreateDate = noteStorageData.lastCreated,
              let noteDescription = noteStorageData.noteContent else { return nil }
        return NoteDetails(id: noteId, dateCreated: noteCreateDate, description: noteDescription)
    }
}
