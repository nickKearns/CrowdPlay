//
//  APIClient.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation


struct APIClient {
    private let session: URLSession

    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    
    public func send(request: Request) {
        let urlRequest = request.builder.toURLRequest()
        print(urlRequest)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            print(response)
            let result: Result<Data, Error>
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(data ?? Data())
                print(data)
            }
            DispatchQueue.main.async {
                request.completion(result)
            }
        }
        task.resume()
    }
    
    
}
