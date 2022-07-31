import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {

    var noteCreatedCompletion: ((NoteDetails) -> Void)?
    private var notesManager: NotesDAO

    override func viewDidLoad() {
        super.viewDidLoad()
    }
      
    required init?(coder: NSCoder, notesManager: NotesDAO) {
        self.notesManager = notesManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if !textView.text.isEmpty {
            let newNoteDetails = NoteDetails(dateCreated: Date.now, description: textView.text)
            noteCreatedCompletion?(newNoteDetails)
        }
    }
}
