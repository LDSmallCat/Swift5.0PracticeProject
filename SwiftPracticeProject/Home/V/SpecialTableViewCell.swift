//
//  SpecialTableViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class SpecialTableViewCell: LDBaseTableViewCell {
    
    var model: ComicModel? {
        didSet {
            guard let ml = model else { return }
            titleLabel.text = ml.title
            coverView.kf.setImage(with: URL(string: ml.cover))
            tipLabel.text = "   \(ml.subTitle)"
        }
    }
    
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.layer.cornerRadius = 5
        cv.layer.masksToBounds = true
        return cv
    }()

    private lazy var tipLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        tl.font = UIFont.systemFont(ofSize: 9)
        return tl
    }()
    
    override func configUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        coverView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.background
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
        
    }
}
