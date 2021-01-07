//
//  QueueVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/11/20.
//

import Foundation
import FirebaseDatabase
import CodableFirebase


class QueueVC: UIViewController {
    
    var sessionID: String = ""
    var sessionName: String = ""
    
    var isHost: Bool = false
    
    var queuedItems: [Item] = [] {
        didSet {
            queueTableView.reloadData()
        }
    }
    
    let queueTableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    
    let defaults = UserDefaults.standard
    
    let clientID = Constants.SpotifyClientID
    let redirectURI = Constants.spotifyRedirectURI
    
    var accessToken = UserDefaults.standard.string(forKey: "accessToken") {
        didSet {
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        }
    }
//    var responseTypeCode: String? {
//        didSet {
//            fetchSpotifyToken { (dictionary, error) in
//                if let error = error {
//                    print("Fetching token request error \(error)")
//                    return
//                }
//                let accessToken = dictionary!["access_token"] as! String
//                DispatchQueue.main.async {
//                    self.defaults.setValue(accessToken, forKey: "accessToken")
//                    self.appRemote.connectionParameters.accessToken = accessToken
//                    self.appRemote.connect()
//                }
//            }
//        }
//    }
    
    
    
    private let SpotifyClientID = Constants.SpotifyClientID
    private let spotifyRedirectURI = URL(string: "CrowdPlay://")!
    
    //MARK: SPOTIFY VARIABLES
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: spotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
//        configuration.playURI = ""
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupDB()
        
        
        self.navigationItem.title = "Queue"
        setupTable()
        if self.isHost == true {
            setupPlayBackView()
        }
    }

    
    func setupPlayBackView() {
        
        let playBackView = PlayBackView()
        self.view.addSubview(playBackView)
        playBackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }
        
       
        
    }
    
    func setupTable() {
        self.view.addSubview(queueTableView)
        queueTableView.delegate = self
        queueTableView.dataSource = self
        queueTableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "TrackTableViewCell")
        
        queueTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            
        }
        
        
    }
    
    func setupDB() {
        let ref = Database.database().reference().child(self.sessionID)

        ref.observe(.childAdded, with: { (snapshot) -> Void in
            guard let value = snapshot.value else {return}
            do {
                let item = try FirebaseDecoder().decode(Item.self, from: value)
                self.queuedItems.append(item)
//                self.queueTableView.insertRows(at: [IndexPath(row: self.queuedItems.count, section: 0)], with: .middle)
                
                if self.isHost {
                    
                    APIRouter.shared.queueRequest(URI: item.uri, completion: { result in
                        switch result {
                        case .success(let any):
                            print(any)
                        case .failure(let error):
                            print(error)
                        }
                        
                    })
                }
                
                
            } catch let error {
                print(error)
            }
            
            
            
        })
    }
    
//
//    func fetchSpotifyToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
//        let url = URL(string: "https://accounts.spotify.com/api/token")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let spotifyAuthKey = "Basic \((clientID + ":" + Constants.clientIdSecret).data(using: .utf8)!.base64EncodedString())"
//        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
//                                       "Content-Type": "application/x-www-form-urlencoded"]
//        do {
//            var requestBodyComponents = URLComponents()
//            let scopesAsString = Constants.scopesAsStrings.joined(separator: " ") //put array to string separated by whitespace
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
    
    
    
    
    
}


extension QueueVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queuedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as! TrackTableViewCell
        
        cell.titleLabel.text = queuedItems[indexPath.row].name
        cell.artistLabel.text = queuedItems[indexPath.row].artists[0].name

        let images = queuedItems[indexPath.row].album.images
        for image in images {
            if image.height == 300 {
                cell.imageView?.kf.setImage(with: image.url, completionHandler: { result in
                    switch result {
                    case .success(let imageResult):
                        // MARK: asynchronously input the images into each cell's image view
                        DispatchQueue.main.async {
                            cell.imageView!.image = imageResult.image
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }
        
        return cell
        
    }
    
    
    
    
    
}



extension QueueVC: SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print(error)
        let loginVC = LoginVC()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        
    }
    
}
