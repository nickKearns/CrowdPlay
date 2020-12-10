//
//  SpotifyAppRemote.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/18/20.
//

import Foundation

//
//struct SPTAppRemote {
//    
//    
//    static let SpotifyClientID = "2b8423af0918491b86dc11725d6fe608"
//    static let SpotifyRedirectURI = URL(string: "CrowdPlay://")!
//    
//    static var configuration: SPTConfiguration = {
//        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
//        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
//        // otherwise another app switch will be required
//        configuration.playURI = ""
//        
//        // Set these url's to your backend which contains the secret to exchange for an access token
//        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
//        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
//        return configuration
//    }()
//    
////    static var sessionManager: SPTSessionManager = {
////        let manager = SPTSessionManager(configuration: configuration, delegate: self)
////        return manager
////    }()
////
////    static var appRemote: SPTAppRemote = {
////        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
////        appRemote.delegate = self
////        return appRemote
////    }()
////
////    static var lastPlayerState: SPTAppRemotePlayerState?
//    
//}
