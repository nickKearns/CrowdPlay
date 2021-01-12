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


    
    var offset: Int = 0
    
    var trackItems: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    

    

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


