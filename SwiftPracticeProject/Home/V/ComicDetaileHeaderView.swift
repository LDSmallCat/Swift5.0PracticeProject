//
//  ComicDetaileHeaderView.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/26.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit
class ComicDetailHeaderCell: LDBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    override func configUI() {
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

class ComicDetaileHeaderView: UIView {
    lazy var bgView: UIImageView = {
        let bv = UIImageView()
        bv.contentMode = .scaleAspectFill
        bv.clipsToBounds = true
        bv.isUserInteractionEnabled = true
        return bv
    }()
    lazy var blurView: UIVisualEffectView = {
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return blurView
    }()
    lazy var coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.layer.cornerRadius = 3
        cv.layer.borderWidth = 1
        cv.layer.borderColor = UIColor.white.cgColor
        return cv
    }()
    
    lazy var titleLabel:  UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.white
        tl.font = UIFont.systemFont(ofSize: 16)
        return tl
    }()

    lazy var authorLabel:  UILabel = {
        let al = UILabel()
        al.textColor = UIColor.white
        al.font = UIFont.systemFont(ofSize: 13)
        return al
    }()
    
    lazy var clickCollectLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = UIColor.white
        cl.font = UIFont.systemFont(ofSize: 13)
        return cl
    }()
    
    lazy var tagView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 5
        lt.itemSize = CGSize(width: 40, height: 20)
        lt.scrollDirection = .horizontal
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.clear
        cw.showsVerticalScrollIndicator = false
        cw.register(cellType: ComicDetailHeaderCell.self)
        cw.dataSource = self
        return cw
    }()
    
    var tags = [String]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubview(bgView)
        bgView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        
        bgView.addSubview(blurView)
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        bgView.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0))
            $0.width.equalTo(90)
            $0.height.equalTo(120)
        }
        
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(coverView.snp.right).offset(20)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(coverView)
            $0.height.equalTo(20)
        }
        
        bgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            $0.left.height.equalTo(titleLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        bgView.addSubview(clickCollectLabel)
        clickCollectLabel.snp.makeConstraints {
            $0.left.height.equalTo(authorLabel)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.top.equalTo(authorLabel.snp.bottom).offset(10)
        }
        
        bgView.addSubview(tagView)
        tagView.snp.makeConstraints {
            $0.left.equalTo(clickCollectLabel)
            $0.height.equalTo(30)
            $0.right.greaterThanOrEqualToSuperview().offset(-20)
            $0.bottom.equalTo(coverView)
        }
    }
}

extension ComicDetaileHeaderView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicDetailHeaderCell.self)
        cell.titleLabel.text = tags[indexPath.row]
        return cell
    }
    
    
}

extension ComicDetaileHeaderView {
    func loadData() {
       
        
        
    }
}
