//
//  TrackTableViewCell.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/2/20.
//

import UIKit
import SnapKit
import Kingfisher

class TrackTableViewCell: UITableViewCell {
    
    
    static let identifier: String = "TrackTableViewCell"
    
    
    let trackImage: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let artistLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.lineBreakMode = .byTruncatingMiddle
        l.numberOfLines = 1
        
        return l
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = false
        
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        self.addSubview(trackImage)
        trackImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()

        }

        
        
        self.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8).priority(.low)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.40).priority(.high)
            
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(75)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.40).priority(.high)
        }
        
    }
    
    
    
}

