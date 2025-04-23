import Foundation

protocol SearchResultsModelDelegate: AnyObject {
    func didReceiveSearch()
}

class SearchResultsModel {
    private let searchService: SearchServiceProtocol
    private var searchTask: RequestProtocol?
    
    weak var delegate: SearchResultsModelDelegate?
    
    var searchCategories: Set<SearchCategory> = [.album, .track, .playlist, .artist] {
        didSet {
            getSearch()
        }
    }
    
    var selectedFilter: SearchCategory = .none
    var searchText: String = ""
    var searchResults = SearchResponseModel()
    
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }
    
    func getSearch() {
        searchTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at search screen to fetch results")
                return
            }
            
            guard let self, !searchText.isEmpty else { return }
            
            searchTask = searchService.search(with: session.accessToken, searchText: searchText, searchCategories: searchCategories, limit: selectedFilter == .none ? 5 : 50) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.searchResults = response
                        self.delegate?.didReceiveSearch()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
