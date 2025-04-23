import Foundation

class CodingRequest<DecodePayload: Decodable>: EncodingRequest {
    func load(completion: @escaping (Result<DecodePayload, Error>) -> Void) {
        guard let request = URLRequest(config: config) else {
            call(completion: completion, with: .failure(RequestError.invalidRequest))
            return
        }
        
        super.load(request: request) { result in
            self.handleResult(result: result.map { $0.data }, completion: completion)
        }
    }
    
    func load<EncodePayload: Encodable>(payload: EncodePayload, completion: @escaping (Result<DecodePayload, Error>) -> Void) {
        super.load(payload: payload) { result in
            self.handleResult(result: result, completion: completion)
        }
    }
}

private extension CodingRequest {
    func decode(data: Data) throws -> DecodePayload {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(DecodePayload.self, from: data)
        } catch {
//            Logger.log("Could not decode \(DecodePayload.self). Reason: \(String(reflecting: error))", level: .error, access: .private)
            throw RequestError.decodingFailed(error)
        }
    }

    func handleResult(result: Result<Data?, Error>, completion: @escaping (Result<DecodePayload, Error>) -> Void) {
        do {
            guard let payload = try result.get() else {
//                Logger.log("Error: Request returned no data", level: .error)
                throw RequestError.noData
            }

            let decodedPayload = try self.decode(data: payload)
            self.call(completion: completion, with: .success(decodedPayload))
        } catch let DecodingError.keyNotFound(key, context) {
//            Logger.log("Error handling result, expected success type: \(DecodePayload.self) : \(key.stringValue)", level: .error, access: .public)
//            Logger.log("\(type(of: self)) Error: \(context.self)", level: .error, access: .public)
            self.call(completion: completion, with: .failure(RequestError.invalidResponse))
        } catch {
//            Logger.log("Error handling result, expected success type: \(DecodePayload.self), reason: \(String(reflecting: error))", level: .error, access: .public)
            self.call(completion: completion, with: .failure(error))
        }
    }
}
