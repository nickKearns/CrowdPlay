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
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Enter your session code"
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.font = UIFont(name: "Avenir Heavy", size: 20)
         
        return l
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Session Code"
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
        self.view.backgroundColor = .systemGray3
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
    
    func showMainView(code: String) {
        
        //add the session code to the db
        self.ref.child(code).setValue("session")
        
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        queueVC.isHost = true
        addSongVC.isHost = true
        
        let tabBar = UITabBarController()

        //give the vc's their respective images and titles
        queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue.png"), selectedImage: nil)
        addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong.png"), selectedImage: nil)

        addSongVC.queueVCInstance = queueVC
        
        //embed the vcs in nav controllers to get the search bar and titles
        let addSongNav = UINavigationController(rootViewController: addSongVC)
        let queueNav = UINavigationController(rootViewController: queueVC)
        
        addSongVC.sessionID = code
        queueVC.sessionID = code
        
        
        // add the vc's to the tab bar
        tabBar.viewControllers = [addSongNav, queueNav]
        
        tabBar.navigationController?.navigationBar.prefersLargeTitles = true
        tabBar.navigationItem.setHidesBackButton(true, animated: true)
        
        tabBar.title = "Session: \(code)"
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.pushViewController(tabBar, animated: true)
        
    }
    
    
}

extension HostsCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let code = inputTextField.text ?? ""
        
        showMainView(code: code)
        
        return true
    }
    
}
