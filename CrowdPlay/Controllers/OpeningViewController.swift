//
//  OpeningViewController.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/27/20.
//

import Foundation
import UIKit
import SnapKit

class OpeningViewController: UIViewController {
    
    
    let mainLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.text = """
                Host a Session or
                Join a Session
                """
        l.numberOfLines = 0
        l.font = UIFont(name: "Avenir Heavy", size: 25)
        
        return l
    }()
    
    let appNameLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.text = "QShare!"
        l.font = UIFont(name: "Avenir Heavy", size: 50)
        
        return l
    }()
    
    let hostButton: UIButton = {
        let b = UIButton()
        b.setTitle("Host", for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 30)
        
        return b
    }()
    
    let joinButton: UIButton = {
        let b = UIButton()
        b.setTitle("Join", for: .normal)
        b.backgroundColor = .systemBlue
        b.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 30)
        
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupButtons()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .systemBackground
        fetchSpotifyToken()
    }
    
    
    func fetchSpotifyToken() {
//        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        
        if UserDefaults.standard.string(forKey: "refresh_token") == nil {
            
            let loginVC = LoginVC()
            present(loginVC, animated: true, completion: nil)
//            openingVC.modalPresentationStyle = .overCurrentContext
            
        }
        
        
        
//        navigationController?.present(LoginVC(), animated: true, completion: nil)
        
    }
    
    
    func setupLabels() {
        self.view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.10)
        }
        
        self.view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(mainLabel.snp.top)
            make.height.equalToSuperview().multipliedBy(0.20)
            
        }
        
    }
    
    
    func setupButtons() {
        
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(hostButton)
        stackView.addArrangedSubview(joinButton)
        
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(mainLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        
        hostButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        hostButton.layer.cornerRadius = 10
        
        joinButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        joinButton.layer.cornerRadius = 10
        
        
        //add targets for each button
        hostButton.addTarget(self, action: #selector(hostButtonTapped), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        
    }
    
    /// advances to giving the user their host code view
    @objc func hostButtonTapped() {
        // show the next view for hosting option
        
        navigationController?.pushViewController(HostsCodeViewController(), animated: true)
        
    }
    
    /// advances to the enter host's code view
    @objc func joinButtonTapped() {
        // show the next view for joining option
        navigationController?.pushViewController(JoiningCodeVC(), animated: true)
    }
    
    
}
