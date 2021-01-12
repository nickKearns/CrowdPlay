//
//  APIRouter.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/2/20.
//

import Foundation
import Alamofire
import CommonCrypto
import AuthenticationServices




class APIRouter {
    
    
    var verifier: String = ""
    
    //MARK: These two functions were taken from https://docs.cotter.app/sdk-reference/api-for-other-mobile-apps/api-for-mobile-apps#step-1-create-a-code-verifier
    
    func getCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let verifier = Data(bytes: buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        return verifier
    }
    
    func getCodeChallenge() -> String {
        
        self.verifier = getCodeVerifier()
        
        guard let verifierData = self.verifier.data(using: String.Encoding.utf8) else { return "error" }
            var buffer = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
     
            verifierData.withUnsafeBytes {
                CC_SHA256($0.baseAddress, CC_LONG(verifierData.count), &buffer)
            }
        let hash = Data(_: buffer)
        print(hash)
        let challenge = hash.base64EncodedData()
        return String(decoding: challenge, as: UTF8.self)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
    static let shared: APIRouter = {
        let shared = APIRouter()
        
        return shared
    }()
    
    var token: String = ""
    let baseURL: URL
    
    let authURL: String = "https://accounts.spotify.com/api/token"
    
    private init() {
        baseURL = URL(string: "https://api.spotify.com/v1/")!
        token = getToken()
    }
    
    func getAuthToken(code: String) {

//        let spotifyAuthKey = "Basic \((Constants.SpotifyClientID + ":" + Constants.clientIdSecret).data(using: .utf8)!.base64EncodedString())"

        let parameters: [String: String] = [
            "client_id": spotifyClientID,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURIString,
            "code_verifier": self.verifier
        
        ]
        
        AF.request(authURL, method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Token.self) { response in
                switch response.result {
                case .success(let token):
                    UserDefaults.standard.setValue(token.access_token, forKey: "access_token")
                    UserDefaults.standard.setValue(token.expires_in, forKey: String(token.expires_in))
                    UserDefaults.standard.setValue(token.refresh_token, forKey: "refresh_token")
                    print(token.access_token)
                    print(token.expires_in)
                    print(token.refresh_token)
                
                case .failure(let error):
                    print(error)
                    
                }
                
            }
        
    

    }
    
    // https://stackoverflow.com/questions/63482575/spotify-pkce-authorization-flow-returns-code-verifier-was-incorrect
    
    

    
    let authorizeURL: String = "https://accounts.spotify.com/authorize"
    let spotifyClientID: String = Constants.SpotifyClientID
    let redirectURIString = Constants.redirectURIString
    let callBackURL = "QShare"
    
    func authRequest(viewController: LoginVC, completion: @escaping (URL?, Error?) -> Void) {
        
        let codeChallenge = getCodeChallenge()
        
        let scopesAsString = Constants.scopesAsStrings.joined(separator: " ")
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: spotifyClientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURIString),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "scope", value: scopesAsString)
        ]
        let urlString = components.url!.absoluteString

        guard let authURL = URL(string: urlString) else { return }
        print(authURL)
        let authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callBackURL, completionHandler: completion)
        authSession.presentationContextProvider = viewController
        authSession.prefersEphemeralWebBrowserSession = true
        authSession.start()
        
        
    }
    
    
    func getToken() -> String {
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {return ""}
        return token
    }
    
    
    
    
    func searchRequest(keyWord: String, offset: Int, completion: @escaping (Result<TracksResponse, Error>) -> Void) {


        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        //limit set to 5 just for testing
        let searchURL = "\(baseURL)search?q=\(keyWord)&type=track&offset=\(String(offset))"
        
        
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
    
    func playRequest(completion: @escaping (AFResult<Any>) -> Void ) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        //limit set to 5 just for testing
        let url = "\(baseURL)me/player/play"
        
        AF.request(url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
                }
                
            }
        
    }
    
    func pauseRequest(completion: @escaping (AFResult<Any>) -> Void ) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        //limit set to 5 just for testing
        let url = "\(baseURL)me/player/pause"
        
        AF.request(url, method: .put, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
                }
                
            }
        
    }
    
    func skipRequest(completion: @escaping (AFResult<Any>) -> Void ) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
            
        ]
        
        let url = "\(baseURL)me/player/next"
        
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
                }
                
            }
        
    }
    
    func previousRequest(completion: @escaping (AFResult<Any>) -> Void ) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
            
        ]
        
        let url = "\(baseURL)me/player/previous"
        
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
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
        
        AF.request(queueURL, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
//                let responseCode = response.response?.statusCode
                switch response.result {
                case .success(let success):
                    //do nothing
                    print("success \(success)")
                case .failure(let error):
                    print(error)
                
                
                }
                
            }
    }
    
    func getRecentlyPlayed(completion: @escaping (Result<Tracks, Error>) -> Void) {
            
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let recentlyPlayedURL: String = "https://api.spotify.com/v1/me/player/recently-played"
        
        AF.request(recentlyPlayedURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Tracks.self) { response in
                switch response.result {
                case .success(let tracks):
                    completion(.success(tracks))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
                
            }
        
        
        
        
    }
    
//    func fetchSpotifyToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
//        let url = URL(string: "https://accounts.spotify.com/api/token")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let spotifyAuthKey = "Basic \((clientID + ":" + Constants.clientIdSecret).data(using: .utf8)!.base64EncodedString())"
//        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
//                                       "Content-Type": "application/x-www-form-urlencoded"]
//        do {
//            var requestBodyComponents = URLComponents()
//            let scopesAsString = Constants.scopesAsStrings.joined(separator: " ")
//            requestBodyComponents.queryItems = [
//                URLQueryItem(name: "client_id", value: clientID),
//                URLQueryItem(name: "grant_type", value: "authorization_code"),
//                URLQueryItem(name: "code", value: responseTypeCode!),
//                URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
//                URLQueryItem(name: "code_verifier", value: ""),
//                URLQueryItem(name: "scope", value: scopesAsString),
//            ]
//            request.httpBody = requestBodyComponents.query?.data(using: .utf8)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data,                            // is there data
//                      let response = response as? HTTPURLResponse,  // is there HTTP response
//                      (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
//                      error == nil else {                           // was there no error, otherwise ...
//                    print("Error fetching token \(error?.localizedDescription ?? "")")
//                    return completion(nil, error)
//                }
//                let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//                print("Access Token Dictionary=", responseObject ?? "")
//                completion(responseObject, nil)
//            }
//            task.resume()
//        } catch {
//            print("Error JSON serialization \(error.localizedDescription)")
//        }
//    }
//    
//    func getToken() {
//        
//        let clientID = Constants.SpotifyClientID
//        let redirectURI = Constants.spotifyRedirectURI
//        
//        let url = "https://accounts.spotify.com/api.token"
//        
//        
//        
//    }
    
    
    
    
    
    
    
}
