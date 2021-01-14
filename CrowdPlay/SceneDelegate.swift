//
//  SceneDelegate.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/16/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    
    
    var window: UIWindow?
    
//    var loginVC = LoginVC()
//    var addSongVC = AddSongVC()
//    var queueVC = QueueVC()
    
//    let navigation = UINavigationController()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            
            let openingVC = OpeningViewController()
            let navigation = UINavigationController(rootViewController: openingVC)
//                navigation.navigationBar.isHidden = true
            window.rootViewController = navigation
            
            

            
            APIRouter.shared.refreshToken()
            
           

            let accessToken = UserDefaults.standard.string(forKey: "access_token") ?? ""
            
            
//            print(accessToken)

            
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }

    
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    
        
    
}

