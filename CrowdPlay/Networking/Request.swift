//
//  Request.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation




public struct Request {
    let builder: RequestBuilder
    let completion: (Result<Data, Error>) -> Void
    
    init(builder: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        self.builder = builder
        self.completion = completion
    }
    
    
    public static func basic(method: HTTPMethod = .get, baseURL: URL, params: [URLQueryItem]? = nil, completion: @escaping (Result<Data, Error>) -> Void) -> Request {
                
        //        let builder = BasicRequestBuilder(method: method, baseURL: baseURL, path: path, params: params)
        let builder = BasicRequestBuilder(method: method, baseURL: baseURL, params: params)
        return Request(builder: builder, completion: completion)
    }
    
    
}


extension Request {
    
    static func searchTracks(searchWord: String, completion: @escaping (Result<Tracks, Error>) -> Void) -> Request {
        Request.basic(baseURL: SpotifyAPI.searchURL, params: [URLQueryItem(name: "q", value: searchWord), URLQueryItem(name: "type", value: "track"), URLQueryItem(name: "limit", value: "10")]) { result in
            print(result)
            result.decoding(Tracks.self, completion: completion)
        }
        
    }
    
    
    
    
    
}



public extension Result where Success == Data, Failure == Error {
    func decoding<M: Model>(_ model: M.Type, completion: @escaping (Result<M, Error>) -> Void) {
        // decode the JSON in the background and call the completion block on the main thread
        DispatchQueue.global().async {
            //Result’s flatMap() method takes the successful case (if it was successful) and applies your block. You can return a new Result that contains a successful value or an error.
            let result = self.flatMap { data -> Result<M, Error> in
                do {
                    let decoder = M.decoder
                    let model = try decoder.decode(M.self, from: data)
                    print(data)
                    return .success(model)
                } catch {
                    print(error)
                    return .failure(error)
                }
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
