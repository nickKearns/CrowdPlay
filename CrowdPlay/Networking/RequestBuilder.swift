//
//  RequestBuilder.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation


public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}


public protocol RequestBuilder {
    var method: HTTPMethod { get }
    var baseURL: URL { get }
//    var category: String { get }
    var params: [URLQueryItem]? { get }
    var headers: [String: String] { get }

    func toURLRequest() -> URLRequest
}



struct BasicRequestBuilder: RequestBuilder {
    var method: HTTPMethod
    var baseURL: URL
//    var category: String
    var params: [URLQueryItem]?
    var headers: [String: String] = [:]
}




public extension RequestBuilder {
    func toURLRequest() -> URLRequest {
//        var components = URLComponents(url: baseURL.appendingPathComponent(par), resolvingAgainstBaseURL: false)!
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = params
        let url = components.url!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        return request
    }
}
