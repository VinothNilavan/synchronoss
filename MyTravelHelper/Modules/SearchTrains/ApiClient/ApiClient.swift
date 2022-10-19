//
//  ApiClient.swift
//  ProjectNew
//  Created by Vinoth on 03/10/22.
//

import Foundation
import XMLParsing

public let DefaultStatusCode = 0

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case patch   = "PATCH"
}

public protocol Router {
    var method: HTTPMethod { get }
    var path: String { get }
    var params: [String: Any] { get }
    var baseUrl: URL { get }
    var headers: [String: String] { get }
    var keypathToMap: String? { get }
}

class ApiClient {
    static let shared = ApiClient()
    
    fileprivate func requestInternal<T: Codable> (router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) {
        let urlString = router.baseUrl.absoluteString + router.path
        guard let url = URL(string: urlString) else { return }
        var urlReq = URLRequest(url: url)
        urlReq.allHTTPHeaderFields = router.headers
        self.makeRequest(request: urlReq, router: router, completion: completion)
    }

    open func request<T: Codable> (_ router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) {
        let _ = self.requestInternal(router: router, completion: completion)
    }

    fileprivate func makeRequest<T: Codable> (request: URLRequest, router: Router, completion: @escaping (_ result: APIResult<T>) -> Void) {
        
        let completionHandler: (_ result: APIResult<T>) -> Void = { result in
            DispatchQueue.main.async { completion(result) }
        }
        
        URLSession.shared.fetchApi(for: request) { result in
            completionHandler(result)
        }
    }
    
    fileprivate func parseError(_ error: NSError?) -> Error {
        if let error = error {
            return error
        } else {
            return APIClientError.unknown
        }
    }

    fileprivate func parse<T: Codable> (_ json: Data, router: Router, _ statusCode: Int) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            throw error
        }
    }
}

extension URLSession {
    
  func fetchApi<T: Decodable>(for url: URLRequest, completion: @escaping (_ result: APIResult<T>) -> Void) -> Void {
      self.dataTask(with: url) { (data, response, error) in
      if let error = error { completion(.failure(error)) }
          print(url.url?.absoluteString ?? "")
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(String(describing: response))")
            return
        }
        
        if let data = data {
            do {
//              let object = try JSONDecoder().decode(T.self, from: data)
                let object = try XMLDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch let decoderError {
                completion(.failure(decoderError))
            }
        }
    }.resume()
  }
}

public enum APIResult<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

}
fileprivate struct ErrorDefaults {
    static let domain = "Error"
    static let message = "An unknown error has occured."
}

fileprivate enum ErrorCode: Int {
    case noInternet = 5555
    case errorReadingUrl = 5556
    case unknown = 5557
    
    var code: Int {
        return self.rawValue
    }
}

enum APIClientError: Error {
    
    case noInternet
    case errorReadingUrl(URL)
    case unknown
    
    var code: Int {
        switch self {
        case .noInternet: return ErrorCode.noInternet.code
        case .errorReadingUrl: return ErrorCode.errorReadingUrl.code
        case .unknown: return ErrorCode.unknown.code
        }
    }

    var domain: String {
        return ErrorDefaults.domain
    }
    
    var message: String {
        var message = ErrorDefaults.message
        switch self {
        case .noInternet:
            message = "No Internet Connection! Check your internet connection."
        case .errorReadingUrl(let url):
            message = "Error reading data from url: \(url.absoluteString)"
        case .unknown: break
        }
        return message
    }

}
