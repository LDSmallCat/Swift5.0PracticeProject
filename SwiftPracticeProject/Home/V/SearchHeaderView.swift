//
//  SearchHeaderView.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/3.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

typealias SearchHeaderActionClosure = () -> Void

class SearchHeaderView: BaseTableViewHeaderFooterView {

    private var moreActionClosure: SearchHeaderActionClosure?
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.black.withAlphaComponent(0.7)
        return tl
    }()

    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .custom)
        mn.setTitleColor(UIColor.lightGray, for: .normal)
        mn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return mn
    }()
    
    @objc private func moreAction(button: UIButton) {
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: @escaping SearchHeaderActionClosure) {
        moreActionClosure = closure
    }
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.background
        contentView.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        
    }
}
