import Foundation

protocol PlayerPresenterProtocol: AnyObject {
    var tracksList: [TrackDetail] { get }
    var track: TrackDetail { get }
    var isTrackSaved: Bool { get }
    var albumImageUrl: String? { get }
    func viewDidLoad()
    func heartButtonTapped()
    func playSong()
    func pauseSong()
}

class PlayerPresenter: PlayerPresenterProtocol {
    private var model: PlayerModel
    weak var view: PlayerViewControllerProtocol?
    
    init(view: PlayerViewControllerProtocol, model: PlayerModel) {
        self.view = view
        self.model = model
    }
    
    var tracksList: [TrackDetail] {
        model.tracksList
    }
    
    var track: TrackDetail {
        model.selectedTrack
    }
    
    var isTrackSaved: Bool {
        model.isSavedTrack
    }
    
    var albumImageUrl: String? {
        model.selectedTrack.album?.images.getImageUrl(for: .high) ?? model.albumImageUrl
    }
    
    func viewDidLoad() {
        model.delegate = self
        model.isTrackSaved()
        model.play()
    }
    
    func heartButtonTapped() {
        model.isSavedTrack ? model.removeSavedTrack() : model.saveTrack()
    }
    
    func playSong() {
        model.play()
    }
    
    func pauseSong() {
        model.pause()
    }
}

extension PlayerPresenter: PlayerModelDelegate {
    func didCheckSavedTrack() {
        view?.didCheckSavedTrack()
    }
    
    func didSaveTrack() {
        view?.didSaveTrack()
    }
    
    func didRemoveSavedTrack() {
        view?.didRemoveSavedTrack()
    }
}
