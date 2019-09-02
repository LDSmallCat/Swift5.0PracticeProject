//
//  UpdateTableViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class UpdateTableViewCell: LDBaseTableViewCell {
    var model: ComicModel? {
            didSet {
                guard let ml = model else { return }
                coverView.kf.setImage(with: URL(string: ml.cover))
                tipLabel.text = "   \(ml.description)"
            }
        }
        
        
        
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
            contentView.addSubview(coverView)
            coverView.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))

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
