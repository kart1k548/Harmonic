import Foundation

public protocol RequestProtocol {
    var config: RequestConfig { get }

    func cancel()
    var isRunning: Bool { get }
}

class Request: RequestProtocol {
    let session: URLSession
    let config: RequestConfig
    var task: URLSessionDataTask?

    init(session: URLSession = URLSession(configuration: .default), config: RequestConfig) {
        self.session = session
        self.config = config
    }

    func load(completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let request = URLRequest(config: config) else {
            self.call(completion: completion, with: .failure(RequestError.invalidRequest))
            return
        }
        load(request: request) { completion($0.map { $0.data }) }
    }

    func loadHeader(completion: @escaping (Result<[AnyHashable: Any], Error>) -> Void) {
        guard let request = URLRequest(config: config) else {
            self.call(completion: completion, with: .failure(RequestError.invalidRequest))
            return
        }
        load(request: request) { completion($0.map { $0.header }) }
    }

    func load(request: URLRequest, completion: @escaping (Result<(data: Data?, header: [AnyHashable: Any]), Error>) -> Void) {
        cancel()

//        DispatchQueue.global(qos: .background).sync {
//            if let httpMethod = request.httpMethod, let url = request.url?.absoluteString {
//                Logger.log("\(httpMethod) \(url)")
//            }
//            if let headerFields = request.allHTTPHeaderFields?.prettyJsonString {
//                Logger.log("header:\n\(headerFields)", level: .debug, access: .private)
//            }
//            if let body = request.httpBody?.prettyJsonString {
//                Logger.log("body:\n\(body)", level: .debug, access: .private)
//            }
//        }

        task = session.dataTask(with: request) { data, response, error in
            do {
                let payload = try self.handleResponse(data: data, urlResponse: response, error: error)
                self.call(completion: completion, with: .success(payload))
            } catch {
                self.call(completion: completion, with: .failure(error))
            }
        }
        task?.resume()
    }

    func handleResponse(data: Data?, urlResponse: URLResponse?, error: Error?) throws -> (data: Data?, header: [AnyHashable: Any]) {
        if let error = error as NSError?, error.code == NSURLErrorCancelled {
//            Logger.log("Error: Request cancelled")
            throw RequestError.cancelled
        }

        if let error = error {
//            Logger.log("Error: \(String(reflecting: error))", level: .error)
            throw RequestError.httpError(error)
        }

        guard let urlResponse = urlResponse as? HTTPURLResponse, let url = urlResponse.url else {
//            Logger.log("Error: Invalid response", level: .error)
            throw RequestError.invalidResponse
        }

        let statusCode = urlResponse.statusCode
//        Logger.log("\(config.httpMethod.rawValue) \(url) returned with status code \(statusCode)")

        if let data = data, let jsonString = data.prettyJsonString {
//            print(jsonString)
        }

//        Logger.log("Header: \(urlResponse.allHeaderFields)", level: .debug, access: .private)

        guard (200..<300).contains(statusCode) else {
            throw RequestError.requestDenied(statusCode)
        }

        // The backend sometimes returns headers with uppercase keys, for decoding we convert all keys to lowercase
        var headerFields: [String: Any] = [:]
        for key in urlResponse.allHeaderFields.keys {
            guard let keyString = key as? String else { continue }
            headerFields[keyString.lowercased()] = urlResponse.allHeaderFields[key]
        }

        return (data, headerFields)
    }

    func cancel() {
        task?.cancel()
        task = nil
    }

    var isRunning: Bool {
        guard let task = task else { return false }
        return task.state == .running
    }

    func call<Payload>(completion: @escaping (Result<Payload, Error>) -> Void, with requestResult: Result<Payload, Error>) {
        completion(requestResult)
    }
}

fileprivate extension Data {
    var prettyJsonString: String? {
        guard let json = try? JSONSerialization.jsonObject(with: self),
            let prettyJson = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                return nil
        }
        return String(data: prettyJson, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
    }
}

fileprivate extension Dictionary {
    var prettyJsonString: String? {
        guard let prettyJson = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return String(data: prettyJson, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/")
    }
}

