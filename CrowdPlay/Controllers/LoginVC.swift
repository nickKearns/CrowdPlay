//
//  LoginVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/16/20.
//

import UIKit
import FirebaseDatabase
import SnapKit
import KeychainSwift

class LoginVC: UIViewController {
    
    //    let keychain = KeychainSwift()
    
    let defaults = UserDefaults.standard
    
    
    let homeVC = AddSongVC()

    
    
    //MARK: UI ELEMENTS
    let signInButton: UIButton = {
        let b = UIButton()
        //        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Sign in with Spotify", for: .normal)
        b.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        b.tintColor = .systemBlue
        
        return b
    }()
    
   
    
    
    var accessToken = UserDefaults.standard.string(forKey: "accessToken") {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: "accessToken")
        }
    }
    
    
    
    
    //MARK: SPOTIFY VARIABLES
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Constants.SpotifyClientID, redirectURL:  Constants.spotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupButton()
        
        self.view.backgroundColor = .systemGray3
        
        navigationItem.setHidesBackButton(true, animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    //MARK: UI FUNCTIONS
    @objc func signInTapped() {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .streaming, .userModifyPlaybackState, .userReadPlaybackState, .userTopRead, .userReadRecentlyPlayed]
        
        
        sessionManager.initiateSession(with: scope, options: .default)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK: UI SETUP
    func setupButton() {
        self.view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            
        }
        
    }
    
    
    
    func checkForConnection() {
        if appRemote.isConnected {
            let addSongVC = AddSongVC()
            navigationController?.pushViewController(addSongVC, animated: true)
        }
        else {
            //do nothing
        }
    }
    
    
}


extension LoginVC: SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        appRemote.playerAPI?.delegate = self
        
        defaults.setValue(true, forKey: "isLoggedIn")
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("error")
            }
            
        })
    }

    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        //        keychain.set(session.accessToken, forKey: "accessToken")
        defaults.setValue(true, forKey: "loggedIn")
        let addSongVC = AddSongVC()
        print("initiating session")
        print("logged in")
        navigationController?.pushViewController(homeVC, animated: true)
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("")
        
        
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        
    }
    
    
    
}
