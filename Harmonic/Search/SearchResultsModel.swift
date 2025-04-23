import Foundation

protocol SearchModelDelegate: AnyObject {
    func didReceiveSearch()
    func didReceiveCategories()
}

class SearchModel {
    private let searchService: SearchServiceProtocol
    
    private var getCategoriesTask: RequestProtocol?
    private var searchTask: RequestProtocol?
    
    var categories: [Category] = []
    var searchResponse = SearchResponseModel()
    
    weak var delegate: SearchModelDelegate?
    
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }
    
    func getCategories() {
        getCategoriesTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at search to fetch categories")
                return
            }
            
            self?.getCategoriesTask = self?.searchService.getCategories(with: session.accessToken, locale: "en-US") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.categories = response.categories.items
                        self?.delegate?.didReceiveCategories()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func getSearch(searchText: String, searchCategories: Set<SearchCategory>) {
        searchTask?.cancel()
        
        AuthManager.shared.getSession { [weak self] session in
            guard let session else {
                print("No session at search screen to fetch results")
                return
            }
            
            self?.searchTask = self?.searchService.search(with: session.accessToken, searchText: searchText, searchCategories: searchCategories) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.searchResponse = response
                        self?.delegate?.didReceiveSearch()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
