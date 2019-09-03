//
//  BaseTableViewHeaderFooterView.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/3.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView,Reusable {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configUI()
    }
    func configUI() { }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
