//
//  APIRouter.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/2/20.
//

import Foundation
import Alamofire




class APIRouter {
    
    
    static let shared: APIRouter = {
        let shared = APIRouter()
        
        return shared
    }()
    
    var token: String = ""
    let baseURL: URL
    
    
    private init() {
        baseURL = URL(string: "https://api.spotify.com/v1/")!
        token = getToken()
    }
    
    
    func getToken() -> String {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {return ""}
        return token
    }
    
    
    
    
    func searchRequest(keyWord: String, completion: @escaping (Result<TracksResponse, Error>) -> Void) {


        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        //limit set to 5 just for testing
        let searchURL = "\(baseURL)search?q=\(keyWord)&type=track&limit=5"
        
        
        AF.request(searchURL, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TracksResponse.self) { response in
                switch response.result {
                case .success(let results):
                    completion(.success(results))
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                    print("Failed, going to return a track response instance with no data")
                }
            }
    }
    
    
    func queueRequest(URI: String, completion: @escaping (AFResult<Any>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
            
        ]
        
        let formattedURI = URI.replacingOccurrences(of: ":", with: "%3A")
        
        let queueURL = "\(baseURL)me/player/queue?uri=\(formattedURI)"
        
        print(queueURL)
        
        AF.request( queueURL, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
//                let responseCode = response.response?.statusCode
                switch response.result {
                case .success(let success):
                    //do nothing
                    print("success \(success)")
                case .failure(let error):
                    print(error)
                default:
                    print("here is where the 204 should happen")
                    
                
                }
                
            }
        
        
        
        
        
    }
    
    
    
    
    
    
}
