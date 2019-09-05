//
//  RankCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/21.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class RankCell: LDBaseTableViewCell {
    lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let te = UILabel()
        te.textColor = UIColor.black
        te.font = UIFont.systemFont(ofSize: 18)
        return te
    }()
    
    lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 14)
        dl.numberOfLines = 0
        return dl
    }()
    
    override func configUI() {
        
        let line = UIView()
        line.backgroundColor = UIColor.background
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        contentView.addSubview(img)
        img.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(line.snp.top).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(img.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(img).offset(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(img)
        }
    }
    
    var model: RankModel? {
        didSet {
            guard let model = model else { return }
            img.kf.setImage(with: URL(string: model.cover))
            titleLabel.text = "\(model.title)榜"
            descLabel.text = model.subTitle
        }
    }
    
}
