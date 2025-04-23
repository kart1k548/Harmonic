import Foundation

protocol SearchModelDelegate: AnyObject {
    func didReceiveCategories()
}

class SearchModel {
    private let searchService: SearchServiceProtocol
    
    private var getCategoriesTask: RequestProtocol?
    private var searchTask: RequestProtocol?
    
    var categories: [Category] = []
    
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
            
            self?.getCategoriesTask = self?.searchService.getCategories(with: session.accessToken, locale: Locale.current.identifier) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        var filteredCategories = response.categories.items
                        filteredCategories.removeFirst()
                        self?.categories = filteredCategories
                        self?.delegate?.didReceiveCategories()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
