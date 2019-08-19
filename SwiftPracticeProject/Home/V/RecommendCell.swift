//
//  RecommendCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/19.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

enum CellType {
    case none
    case title
    case titleAndDesc
}



class RecommendCell: LDBaseCollectionViewCell {
    
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 12)
        return dl
    }()
    
    override func configUI() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(25)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(coverImage)
        coverImage.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.right.equalTo(titleLabel)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    var style: CellType = .title {
        didSet {
            switch style {
            case .none:
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(25)
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
            case .title:
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-10)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
            case .titleAndDesc:
                titleLabel.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-25)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
            }
        }
    }
    
    lazy var coverImage: UIImageView = {
            let ci = UIImageView()
            ci.contentMode = .scaleAspectFill
            ci.clipsToBounds = true
            return ci
        }()
    
    var model: ComicModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.name
            descLabel.text = model.subTitle            
            coverImage.kf.setImage(with: URL(string: model.cover))
         
        }
    }
    
}


