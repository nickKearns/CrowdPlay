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
import AuthenticationServices

class LoginVC: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    //    let keychain = KeychainSwift()
    
    let defaults = UserDefaults.standard
    
    
    let homeVC = AddSongVC()
    
    
    
    //MARK: UI ELEMENTS
    let signInButton: UIButton = {
        let b = UIButton()
        b.setTitle("Sign in with Spotify", for: .normal)
        b.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        b.tintColor = .systemBlue
        
        return b
    }()
    
    
    
    
    var accessToken = UserDefaults.standard.string(forKey: "access_token")
    
    
    
    
    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupButton()
        
        self.view.backgroundColor = .systemBackground
        
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
        APIRouter.shared.authRequest(viewController: self, completion: { url, error in
            
            guard let items = URLComponents(string: url?.absoluteString ?? "")?.queryItems else {return}
            let code = items[0].value!
            
            APIRouter.shared.getFirstAuthToken(code: code)
            self.dismiss(animated: true, completion: nil)
            
            
            
            
        })
    }
    
    
    
    
    //MARK: UI SETUP
    func setupButton() {
        self.view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            
        }
        
    }
    
    
}





