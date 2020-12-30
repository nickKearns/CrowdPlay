//
//  SceneDelegate.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/16/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SPTAppRemoteDelegate {
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        
    }
    

    
    var window: UIWindow?
    
    var loginVC = LoginVC()
    var addSongVC = AddSongVC()
    var queueVC = QueueVC()
    
    let navigation = UINavigationController()
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.SpotifyClientID, redirectURL:  Constants.spotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
//        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            
            
            
            
//            window.rootViewController = loginVC
            
            window.rootViewController = OpeningViewController()
            
            
            
//            let tabBar = UITabBarController()
//
//            queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue.png"), selectedImage: nil)
//            addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong.png"), selectedImage: nil)
//
//            addSongVC.queueVCInstance = queueVC
//
//            let addSongNav = UINavigationController(rootViewController: addSongVC)
//            let queueNav = UINavigationController(rootViewController: queueVC)
//
//            tabBar.viewControllers = [addSongNav, queueNav]
//
            let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//
//            if accessToken == "" {
//                window.rootViewController = navigation
//                navigation.pushViewController(loginVC, animated: true)
//                print("loginVC")
//            }
//            else {
//                window.rootViewController = tabBar
//                tabBar.selectedIndex = 0
////                navigation.pushViewController(addSongVC, animated: true)
//            }
            
            print(accessToken)

            
            
            
//            window.rootViewController = navigation
            
//            navigation.navigationBar
            
            self.window = window
            window.makeKeyAndVisible()
        }
        
//        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let parameters = addSongVC.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            addSongVC.responseTypeCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            addSongVC.accessToken = access_token
            UserDefaults.standard.setValue(access_token, forKey: "accessToken")
//            print(access_token)
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)

            window?.rootViewController = navigation
                
            navigation.pushViewController(loginVC, animated: true)
        }
    }
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        //        appRemote.connect()
        if let accessToken = addSongVC.appRemote.connectionParameters.accessToken {
            addSongVC.appRemote.connectionParameters.accessToken = accessToken
            print(accessToken)
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            addSongVC.appRemote.connect()
        } else if let accessToken = addSongVC.accessToken {
            addSongVC.appRemote.connectionParameters.accessToken = accessToken
//            print(accessToken)
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            addSongVC.appRemote.connect()
        }
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if addSongVC.appRemote.isConnected {
            appRemote.disconnect()
        }
    }
    
   
    
}

