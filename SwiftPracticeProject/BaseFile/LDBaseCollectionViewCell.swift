//
//  LDBaseCollectionViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/19.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDBaseCollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI() { }
}
