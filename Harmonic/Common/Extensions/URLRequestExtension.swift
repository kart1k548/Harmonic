import Foundation

extension URLRequest {
    init?(config: RequestConfig, httpBody: Data? = nil) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = config.host
        urlComponents.queryItems = config.queryItems?.compactMap { key, value in URLQueryItem(name: key, value: value) }

        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?
                     .replacingOccurrences(of: "+", with: "%2B")
                     .replacingOccurrences(of: "/", with: "%2F")
        
    
        let pathExtendedUrl = config.pathComponents.reduce(urlComponents.url) { url, pathComponent in url?.appendingPathComponent(pathComponent)
        }
        guard let url = pathExtendedUrl else { return nil }

        self.init(url: url)
        self.httpMethod = config.httpMethod.rawValue
        
        self.httpBody = httpBody
        
        config.headerFields.forEach { key, value in self.setValue(value, forHTTPHeaderField: key) }
    }
}
