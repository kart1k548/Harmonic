public enum RequestError: Error, CustomStringConvertible, Equatable {
    case cancelled
    case noData
    case invalidPayload
    case invalidRequest
    case invalidResponse
    case requestDenied(Int)
    case httpError(Error)
    case encodingFailed(Error)
    case decodingFailed(Error)

    public var description: String {
        switch self {
        case .cancelled:
            return "The request was cancelled"
        case .noData:
            return "The request returned no data but data was expected"
        case .invalidPayload:
            return "The object passed to the request was invalid"
        case .invalidRequest:
            return "The request constructed was invalid"
        case .invalidResponse:
            return "The request returned "
        case .requestDenied(let statusCode):
            return "The request was denied with status code \(statusCode)"
        case .httpError(let error):
            return "The request failed. Reason: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Could not encode the object passed to the request. Reason: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Could not decode the object returned from the request. Reason: \(error.localizedDescription)"
        }
    }

    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch(lhs, rhs) {
        case (.cancelled, .cancelled),
             (.noData, .noData),
             (.invalidPayload, .invalidPayload),
             (.invalidRequest, .invalidRequest),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.requestDenied(lshValue), .requestDenied(rhsValue)):
            return lshValue == rhsValue
        case let (.httpError(lshValue), .httpError(rhsValue)):
            return lshValue.localizedDescription == rhsValue.localizedDescription
        case let (.encodingFailed(lshValue), .encodingFailed(rhsValue)):
            return lshValue.localizedDescription == rhsValue.localizedDescription
        case let (.decodingFailed(lshValue), .decodingFailed(rhsValue)):
            return lshValue.localizedDescription == rhsValue.localizedDescription
        default: fatalError()
        }
    }
}
