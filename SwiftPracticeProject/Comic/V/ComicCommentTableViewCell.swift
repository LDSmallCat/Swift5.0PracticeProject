//
//  ComicCommentTableViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/29.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicCommentTableViewCell: LDBaseTableViewCell {
    
    var cModel: ComicCommentModel! {
            didSet {
                headerImg.kf.setImage(with: URL(string: cModel.face))
                nameLabel.text = cModel.nickname
                commentLabel.text = cModel.content_filter
            }
    }
    
    lazy var headerImg: UIImageView = {
        let hg = UIImageView()
        hg.contentMode = .scaleAspectFill
        hg.layer.cornerRadius = 20
        hg.layer.masksToBounds = true
        return hg
    }()

    lazy var nameLabel: UILabel = {
        let nl = UILabel()
        nl.textColor = UIColor.gray
        nl.font = UIFont.systemFont(ofSize: 13)
        return nl
    }()
    
    lazy var commentLabel: UILabel = {
        let cl = UILabel()
        cl.numberOfLines = 0
        cl.textColor = UIColor.gray
        cl.font = UIFont.systemFont(ofSize: 13)
        return cl
    }()
    
    override func configUI() {
        contentView.addSubview(headerImg)
        headerImg.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(headerImg.snp.right).offset(10)
            $0.top.equalTo(headerImg)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(15)
        }
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.left.right.equalTo(nameLabel)
            $0.bottom.greaterThanOrEqualToSuperview().offset(-10)
        }
    }
    
    
    
    
}
