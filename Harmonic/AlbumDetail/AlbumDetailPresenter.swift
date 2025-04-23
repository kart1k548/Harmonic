import Foundation

protocol AlbumDetailPresenterProtocol: AnyObject {
    var albumTracks: [TrackDetail] { get }
    var albumName: String { get }
    var releaseDate: String { get }
    var artists: String { get }
    var albumImageUrl: String { get }
    var albumShareUrl: String { get }
    var isSavedAlbum: Bool { get }
    func viewDidLoad()
    func heartButtonTapped()
}

class AlbumDetailPresenter {
    weak var view: AlbumDetailViewControllerProtocol?
    var model: AlbumDetailModel
    
    init(view: AlbumDetailViewControllerProtocol, model: AlbumDetailModel) {
        self.view = view
        self.model = model
    }
}

extension AlbumDetailPresenter: AlbumDetailPresenterProtocol {
    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        guard let date = dateFormatter.date(from: model.album.releaseDate) else { return model.album.releaseDate }
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateStyle = .medium
        return newDateFormatter.string(from: date)
    }
    
    var albumTracks: [TrackDetail] {
        model.albumTracks
    }
    
    var albumName: String {
        model.album.name
    }
    
    var artists: String {
        model.album.artists.map({ $0.name }).joined(separator: " & ")
    }
    
    var albumImageUrl: String {
        model.album.images.getImageUrl(for: .medium) ?? ""
    }
    
    var albumShareUrl: String {
        model.album.externalUrls.spotify
    }
    
    var isSavedAlbum: Bool {
        model.isSavedAlbum
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.getAlbumTracks()
        model.isAlbumSaved()
    }
    
    func heartButtonTapped() {
        model.isSavedAlbum ? model.removeSavedAlbum() : model.saveAlbum()
    }
}

extension AlbumDetailPresenter: AlbumDetailModelDelegate {
    func didCheckSavedAlbum() {
        view?.didCheckSavedAlbum()
    }
    
    func didSaveAlbum() {
        view?.didSaveAlbum()
    }
    
    func didRemoveSavedAlbum() {
        view?.didRemoveSavedAlbum()
    }
    
    func didReceiveAlbumTracks() {
        view?.didReceiveAlbumTracks()
    }
}
