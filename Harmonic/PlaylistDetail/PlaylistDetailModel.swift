import Foundation

protocol PlaylistDetailModelDelegate: AnyObject {
    func didReceivePlaylistTracks()
}

class PlaylistDetailModel {
    private let playlistService: PlaylistServiceProtocol
    private let trackService: TrackServiceProtocol
    
    private var getPlaylistTask: RequestProtocol?
    
    var playlistTracks: [TrackDetail] = []
    let playlist: Playlist
    
    weak var delegate: PlaylistDetailModelDelegate?
    
    init(playlistService: PlaylistServiceProtocol = PlaylistService(),
         trackService: TrackServiceProtocol = TrackService(),
         playlist: Playlist
    ) {
        self.playlistService = playlistService
        self.trackService = trackService
        self.playlist = playlist
    }
    
    func getPlaylistTracks() {
        getPlaylistTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at Playlist detail to fetch tracks")
                return
            }
            guard let self else { return }
            
            getPlaylistTask = self.playlistService.getPlaylistDetails(with: session.accessToken, playlistId: self.playlist.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if let tracks = response.tracks.items?.compactMap({
                            $0.track.name.isEmpty || $0.track.duration == 0 ? nil : $0.track
                        }) {
                            self.playlistTracks = tracks
                            self.delegate?.didReceivePlaylistTracks()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
