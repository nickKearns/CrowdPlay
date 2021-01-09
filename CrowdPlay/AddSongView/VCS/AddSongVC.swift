//
//  AddSongVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 11/17/20.
//

import UIKit
import Firebase
import SnapKit
import KeychainSwift
import Alamofire
import Kingfisher
import CodableFirebase


class AddSongVC: UIViewController {
    
    
    var sessionID: String = ""
    var sessionName: String = ""
    
    
    var isHost: Bool = false
    
    var ref = Database.database().reference()

    
    var queueVCInstance: QueueVC?
    
    var offset: Int = 0
    
    var trackItems: [Item] = [] {
        didSet {
            tableView.reloadData()
            queueNewSongs()
        }
    }
    
    
    let defaults = UserDefaults.standard
    
    let clientID = Constants.SpotifyClientID
    let redirectURI = Constants.spotifyRedirectURI
    
    var accessToken = UserDefaults.standard.string(forKey: "accessToken") {
        didSet {
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        }
    }
    var responseTypeCode: String? {
        didSet {
            fetchSpotifyToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    self.defaults.setValue(accessToken, forKey: "accessToken")
                    self.appRemote.connectionParameters.accessToken = accessToken
                    self.appRemote.connect()
                }
            }
        }
    }
    
    
//    private let SpotifyClientID = "2b8423af0918491b86dc11725d6fe608"
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
    
    

    var searchTerm = ""
    
    let coverImage: UIImageView = {
        let ci = UIImageView()
        ci.contentMode = .scaleAspectFit
        ci.backgroundColor = .blue
        
        return ci
    }()
    
    
    let tableView: UITableView = {
        let tv = UITableView()
//        tv.backgroundColor = .white
        return tv
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.backgroundColor = .red
        return sv
    }()
    
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for a track"
        sb.sizeToFit()
        
        return sb
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        self.navigationItem.title = "Add songs to the queue"
        navigationItem.setHidesBackButton(true, animated: false)
        setupUI()
        setupTableView()
        searchBar.showsCancelButton = true
    }
    
    
    func queueNewSongs() {
        
        
        
    }
    
    func getTracks() {
        
        APIRouter.shared.searchRequest(keyWord: searchTerm, offset: offset, completion: { result in
            switch result {
            case .success(let trackResponse):
                self.trackItems.append(contentsOf: trackResponse.tracks!.items)
            case .failure(let error):
                print(error)
            }
            
        })
    }
    
    func checkRecentPlayed() {
        
        APIRouter.shared.getRecentlyPlayed() { result in
            switch result {
            case .success(let tracks):
                //do some checking against
                print(tracks)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    func setupUI() {
        
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        if self.isHost == true {
        
            let playBackView = PlayBackView()
            self.view.addSubview(playBackView)
            playBackView.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.10)
                
            }
            
            
        }
        
        
        
        
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "TrackTableViewCell")
        
    }
    
    
    func presentAlertController(item: Item) {
        
        let alertController = UIAlertController(title: "Add to queue?", message: nil, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Add \(item.name) to the queue?", style: .default, handler: { (action:UIAlertAction) in
            self.sendTrackToFireBase(item: item)
        })
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func sendTrackToFireBase(item: Item) {
    
        let itemData = try! FirebaseEncoder().encode(item)
        
        self.ref.child(self.sessionID).childByAutoId().setValue(itemData)
        
        
    }
    
    
    
    
    func fetchSpotifyToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((clientID + ":" + Constants.clientIdSecret).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        do {
            var requestBodyComponents = URLComponents()
            let scopesAsString = Constants.scopesAsStrings.joined(separator: " ")
            requestBodyComponents.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: responseTypeCode!),
                URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
                URLQueryItem(name: "code_verifier", value: ""),
                URLQueryItem(name: "scope", value: scopesAsString),
            ]
            request.httpBody = requestBodyComponents.query?.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,                            // is there data
                      let response = response as? HTTPURLResponse,  // is there HTTP response
                      (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                      error == nil else {                           // was there no error, otherwise ...
                    print("Error fetching token \(error?.localizedDescription ?? "")")
                    return completion(nil, error)
                }
                let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                print("Access Token Dictionary=", responseObject ?? "")
                completion(responseObject, nil)
            }
            task.resume()
        } catch {
            print("Error JSON serialization \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
}

extension AddSongVC: UISearchBarDelegate {
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let tmpText = searchText
        let formatedSTR = tmpText.replacingOccurrences(of: " ", with: "%20")
        self.offset = 0
        self.trackItems = []
        self.searchTerm = formatedSTR
        getTracks()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}


extension AddSongVC: SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
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


extension AddSongVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = trackItems.count - 1
        if indexPath.row == lastElement {
            self.offset += 10
            getTracks()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as! TrackTableViewCell
        // MARK: Put all of this setup into TrackTableViewCell function
        
        
        
        cell.titleLabel.text = trackItems[indexPath.row].name
        cell.artistLabel.text = trackItems[indexPath.row].artists[0].name

        let images = trackItems[indexPath.row].album.images
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("making api call to queue")
        tableView.deselectRow(at: indexPath, animated: true)
        let itemAtIndexPath = trackItems[indexPath.row]
//        updateQueue(item: itemAtIndexPath)
        
        presentAlertController(item: itemAtIndexPath)
        
//        sendTrackToFireBase(item: itemAtIndexPath)
        
//        let trackURI = itemAtIndexPath.uri
        
        

    }
    
}


