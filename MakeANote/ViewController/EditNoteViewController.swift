import UIKit

class EditNoteViewController: UIViewController {

    private var editedNoteDetails: NoteDetails
    var noteEditedCompletion: ((NoteDetails) -> Void)?
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = editedNoteDetails.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder,
                   editedNoteDetails: NoteDetails) {
        self.editedNoteDetails = editedNoteDetails
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        editedNoteDetails.description = textView.text
        editedNoteDetails.dateCreated = Date.now
        
        noteEditedCompletion?(editedNoteDetails)
    }
}
