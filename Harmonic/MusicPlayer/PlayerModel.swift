import Foundation

protocol PlayerModelDelegate: AnyObject {
    func didCheckSavedTrack()
    func didSaveTrack()
    func didRemoveSavedTrack()
}

class PlayerModel {
    private let trackService: TrackServiceProtocol
    private let playerService: PlayerServiceProtocol?
    let tracksList: [TrackDetail]
    let selectedTrack: TrackDetail
    let albumImageUrl: String?
    
    private var checkTrackTask: RequestProtocol?
    private var saveTrackTask: RequestProtocol?
    private var removeTrackTask: RequestProtocol?
    
    weak var delegate: PlayerModelDelegate?
    var isSavedTrack: Bool = false
    
    init(trackService: TrackServiceProtocol = TrackService(),
         playerService: PlayerServiceProtocol?,
         tracksList: [TrackDetail] = [],
         track: TrackDetail,
         albumImageUrl: String? = nil) {
        self.trackService = trackService
        self.playerService = playerService
        self.tracksList = tracksList
        self.selectedTrack = track
        self.albumImageUrl = albumImageUrl
    }
    
    func isTrackSaved() {
        checkTrackTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at player to check saved Track")
                return
            }
            guard let self else { return }
            
            checkTrackTask = self.trackService.isTrackSaved(with: session.accessToken, trackId: self.selectedTrack.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.isSavedTrack = response.first ?? false
                        self.delegate?.didCheckSavedTrack()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func saveTrack() {
        saveTrackTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at Player to save Track")
                return
            }
            guard let self else { return }
            
            saveTrackTask = self.trackService.saveTrack(with: session.accessToken, trackId: self.selectedTrack.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isSavedTrack = true
                        self.delegate?.didSaveTrack()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func removeSavedTrack() {
        removeTrackTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at Player to remove Track")
                return
            }
            guard let self else { return }
            
            removeTrackTask = self.trackService.removeSavedTrack(with: session.accessToken, trackId: self.selectedTrack.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isSavedTrack = false
                        self.delegate?.didRemoveSavedTrack()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

extension PlayerModel {
    func play() {
        playerService?.play()
    }
    
    func pause() {
        playerService?.pause()
    }
}
