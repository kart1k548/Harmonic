import Foundation

protocol PlaylistDetailPresenterProtocol: AnyObject {
    var playlistTracks: [TrackDetail] { get }
    var playlistName: String { get }
    var playlistImageUrl: String { get }
    var playlistShareUrl: String { get }
    var playlistDescription: String { get }
    func viewDidLoad()
}

class PlaylistDetailPresenter {
    weak var view: PlaylistDetailViewControllerProtocol?
    var model: PlaylistDetailModel
    
    init(view: PlaylistDetailViewControllerProtocol, model: PlaylistDetailModel) {
        self.view = view
        self.model = model
    }
}

extension PlaylistDetailPresenter: PlaylistDetailPresenterProtocol {
    var playlistDescription: String {
        model.playlist.description
    }
    
    var playlistTracks: [TrackDetail] {
        model.playlistTracks
    }
    
    var playlistName: String {
        model.playlist.name
    }
    
    var playlistImageUrl: String {
        model.playlist.images.getImageUrl(for: .medium) ?? ""
    }
    
    var playlistShareUrl: String {
        model.playlist.externalUrls.spotify
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.getPlaylistTracks()
    }
}

extension PlaylistDetailPresenter: PlaylistDetailModelDelegate {
    func didReceivePlaylistTracks() {
        view?.didReceivePlaylistTracks()
    }
}
