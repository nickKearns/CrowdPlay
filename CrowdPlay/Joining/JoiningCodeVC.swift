//
//  JoiningCodeVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/2/21.
//

import UIKit
import FirebaseDatabase


class JoiningCodeVC: UIViewController {
    
    
    var sessionID: String = ""
    
    let ref = Database.database().reference()
    
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
        tf.placeholder = "Session code"
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
        self.view.backgroundColor = .systemBackground
        setupUI()
        
    }
    
    
    
    func setupUI() {
        
        
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.75)
            
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputTextField.snp.top).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.90)
            
        }
        
    }
    
    func getShorterCode(sessionID: String) -> String {
        
        let length = sessionID.count
        let first5 = String(sessionID.prefix(5))
        self.sessionID = first5
        
        return first5
        
    }
    
    
    @objc func shareButtonTapped() {
        
//        let shorterCode = getShorterCode(sessionID: self.sessionID)
        
        let shareCodeVC = ShareCodeVC()
        present(shareCodeVC, animated: true, completion: nil)
        shareCodeVC.passSessionID(sessionID: self.sessionID)
        
    }
    
    
    func showMainView(code: String) {
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        
        self.sessionID = code
        
        //search for the database instance that ends in the inputed code
        
//        let ref = Database.database().reference().queryEnding(atValue: code).ref
        
        
        
        let tabBar = UITabBarController()

        //give the vc's their respective images and titles
        queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue"), selectedImage: nil)
        addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong"), selectedImage: nil)

//        addSongVC.queueVCInstance = queueVC
        
        //embed the vcs in nav controllers to get the search bar and titles
        let addSongNav = UINavigationController(rootViewController: addSongVC)
        let queueNav = UINavigationController(rootViewController: queueVC)
        
        addSongVC.sessionID = code
        
        queueVC.sessionID = code
        
        tabBar.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareButtonTapped))
        
        self.ref.child(code).child("Session Name").observe(.value, with: { (snapshot) in
            guard let sessionName = snapshot.value else {return}
            tabBar.title = "Session: \(sessionName)"
            
        })
        
        // add the vc's to the tab bar
        tabBar.viewControllers = [addSongNav, queueNav]
        
        tabBar.navigationController?.navigationBar.prefersLargeTitles = true
        tabBar.navigationItem.setHidesBackButton(true, animated: true)
        
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.pushViewController(tabBar, animated: true)
    }
    
    
    
}

extension JoiningCodeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if code is empty there needs to be a non nil string
        let code = textField.text ?? "blank"
        
        
//        let ref = Database.database().reference()
        
        let fullCode = ref.queryOrderedByKey().queryStarting(atValue: code).queryEnding(atValue: "\(code)\\utf8ff")
        print(fullCode)
//        print(fullCode)
        
        ref.child(code).child("Session Name").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                print(snapshot)
                self.showMainView(code: code)
            }
            else {
                let alert = UIAlertController(title: "Session Not Found", message: "Session not found", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(action1)
                self.present(alert, animated: true, completion: nil)
                textField.resignFirstResponder()
                textField.text = ""
            }
            
        })
            
        
        
        
        
        return true
    }
    
    
}
