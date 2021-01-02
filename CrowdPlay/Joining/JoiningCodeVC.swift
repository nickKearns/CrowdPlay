//
//  JoiningCodeVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/2/21.
//

import UIKit


class JoiningCodeVC: UIViewController {
    
    
    var sessionID: String = ""
    
    let mainLabel: UILabel = {
        let l = UILabel()
        l.text = """
                Enter the code of the session
                you are trying to join.
                """
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = UIFont(name: "Avenir Heavy", size: 25)
        
        return l
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Session ID"
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
        inputTextField.delegate = self
        self.view.backgroundColor = .systemGray3
        setupUI()
        
    }
    
    
    
    func setupUI() {
        
        
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.95)
            
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputTextField.snp.top).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.90)
            
        }
        
    }
    
    
    
    
    
    
}

extension JoiningCodeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let code = textField.text ?? ""
        
//        self.ref.child(code).setValue("session")
        
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        
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
        
        return true
    }
    
    
}
