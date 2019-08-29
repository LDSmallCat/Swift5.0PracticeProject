//
//  ComicDetailDescriptionCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/27.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicDetailDescriptionCell: LDBaseTableViewCell {

    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.text = "作品简介"
        return tl
    }()

    lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.font = UIFont.systemFont(ofSize: 15)
        dl.numberOfLines = 0
        return dl
    }()
    
    override func configUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    
}


class ComicOtherWorksCell: LDBaseTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.text = "其他作品"
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ComicTicketsWorksCell: LDBaseTableViewCell {
    override func configUI() {
        super.configUI()
        textLabel?.textAlignment = .center
    }
}

class ComicGuessLikeCell: LDBaseTableViewCell,UICollectionViewDataSource, UICollectionViewDelegate {
    var guessMolde = [ComicModel]() { didSet { cv.reloadData() } }
 
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "猜你喜欢"
        return lb
    }()
    lazy var cv: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        lt.itemSize = CGSize(width: floor((screenWidth - 60) / 4), height: 145)
        lt.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.dataSource = self
        cv.delegate = self
        cv.register(cellType: RecommendCell.self)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override func configUI() {
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(cv)
        cv.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.bottom.right.equalToSuperview()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { guessMolde.count }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecommendCell.self)
        cell.style = .title
        cell.model = guessMolde[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let titles = ["详情","目录","评论"]
        let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
        
        let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
        cv.comicID = guessMolde[indexPath.row].comic_id
        guard let nav = topVC?.navigationController else { return }
        nav.pushViewController(cv, animated: true)
    }
}
