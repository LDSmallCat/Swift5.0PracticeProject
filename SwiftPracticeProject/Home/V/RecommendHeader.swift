//
//  RecommendHeader.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/19.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

typealias RecommendHeaderMoreActionClosure = ()->Void

class RecommendHeader: LDBaseCollectionReusableView {
   
    
    lazy var imgView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLbael: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = .black
        return tl
    }()
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("•••", for: .normal)
        mn.setTitleColor(.lightGray, for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        mn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return mn
    }()
    
    private var moreActionClosure: RecommendHeaderMoreActionClosure?
    
     @objc func moreAction(button: UIButton) {
        guard let colsure = moreActionClosure else { return }
        colsure()
    }
    
    func moreActionClosure(_ closure: RecommendHeaderMoreActionClosure?) {
        moreActionClosure = closure
    }
    override func configUI() {
        backgroundColor = UIColor.white
        addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        addSubview(titleLbael)
        titleLbael.snp.makeConstraints {
            $0.left.equalTo(imgView.snp.right).offset(5)
            $0.centerY.height.equalTo(imgView)
            $0.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
    }
}

class RecommendFooter: LDBaseCollectionReusableView {
    override func configUI() {
        backgroundColor = UIColor.background
    }
}
