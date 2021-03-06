//
//  PlayBackView.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 1/2/21.
//

import Foundation


class PlayBackView: UIView  {
    
    // 1 means that music is being played -1 means it is paused
    //
    var isPlaying: Int = -1 {
        didSet {
            if isPlaying == 1 {
                self.pausePlayButton.isSelected = true
            }
            else {
                self.pausePlayButton.isSelected = false
            }
        }
    }
    
    
    let pausePlayButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "play"), for: .selected)
        b.setImage(UIImage(named: "pause"), for: .normal)
        
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
        b.setImage(UIImage(named: "skip"), for: .normal)
        
        return b
    }()
    
    
    
    
    let previousButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "previous"), for: .normal)
        
        return b
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray4
        
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
        
        pausePlayButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        previousButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            
        }
        
        skipButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            
        }
        
        stackView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        
        
        pausePlayButton.addTarget(self, action: #selector(pausePlayTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        
        
    }
    
    
    @objc func pausePlayTapped() {
        
        
        
        
        if self.isPlaying == -1 {
            
            APIRouter.shared.pauseRequest(completion: { result in
                switch result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        else {
            APIRouter.shared.playRequest(completion: { result in
                switch result {
                case .success(let any):
                    print(any)
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        
        self.isPlaying = self.isPlaying * -1
        
        
    }
    
    @objc func skipTapped() {
        
        self.isPlaying = -1
        
        APIRouter.shared.skipRequest(completion: { result in
            switch result {
            case .success(let any):
                print(any)
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    @objc func previousTapped() {
        
        self.isPlaying = -1
        
        APIRouter.shared.previousRequest(completion: { result in
            switch result {
            case .success(let any):
                print(any)
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    
    
    
}
