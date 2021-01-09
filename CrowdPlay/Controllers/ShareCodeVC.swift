//
//  ShareCodeVC.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/9/21.
//

import UIKit



class ShareCodeVC: UIViewController {
    
    var sessionID: String? {
        didSet {
            self.mainLabelTV.text =   """
                                    Your Unique
                                    Code is:
                                    \(sessionID ?? "error")
                                    """
        }
    }
    
    
    let mainLabelTV: UITextView = {
        let tv = UITextView()
        tv.text = "Your Unique Code is: "
        tv.textAlignment = .center
        tv.font = UIFont(name: "Avenir Heavy", size: 35)
        tv.isEditable = false
        tv.layer.cornerRadius = 10
        tv.backgroundColor = .systemBlue
        
        return tv
    }()
    
    
    init(sessionID: String) {
        super.init(nibName: nil, bundle: nil)
        self.sessionID = sessionID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 10
        
        setupUI()
        
    }
    
    
    func passSessionID(sessionID: String) {
        
        self.sessionID = sessionID
        
    }
    
    
    
    func setupUI() {
        self.view.addSubview(mainLabelTV)
        mainLabelTV.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.50)
            make.width.equalToSuperview().multipliedBy(0.90)
            
            
        }
        
        
    }
    
    
    
}
