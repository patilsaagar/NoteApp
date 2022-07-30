import Foundation

struct NoteDetails: Hashable {
    var id: String = UUID().uuidString
    var dateCreated: Date = Date.now
    var description: String = ""

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NoteDetails, rhs: NoteDetails) -> Bool {
      lhs.id == rhs.id
    }
}

enum TableSection: String, CaseIterable {
    case editedNotes = "Last Updated Notes"
    case main = "Notes"
}

