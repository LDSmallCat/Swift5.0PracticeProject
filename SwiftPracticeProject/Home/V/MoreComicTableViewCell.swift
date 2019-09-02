//
//  MoreComicTableViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class MoreComicTableViewCell: LDBaseTableViewCell {
    var spinnerName: String?
    var model: ComicModel? {
        didSet {
            guard let ml = model else { return }
            img.kf.setImage(with: URL(string: ml.cover), placeholder: UIImage(named: "normal_placeholder_v"))
            
            titleLabel.text = ml.name
            subTitleLabel.text = ml.tags.joined(separator: "  ") + " | " + ml.author
            descLabel.text = ml.description
            if spinnerName == "更新时间" {
                orderView.isHidden = true
                tagLabel.text = spinnerName! + ml.tagString
            }else{
                orderView.isHidden = false
                tagLabel.text = spinnerName! + ml.clickString
            }
        }
    }
    
    
    private lazy var img: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    private lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()

    private lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    private lazy var orderView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()
    
     
    override func configUI() {
        separatorInset = .zero
        
        contentView.addSubview(img)
        img.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
            $0.width.equalTo(100)
        }
        img.backgroundColor = UIColor.blue
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(img.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(img)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.right.left.equalTo(titleLabel)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }

        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints {
            $0.bottom.equalTo(img.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }

        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(img.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(img.snp.bottom)
        }
    }

}
