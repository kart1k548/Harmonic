import Foundation

protocol SearchResultsPresenterProtocol: AnyObject {
    var receivedTracks: [TrackDetail] { get }
    var receivedAlbums: [Album] { get }
    var receivedShows: [Show] { get }
    var receivedEpisodes: [Episode] { get }
    var receivedPlaylists: [Playlist] { get }
    var receivedArtists: [Artist] { get }
    var receivedAudiobooks: [Audiobook] { get }
    var selectedFilter: SearchCategory { get set }
    var sectionIndx: Int { get }
    var searchText: String { get set }
}

class SearchResultsPresenter {
    private var model: SearchResultsModel
    weak var view: SearchResultsViewControllerProtocol?
    
    init(view: SearchResultsViewControllerProtocol, model: SearchResultsModel) {
        self.view = view
        self.model = model
        self.model.delegate = self
    }
}

extension SearchResultsPresenter: SearchResultsPresenterProtocol {
    var sectionIndx: Int {
        switch selectedFilter {
        case .track: return 0
        case .album: return 1
        case .playlist: return 2
        case .artist: return 3
        default: return 0
        }
    }
    
    var searchText: String {
        get {
            model.searchText
        }
        set {
            model.searchText = newValue
            model.getSearch()
        }
    }
    
    var selectedFilter: SearchCategory {
        get {
            return model.selectedFilter
        }
        set {
            model.selectedFilter = newValue
            model.searchCategories = newValue != .none ? [newValue] : [.album, .track, .playlist, .artist]
        }
    }
    
    var receivedTracks: [TrackDetail] {
        guard let tracks = model.searchResults.tracks else { return [] }
        
        return tracks.getSpecificItems()
    }
    
    var receivedAlbums: [Album] {
        guard let albums = model.searchResults.albums else { return [] }
        
        return albums.getSpecificItems()
    }
    
    var receivedShows: [Show] {
        guard let shows = model.searchResults.shows else { return [] }
        
        return shows.getSpecificItems()
    }
    
    var receivedEpisodes: [Episode] {
        guard let episodes = model.searchResults.episodes else { return [] }
        
        return episodes.getSpecificItems()
    }
    
    var receivedPlaylists: [Playlist] {
        guard let playlists = model.searchResults.playlists else { return [] }
        
        return playlists.getSpecificItems()
    }
    
    var receivedArtists: [Artist] {
        guard let artists = model.searchResults.artists else { return [] }
        
        return artists.getSpecificItems()
    }
    
    var receivedAudiobooks: [Audiobook] {
        guard let audiobooks = model.searchResults.audiobooks else { return [] }
        
        return audiobooks.getSpecificItems()
    }
}

extension SearchResultsPresenter: SearchResultsModelDelegate {
    func didReceiveSearch() {
        view?.didReceiveSearch()
    }
}
