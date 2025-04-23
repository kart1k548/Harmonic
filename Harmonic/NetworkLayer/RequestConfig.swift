import Foundation

public struct RequestConfig {
    var httpMethod: HttpMethod
    var host: String
    var pathComponents: [String]
    var queryItems: [String: String]?
    var headerFields: [String: String]

    init(httpMethod: HttpMethod, 
         host: String,
         pathComponents: [String],
         queryItems: [String: String]? = nil,
         headerFields: [String: String] = [:]
    ) {
        self.httpMethod = httpMethod
        self.host = host
        self.pathComponents = pathComponents
        self.queryItems = queryItems
        self.headerFields = headerFields
    }
}
