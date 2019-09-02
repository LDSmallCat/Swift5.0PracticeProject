//
//  VIPViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class VIPViewController: LDBaseViewController {
    var vipList = [ComicListModel]()
    
   private lazy var cv: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        lt.itemSize = CGSize(width: (screenWidth - 21)/3, height: 240)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.alwaysBounceVertical = true
        cv.register(cellType: RecommendCell.self)
        cv.register(supplementaryViewType: RecommendHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(supplementaryViewType: RecommendFooter.self, ofKind: UICollectionView.elementKindSectionFooter)
        cv.ldHeader = LDRefreshHeader(refreshingBlock: {[weak self] in self?.loadData()})
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configUI() {
        super.configUI()
        view.addSubview(cv)
        cv.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func loadData() {
        UApiLodingProvider.ldRequest(UApi.vipList, successClosure: {[weak self] (json) in
            print(json)
            guard let nt = json["newVipList"].arrayObject else {return}
            let ar = modelArray(from: nt, ComicListModel.self)
            self?.vipList.append(contentsOf: ar)
            self?.cv.reloadData()
            self?.cv.ldHeader.endRefreshing()
        }, abnormalClosure: { (_, _) in }) { (_) in }
    }

}

extension VIPViewController: UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { vipList.count }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { vipList[section].comics.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecommendCell.self)
        cell.style = .title
        let model = vipList[indexPath.section].comics[indexPath.row]
        cell.model = model
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let comicList = vipList[indexPath.section]
            let item = comicList.comics[indexPath.row]
            
            
            if comicList.comicType == .billboard { } else {
                
                switch item.linkType {
                    
                case 2:
                    print(item.linkType)
                    
                default:
                    let titles = ["详情","目录","评论"]
                    let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
                    let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
                    cv.comicID = item.comicId
                    cv.comicName = item.name
                    navigationController?.pushViewController(cv, animated: true)
                    
                    
                }
        
            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: screenWidth, height: 44)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

       return section == vipList.count - 1 ? CGSize.zero : CGSize(width: screenWidth, height: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: RecommendHeader.self)
            let vipModel = vipList[indexPath.section]
            header.imgView.kf.setImage(with: URL(string: vipModel.newTitleIconUrl))
            header.titleLbael.text = vipModel.itemTitle
            header.moreButton.isHidden = !vipModel.canMore
            header.moreActionClosure { print(vipModel.itemTitle) }
            return header;
        }else{
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: RecommendFooter.self)
                   return foot
            
        }
    }
}
