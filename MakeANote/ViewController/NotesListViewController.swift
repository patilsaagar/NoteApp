import UIKit
import Combine

class NotesListViewController: UIViewController {
    // MARK: Private Variables
    private var cancellable = Set<AnyCancellable>()
    private let notesDataAccessObject: NotesDAO
    private var dataSource: DataSource!
    private lazy var searchController: UISearchController = {
        let searchBar = UISearchController(searchResultsController: nil)
        return searchBar
    }()
    
    // MARK: IBOutlet's
    @IBOutlet private weak var createNewNoteButton: UIButton! {
        didSet {
            createNewNoteButton.layer.cornerRadius = createNewNoteButton.frame.width / 2
        }
    }
    @IBOutlet private weak var notesCount: UILabel!
    @IBOutlet private weak var notesTableView: UITableView! {
        didSet {
            let noteDetailsCell = UINib(nibName: NoteDetailsCell.cellIdentifier, bundle: nil)
            notesTableView.register(noteDetailsCell, forCellReuseIdentifier: NoteDetailsCell.cellIdentifier)
        }
    }
    
    required init?(coder: NSCoder, notesDataAccessObject: NotesDAO) {
        self.notesDataAccessObject = notesDataAccessObject
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupSearchBarView()
        applySnapshot(notesData: fetchAllNotesFromStorage())
    }
    
    // MARK: IBAction's
    @IBAction private func editNotes(_ sender: Any) {
        self.notesTableView.isEditing = !self.notesTableView.isEditing
    }
    
    @IBAction func createNewNote() {
        navigateToCreateNoteViewController()
    }
    
    // MARK: Private Methods
    
    private func navigateToCreateNoteViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let createNoteViewController = storyBoard.instantiateViewController(identifier: "CreateNoteViewController") { (coder) -> CreateNoteViewController? in
            
            return CreateNoteViewController(coder: coder, notesManager: createNoteDataAccessObject())
        }
        
        createNoteViewController.noteCreatedCompletion = { [weak self] newNoteData in
            self?.storeNoteToStorage(with: newNoteData)
        }
        
        navigationController?.pushViewController(createNoteViewController, animated: true)
    }
    
    private func navigateToEditNoteViewController(editedNoteDetails: NoteDetails) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editNoteViewController = storyBoard.instantiateViewController(identifier: "EditNoteViewController") { (coder) -> EditNoteViewController? in
            
            return EditNoteViewController(coder: coder, editedNoteDetails: editedNoteDetails)
        }
        
        editNoteViewController.noteEditedCompletion = { [weak self] editedNoteData in
            self?.editNote(with: editedNoteData)
        }
        
        navigationController?.pushViewController(editNoteViewController, animated: true)
    }
    
    private func setupSearchBarView() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.searchTextField.textPublisher
            .sink {[weak self] searchText in
                guard let self = self else { return }
                if searchText.isEmpty {
                    self.applySnapshot(notesData: self.dataSource.snapshot().itemIdentifiers)
                } else {
                    let filteredNotes = self.dataSource.snapshot().itemIdentifiers.filter {
                        $0.description.contains(searchText.lowercased())
                    }
                    self.applySnapshot(notesData: filteredNotes)
                }
            }
            .store(in: &cancellable)
    }
}

extension NotesListViewController: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && string.count == 0) {
            self.applySnapshot(notesData: fetchAllNotesFromStorage())
        }
        return true
    }
}

extension NotesListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.applySnapshot(notesData: fetchAllNotesFromStorage())
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        navigateToEditNoteViewController(editedNoteDetails: note)
    }
}

// Call to CRUD operations
extension NotesListViewController {
    private func editNote(with details: NoteDetails) {
        notesDataAccessObject.updateNote(noteId: details.id, noteContent: details.description)

        var notes = dataSource.snapshot().itemIdentifiers
        if let row = notes.firstIndex(where: { $0.id == details.id }) {
            notes[row] = details
        }
        applySnapshot(notesData: notes, isEdit: true)
    }
    
    private func storeNoteToStorage(with details: NoteDetails) {
        notesDataAccessObject.storeNote(noteDetails: details)

        var notes = dataSource.snapshot().itemIdentifiers
        notes.append(details)
        let updatedNotes = notesDataAccessObject.fetchAllNotes()
        applySnapshot(notesData: updatedNotes)
    }
    
    private func fetchAllNotesFromStorage() -> [NoteDetails] {
        return notesDataAccessObject.fetchAllNotes()
    }
    
    private func deleteNoteFromStorage(with details: NoteDetails) {
        notesDataAccessObject.deleteNote(noteId: details.id)
        var snapShot = dataSource.snapshot()
        snapShot.deleteItems([details])
        applySnapshot(notesData: snapShot.itemIdentifiers)
    }
}

// Diffable data source and Snapshot setup
extension NotesListViewController {
    private func configureDataSource() {
        dataSource = DataSource(tableView: notesTableView,
                                cellProvider:{ (tableView, indexPath, note) -> UITableViewCell in
            
            let noteCell = self.notesTableView.dequeueReusableCell(withIdentifier: NoteDetailsCell.cellIdentifier, for: indexPath) as? NoteDetailsCell
            
            
            noteCell?.configureCell(note: note)
            
            self.dataSource.deleteCompletion = { itemToBeDeleted in
                self.deleteNoteFromStorage(with: itemToBeDeleted)
            }
            
            return noteCell ?? UITableViewCell()
        })
    }
    
    private func applySnapshot(notesData: [NoteDetails], isEdit: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, NoteDetails>()
        snapshot.appendSections([.main])
        snapshot.appendItems(notesData)
        
        if isEdit {
            dataSource.applySnapshotUsingReloadData(snapshot)
        }
             
        dataSource.apply(snapshot, animatingDifferences: true)
        notesCount.text = "\(dataSource.snapshot().itemIdentifiers.count)"
    }
}

