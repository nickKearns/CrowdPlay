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
        
        setupUI()
        
    }
    
    
    
    func setupUI() {
        
        
        self.view.addSubview(inputTextField)
        inputTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.30)
            make.width.equalToSuperview().multipliedBy(0.75)
            
        }
        
        self.view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputTextField.snp.top).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.30)
            make.width.equalToSuperview().multipliedBy(0.30)
            
        }
        
    }
    
    
}
