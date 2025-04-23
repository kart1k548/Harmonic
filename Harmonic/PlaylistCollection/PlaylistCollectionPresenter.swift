import Foundation

protocol PlaylistCollectionPresenterProtocol: AnyObject {
    var receivedPlaylists: [Playlist] { get }
    func viewDidLoad()
}

class PlaylistCollectionPresenter {
    weak var view: PlaylistCollectionViewControllerProtocol?
    var model: PlaylistCollectionModel
    
    init(view: PlaylistCollectionViewControllerProtocol, model: PlaylistCollectionModel) {
        self.view = view
        self.model = model
    }
}

extension PlaylistCollectionPresenter: PlaylistCollectionPresenterProtocol {
    var receivedPlaylists: [Playlist] {
        guard let playlists = model.searchResponse.playlists else { return [] }
        
        return playlists.getSpecificItems()
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.getPlaylists()
    }
}

extension PlaylistCollectionPresenter: PlaylistCollectionModelDelegate {
    func didReceivePlaylists() {
        view?.didReceivePlaylists()
    }
}

