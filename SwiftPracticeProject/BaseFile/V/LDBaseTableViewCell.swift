//
//  LDBaseTableViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/19.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDBaseTableViewCell: UITableViewCell, Reusable {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() { }
}
