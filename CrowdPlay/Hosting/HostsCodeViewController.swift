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
        l.text = "Enter your session name"
        l.textAlignment = .center
        l.backgroundColor = .systemBlue
        l.font = UIFont(name: "Avenir Heavy", size: 20)
         
        return l
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Session Name"
        tf.backgroundColor = .systemBlue
        tf.returnKeyType = .go
        
        return tf
    }()
    
    let submitButton: UIButton = {
        let b = UIButton()
        b.setTitle("Go", for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 40)
        
        return b
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
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        descriptionLabel.layer.cornerRadius = 10
        
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }
//        inputTextField.addTarget(self, action: #selector(returnButtonTapped), for: .editingDidEndOnExit)
        
//        self.view.addSubview(submitButton)
//        submitButton.snp.makeConstraints { (make) in
//            make.top.equalTo(inputTextField.snp.bottom)
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.75)
//
//        }
//        submitButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        
        
    }
    
    @objc func buttonTapped() {
        let code = inputTextField.text ?? ""
        self.ref.child(code).setValue("session")
        
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        
        let tabBar = UITabBarController()

        queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue.png"), selectedImage: nil)
        addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong.png"), selectedImage: nil)

        addSongVC.queueVCInstance = queueVC

        let addSongNav = UINavigationController(rootViewController: addSongVC)
        let queueNav = UINavigationController(rootViewController: queueVC)

        tabBar.viewControllers = [addSongNav, queueNav]
        
        navigationController?.pushViewController(tabBar, animated: true)
        navigationController?.title = "Sesson: \(code)"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//    @objc func returnButtonTapped() {
//
//
//
//    }
    
}

extension HostsCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let code = inputTextField.text ?? ""
        self.ref.child(code).setValue("session")
        
        let queueVC = QueueVC()
        let addSongVC = AddSongVC()
        
        let tabBar = UITabBarController()

        queueVC.tabBarItem = UITabBarItem(title: "Queue", image: UIImage(named: "queue.png"), selectedImage: nil)
        addSongVC.tabBarItem = UITabBarItem(title: "Add Songs", image: UIImage(named: "addSong.png"), selectedImage: nil)

        addSongVC.queueVCInstance = queueVC

        let addSongNav = UINavigationController(rootViewController: addSongVC)
        let queueNav = UINavigationController(rootViewController: queueVC)

        tabBar.viewControllers = [addSongNav, queueNav]
        
        navigationController?.pushViewController(tabBar, animated: true)
        navigationController?.title = "Sesson: \(code)"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        return true
    }
    
}
