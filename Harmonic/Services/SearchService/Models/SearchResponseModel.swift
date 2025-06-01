import Foundation

struct SearchResponseModel: Decodable {
    let tracks: SearchItems?
    let albums: SearchItems?
    let artists: SearchItems?
    let playlists: SearchItems?
    let shows: SearchItems?
    let episodes: SearchItems?
    let audiobooks: SearchItems?
    
    init(tracks: SearchItems? = nil,
         albums: SearchItems? = nil,
         artists: SearchItems? = nil,
         playlists: SearchItems? = nil,
         shows: SearchItems? = nil,
         episodes: SearchItems? = nil,
         audiobooks: SearchItems? = nil) {
        self.tracks = tracks
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.shows = shows
        self.episodes = episodes
        self.audiobooks = audiobooks
    }
}

enum SearchCategory: String {
    case track
    case album
    case artist
    case playlist
    case show
    case episode
    case audiobook
    case none
}

struct SearchItems: Decodable {
    let items: [Item]
    
    func getSpecificItems<T: Decodable>() -> [T] {
        return items.compactMap({
            switch $0 {
            case .album(let album): return album as? T
            case .track(let track): return track as? T
            case .artist(let artist): return artist as? T
            case .playlist(let playlist): return playlist as? T
            case .show(let show): return show as? T
            case .episode(let episode): return episode as? T
            case .audiobook(let audiobook): return audiobook as? T
            case .null: return nil
            }
        })
    }
    
    enum Item: Decodable {
        case track(TrackDetail)
        case album(Album)
        case artist(Artist)
        case playlist(Playlist)
        case show(Show)
        case episode(Episode)
        case audiobook(Audiobook)
        case null
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let track = try? container.decode(TrackDetail.self),
                track.type == SearchCategory.track.rawValue {
                self = .track(track)
            } else if let album = try? container.decode(Album.self),
                      album.type == SearchCategory.album.rawValue {
                self = .album(album)
            } else if let artist = try? container.decode(Artist.self),
                      artist.type == SearchCategory.artist.rawValue {
                self = .artist(artist)
            } else if let playlist = try? container.decode(Playlist.self),
                      playlist.type == SearchCategory.playlist.rawValue {
                self = .playlist(playlist)
            } else if let show = try? container.decode(Show.self),
                      show.type == SearchCategory.show.rawValue {
                self = .show(show)
            } else if let episode = try? container.decode(Episode.self),
                      episode.type == SearchCategory.episode.rawValue {
                self = .episode(episode)
            } else if let audiobook = try? container.decode(Audiobook.self),
                      audiobook.type == SearchCategory.audiobook.rawValue {
                self = .audiobook(audiobook)
            } else if container.decodeNil() {
                self = .null
            } else {
                throw DecodingError.typeMismatch(Item.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown item type"))
            }
        }
    }
}

struct Show: Decodable { 
    let id: String
    let type: String
}

struct Episode: Decodable { 
    let id: String
    let type: String
}

struct Audiobook: Decodable {
    let id: String
    let type: String
}

