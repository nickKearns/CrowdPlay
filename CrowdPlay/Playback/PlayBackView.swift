//
//  PlayBackView.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/2/21.
//

import Foundation


class PlayBackView: UIView  {
    
    // provide these callbacks within the vc that utilizes this view
    // these callbacks will be used in the targets of each button
    var pausePlayCallback: (() -> Void)?
    var skipCallback: (() -> Void)?
    var previousCallback: (() -> Void)?
    
    
    let pausePlayButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "play.png"), for: .normal)
        b.setImage(UIImage(named: "pause.png"), for: .selected)
        
        return b
    }()
    
    
    
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        sv.distribution = .fillEqually
        
            
        
        return sv
    }()
    
    let skipButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "skip.png"), for: .normal)
        
        return b
    }()
    
    

    
    let previousButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "previous.png"), for: .normal)
        
        return b
    }()
    
   

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func setupUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(pausePlayButton)
        stackView.addArrangedSubview(skipButton)
        
        stackView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        pausePlayButton.addTarget(self, action: #selector(pausePlayTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        
    }
    
    
    @objc func pausePlayTapped() {
        
        pausePlayCallback?()
        
    }
    
    @objc func skipTapped() {
        
        skipCallback?()
        
    }
    
    @objc func previousTapped() {
        
        previousCallback?()
        
    }
    
    
    
    
}
