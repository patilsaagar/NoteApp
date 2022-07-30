import UIKit

class DataSource: UITableViewDiffableDataSource<TableSection, NoteDetails> {
    
    var deleteCompletion: ((NoteDetails) -> Void)?
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = itemIdentifier(for: indexPath) {
                self.deleteCompletion?(item)
            }
        }
    }
}
