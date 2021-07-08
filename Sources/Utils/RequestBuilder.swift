//
//  RequestBuilder.swift
//
//
//  Created by Albert Grislis on 13.02.2021.
//

import Foundation

open class RequestBuilder {
    
    // MARK: Public properties
    private(set) public var url: URL?
    private(set) public var method: String = "GET"
    private(set) public var headers: [String: String] = [:]
    private(set) public var body: Data?
    private(set) public var parameters: [(key: String, value: String)] = []
    
    // MARK: Initializers & Deinitializers
    public init(url: URL? = nil,
                method: String = "GET",
                headers: [String : String] = [:],
                body: Data? = nil,
                parameters: [(key: String, value: String)] = []) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.parameters = parameters
    }
    
    // MARK: Public methods
    @discardableResult
    open func setURL(_ url: URL?) -> Self {
        self.url = url
        return self
    }
    
    @discardableResult
    open func setURL(_ urlString: String?) -> Self {
        let url = URL(string: urlString ?? String())
        self.url = url
        return self
    }
    
    @discardableResult
    open func setMethod(_ method: String) -> Self {
        self.method = method.uppercased()
        return self
    }
    
    @discardableResult
    open func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }
    
    @discardableResult
    open func addBody<Type>(_ body: Type) -> Self where Type: Encodable {
        if let body = try? JSONEncoder().encode(body) {
            self.body = body
        }
        return self
    }
    
    @discardableResult
    open func addBody(_ body: Any) -> Self {
        if let body = try? JSONSerialization.data(withJSONObject: body) {
            self.body = body
        }
        return self
    }
    
    @discardableResult
    open func addParameter<Type>(key: String?, value: Type?) -> Self where Type: LosslessStringConvertible {
        if let key = key, let value = value {
            self.parameters.append((key: key, value: String(value)))
        }
        return self
    }
    
    open func build(cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) -> URLRequest? {
        guard let url = url else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        var urlRequest: URLRequest?
        if let url = components?.url {
            urlRequest = URLRequest(url: url,
                                    cachePolicy: cachePolicy,
                                    timeoutInterval: timeoutInterval)
            configureURLRequest(pointerToURLRequest: &urlRequest)
        }
        return urlRequest
    }
    
    open func build() -> URLRequest? {
        guard let url = url else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        var urlRequest: URLRequest?
        if let url = components?.url {
            urlRequest = URLRequest(url: url)
            configureURLRequest(pointerToURLRequest: &urlRequest)
        }
        return urlRequest
    }
    
    // MARK: Private methods
    private func configureURLRequest(pointerToURLRequest urlRequest: inout URLRequest?) {
        urlRequest?.httpMethod = method
        headers.forEach {
            urlRequest?.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        urlRequest?.httpBody = body
    }
}
