import Foundation

protocol PlaylistCollectionModelDelegate: AnyObject {
    func didReceivePlaylists()
}

class PlaylistCollectionModel {
    private let searchService: SearchServiceProtocol
    let searchText: String
    
    var categories: [Category] = []
    var searchResponse = SearchResponseModel()
    
    weak var delegate: PlaylistCollectionModelDelegate?
    
    init(searchService: SearchServiceProtocol = SearchService(), searchText: String = "") {
        self.searchService = searchService
        self.searchText = searchText
    }
    
    func getPlaylists() {
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at Playlist Collection screen to fetch results")
                return
            }
            
            guard let self else { return }
            
            _ = self.searchService.search(with: session.accessToken, searchText: self.searchText, searchCategories: [.playlist], limit: 50) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.searchResponse = response
                        self.delegate?.didReceivePlaylists()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
