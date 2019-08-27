//
//  ComicDetailDescriptionCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/27.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicDetailDescriptionCell: LDBaseTableViewCell {
  
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.text = "作品简介"
        return tl
    }()

    lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 15)
        dl.numberOfLines = 0
        return dl
    }()
    
    override func configUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    
}
