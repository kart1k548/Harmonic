import Foundation

struct SearchService: SearchServiceProtocol {
    func search(with accessToken: String, searchText: String, searchCategories: Set<SearchCategory>, limit: Int = 5, completion: @escaping (Result<SearchResponseModel, Error>) -> Void) -> RequestProtocol {
        let typeParamValue = searchCategories.map( { $0.rawValue }).joined(separator: ",")
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "search"],
            queryItems: ["q": searchText,
                         "type": typeParamValue,
                         "limit": "\(limit)"],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<SearchResponseModel>(config: config)
        request.load(completion: completion)

        return request
    }
    
    func getCategories(with accessToken: String, locale: String, completion: @escaping (Result<CategoriesResponseModel, Error>) -> Void) -> RequestProtocol {
        let config = RequestConfig(
            httpMethod: .get,
            host: APIConstans.apiBaseUrl,
            pathComponents: ["v1", "browse", "categories"],
            queryItems: ["locale": locale],
            headerFields: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
        
        let request = CodingRequest<CategoriesResponseModel>(config: config)
        request.load(completion: completion)

        return request
    }
}
