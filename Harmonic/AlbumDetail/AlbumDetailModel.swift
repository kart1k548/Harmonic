import Foundation

protocol AlbumDetailModelDelegate: AnyObject {
    func didReceiveAlbumTracks()
    func didCheckSavedAlbum()
    func didSaveAlbum()
    func didRemoveSavedAlbum()
}

class AlbumDetailModel {
    private let albumService: AlbumServiceProtocol
    private let trackService: TrackServiceProtocol
    
    private var getAlbumTask: RequestProtocol?
    private var checkAlbumTask: RequestProtocol?
    private var saveAlbumTask: RequestProtocol?
    private var removeAlbumTask: RequestProtocol?
    
    var albumTracks: [TrackDetail] = []
    var isSavedAlbum: Bool = false
    let album: Album
    
    weak var delegate: AlbumDetailModelDelegate?
    
    init(albumService: AlbumServiceProtocol = AlbumService(),
         trackService: TrackServiceProtocol = TrackService(),
         album: Album
    ) {
        self.albumService = albumService
        self.trackService = trackService
        self.album = album
    }
    
    func getAlbumTracks() {
        getAlbumTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at album detail to fetch tracks")
                return
            }
            guard let self else { return }
            
            getAlbumTask = self.albumService.getAlbumTracks(with: session.accessToken, albumId: self.album.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.albumTracks = response.items
                        self.delegate?.didReceiveAlbumTracks()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func isAlbumSaved() {
        checkAlbumTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at album detail to check saved album")
                return
            }
            guard let self else { return }
            
            checkAlbumTask = self.albumService.isAlbumSaved(with: session.accessToken, albumId: self.album.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.isSavedAlbum = response.first ?? false
                        self.delegate?.didCheckSavedAlbum()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func saveAlbum() {
        saveAlbumTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at album detail to save album")
                return
            }
            guard let self else { return }
            
            saveAlbumTask = self.albumService.saveAlbum(with: session.accessToken, albumId: self.album.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isSavedAlbum = true
                        self.delegate?.didSaveAlbum()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func removeSavedAlbum() {
        removeAlbumTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at album detail to remove album")
                return
            }
            guard let self else { return }
            
            removeAlbumTask = self.albumService.removeSavedAlbum(with: session.accessToken, albumId: self.album.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.isSavedAlbum = false
                        self.delegate?.didRemoveSavedAlbum()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
