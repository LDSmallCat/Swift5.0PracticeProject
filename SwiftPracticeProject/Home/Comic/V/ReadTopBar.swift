//
//  ReadTopBar.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ReadTopBar: UIView {

    lazy var backButton: UIButton = {
        let bb = UIButton(type: .custom)
        bb.setImage(UIImage.init(named: "nav_back_black"), for: .normal)
        return bb
    }()

    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.textColor = UIColor.black
        tl.font = UIFont.boldSystemFont(ofSize: 18)
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI() {
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.left.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }
    }
}


class ReadBottomBar: UIView {
    lazy var menuSlider: UISlider = {
        let ms = UISlider()
        ms.thumbTintColor = UIColor.theme
        ms.minimumTrackTintColor = UIColor.theme
        ms.isContinuous = false
        return ms
    }()
    
    lazy var diviceDirectionButton: UIButton = {
        let db = UIButton(type: .system)
        db.setImage(UIImage.init(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return db
        
    }()
    
    lazy var lightButton: UIButton = {
        let lb = UIButton(type: .system)
        lb.setImage(UIImage.init(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return lb
    }()
    
    lazy var chapterButton: UIButton = {
        let cb = UIButton(type: .system)
        cb.setImage(UIImage.init(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configUI() {
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            $0.height.equalTo(30)
        }
        
        let width = (screenWidth - 200) / 3
        
        addSubview(diviceDirectionButton)
        diviceDirectionButton.snp.makeConstraints { $0.bottom.equalToSuperview()
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.width.equalTo(width)
            $0.left.equalToSuperview().offset(40)
        }
        
        addSubview(lightButton)
        lightButton.snp.makeConstraints { $0.bottom.equalToSuperview()
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.width.equalTo(width)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(chapterButton)
        chapterButton.snp.makeConstraints { $0.bottom.equalToSuperview()
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.width.equalTo(width)
            $0.right.equalToSuperview().offset(-40)
        }
        

    }
}
