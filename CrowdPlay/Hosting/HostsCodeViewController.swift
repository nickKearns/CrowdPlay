//
//  HostsCodeViewController.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/30/20.
//

import UIKit
import Firebase
import SnapKit


class HostsCodeViewController: UIViewController {
    
    var ref = Database.database().reference()
    
    
    
    var sessionInstance: FirebaseDatabase.DatabaseReference?
    var sessionID: String = ""
    var sessionName: String = ""
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Enter your session name"
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.font = UIFont(name: "Avenir Heavy", size: 20)
        
        return l
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Session Name"
        tf.backgroundColor = .clear
        tf.layer.borderColor = CGColor(red: 0, green: 0, blue: 1, alpha: 1)
        tf.layer.borderWidth = 3
        tf.layer.cornerRadius = 10
        tf.textAlignment = .center
        tf.returnKeyType = .go
        
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = false
        inputTextField.delegate = self
        
        
        setupUI()
    }
    
    
    func setupUI() {
        self.view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview()
        }
        
        descriptionLabel.layer.cornerRadius = 10
        
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }

        
    }
    
    
    @objc func shareButtonTapped() {
        
        let shareCodeVC = ShareCodeVC()
//        let shorterCode = getShorterCode(sessionID: self.sessionID)
        present(shareCodeVC, animated: true, completion: nil)
        shareCodeVC.passSessionID(sessionID: self.sessionID)
        
    }
    
    
    func getShorterCode(sessionID: String) -> String {
        
        let length = sessionID.count
        let last4 = String(sessionID.suffix(from: String.Index(encodedOffset: length-4)))
        self.sessionID = last4
        
        return last4
        
    }
    
    func showMainView(sessionId: String, sessionName: String) {
        
        //add the session code to the db
        self.ref.child(sessionID).setValue("session")
        self.ref.child(sessionID).child("Session Name").setValue(self.sessionName)
        
        
        
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        queueVC.isHost = true
        addSongVC.isHost = true
        
        let tabBar = UITabBarController()

        
        
        
        //give the vc's their respective images and titles
        queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue.png"), selectedImage: nil)
        addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong"), selectedImage: nil)

//        addSongVC.queueVCInstance = queueVC
        
        //embed the vcs in nav controllers to get the search bar and titles
        let addSongNav = UINavigationController(rootViewController: addSongVC)
        let queueNav = UINavigationController(rootViewController: queueVC)
        
        
//        let shorterCode = getShorterCode(sessionID: sessionId)
        self.sessionID = sessionId
        
        addSongVC.sessionID = self.sessionID
        addSongVC.sessionName = self.sessionName
        queueVC.sessionID = self.sessionID
        queueVC.sessionName = self.sessionName
        
        
        // add the vc's to the tab bar
        tabBar.viewControllers = [addSongNav, queueNav]
                
        tabBar.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareButtonTapped))
        
        tabBar.navigationItem.setHidesBackButton(true, animated: true)
        
        tabBar.title = "Session: \(self.sessionName)"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        let playBackView = PlayBackView()
        tabBar.view.addSubview(playBackView)
        playBackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(tabBar.tabBar.snp.top)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }
        
        navigationController?.pushViewController(tabBar, animated: true)
        
    }
    
    
}

extension HostsCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = inputTextField.text ?? ""
        
        self.sessionInstance = self.ref.childByAutoId()
        self.sessionID = (self.sessionInstance?.key)!
        self.sessionName = name
        
        showMainView(sessionId: self.sessionID, sessionName: self.sessionName)
        
        return true
    }
    
}
