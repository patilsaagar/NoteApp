import UIKit

class NoteDetailsCell: UITableViewCell {
    static let cellIdentifier = "NoteDetailsCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    func configureCell(note: NoteDetails) {
        
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy, h:mm a"

        self.titleLabel.text = note.description
        self.createdDateLabel.text = dateFormatter.string(from: date)
    }
    
}
