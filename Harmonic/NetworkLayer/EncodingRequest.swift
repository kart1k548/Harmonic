import Foundation

class EncodingRequest: Request {
    func load<EncodePayload: Encodable>(payload: EncodePayload, completion: @escaping (Result<Data?, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try self.encode(payload)
                guard let request = URLRequest(config: self.config, httpBody: data) else {
                    throw RequestError.invalidRequest
                }
                self.load(request: request) { completion($0.map { $0.data }) }
            } catch {
                self.call(completion: completion, with: .failure(error))
            }
        }
    }

    private func encode<EncodePayload: Encodable>(_ payload: EncodePayload) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            let encodedData = try JSONSerialization.data(withJSONObject: payload, options: [])
            if let jsonString = String(data: encodedData, encoding: .utf8) {
                print("EncodingRequest: \(jsonString)")
            }
            
            return encodedData
        } catch {
//            Logger.log("Could not encode", level: .error)
//            Logger.log("Could not encode \(EncodePayload.self). Reason: \(String(reflecting: error))", level: .error, access: .private)
            throw RequestError.encodingFailed(error)
        }
    }
}
