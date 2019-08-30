//
//  ChapterCollectionViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/30.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: LDBaseCollectionViewCell {
    
    var cModel: ChapterModel = ChapterModel() {
        didSet {
            nameLabel.text = cModel.name
            //nameLabel.backgroundColor = UIColor.red
        }
    }
    
    
    lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
    }
    
    
}
