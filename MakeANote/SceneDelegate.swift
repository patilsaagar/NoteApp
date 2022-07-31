import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesListViewController = storyBoard.instantiateViewController(identifier: "NotesListViewController", creator: { coder in
            return NotesListViewController.init(coder: coder, notesDataAccessObject: createNoteDataAccessObject())
        })
        let navigationController = UINavigationController(rootViewController: notesListViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
    }
}

typealias NotesDAO = NotesDataAccessObject<NotesDataRepository, MOTranslator, EntityTranslator>

func createNoteDataAccessObject() -> NotesDAO {
    let notesRepository = NotesDataRepository()
    let mocTranslator = MOTranslator()
    let entityTranslator = EntityTranslator()
    
    let noteDataAccessObject = NotesDataAccessObject(storageOperation: notesRepository, translateToMO: mocTranslator, translateToEntity: entityTranslator)
    
    
    return noteDataAccessObject
}
