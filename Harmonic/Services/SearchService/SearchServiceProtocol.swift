import Foundation

protocol SearchServiceProtocol {
    func search(with accessToken: String, searchText: String, searchCategories: Set<SearchCategory>, limit: Int, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) -> RequestProtocol
    func getCategories(with accessToken: String, locale: String, completion: @escaping (Result<CategoriesResponseModel, Error>) -> Void) -> RequestProtocol
}

extension SearchServiceProtocol {
    func search(with accessToken: String, searchText: String, searchCategories: Set<SearchCategory>, limit: Int = 5, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) -> RequestProtocol {
        return search(with: accessToken, searchText: searchText, searchCategories: searchCategories, limit: limit, completion: completion)
    }
}
