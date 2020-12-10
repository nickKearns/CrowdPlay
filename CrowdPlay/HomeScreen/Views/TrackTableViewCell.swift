//
//  TrackTableViewCell.swift
//  CrowdPlay
//
//  Created by Nicholas Kearns on 12/2/20.
//

import UIKit
import SnapKit

class TrackTableViewCell: UITableViewCell {
    
    
    static let identifier: String = "TrackTableViewCell"
    
    
    let artistLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        
        return l
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        
        return l
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            //            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        self.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            
        }
        
    }
    
    
    
}
