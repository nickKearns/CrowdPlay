//
//  SpotifyAPI.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import Foundation
import KeychainSwift

struct SpotifyAPI {
    
    public static let baseURL = URL(string: "https://api.spotify.com/v1/")!
    public static let searchURL = URL(string: "https://api.spotify.com/v1/search")!
    public static var api: APIClient = {
        let configuration = URLSessionConfiguration.default
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(String(describing: accessToken))"
        ]
        return APIClient(configuration: configuration)
    }()
}
