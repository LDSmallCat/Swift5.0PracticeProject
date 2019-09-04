//
//  RecommendViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class RecommendViewController: LDBaseViewController {
    // MARK: - private property
    private var sex: Int = 2
    private var galleryItems = [GalleryItemModel]()
    private var comicLists = [ComicListModel]()

    private lazy var bannerView: LLCycleScrollView = {
        let bv = LLCycleScrollView()
        bv.backgroundColor = UIColor.background
        bv.autoScrollTimeInterval = 6
        bv.placeHolderImage = UIImage(named: "normal_placeholder")
        bv.coverImage = UIImage()
        bv.pageControlPosition = .right
        bv.pageControlBottom = 20
        bv.titleBackgroundColor = UIColor.clear
        bv.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let ft = UICollectionViewFlowLayout()
        ft.minimumInteritemSpacing = 5
        ft.minimumLineSpacing = 10
        
        ft.itemSize = CGSize(width: (screenWidth - 11) / 2 , height: 160)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: ft)
        cv.backgroundColor = UIColor.white
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        cv.scrollIndicatorInsets = cv.contentInset
        cv.ldHeader = LDRefreshHeader{ [weak self] in self?.loadData(sexType: self?.sex ?? 1)}
        cv.ldFooter = LDrefreshDiscoverFooter()
        cv.delegate = self
        cv.dataSource = self
        cv.register(supplementaryViewType: RecommendHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(supplementaryViewType: RecommendFooter.self, ofKind: UICollectionView.elementKindSectionFooter)
        cv.register(cellType: RecommendCell.self)
        return cv
    }()
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(sexType: sex)
        
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{             $0.edges.equalTo(self.view.usnp.edges)}
        
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{ $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
    }
}

// MARK: - selected index LLCycleScrollView
extension RecommendViewController {
    func didSelectBanner(index: Int) {
        let item = galleryItems[index]
        
        switch item.linkType {
                        
        case 2:
           guard let ext = item.ext.first else { return }
            let vc = LDWebViewController(url: ext.val)
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            guard let ext = item.ext.first else { return }
            let titles = ["详情","目录","评论"]
            let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
            let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
            
            cv.comicID = Int(ext.val) ?? 0
            cv.comicName = item.title
            navigationController?.pushViewController(cv, animated: true)
            
            
        }
        
    }
}

// MARK: - reuqest
extension RecommendViewController {
    
    
    func loadData(sexType: Int) {
        UApiLodingProvider.ldRequest(UApi.recommendList(sexType: sexType), successClosure: { [weak self] (json) in
            self?.collectionView.ldHeader.endRefreshing()
            if let cl = json["comicLists"].arrayObject {
                let ca = modelArray(from: cl, ComicListModel.self)
                self?.comicLists.append(contentsOf: ca)
            }
            
            if let gl = json["galleryItems"].arrayObject {
                let ga = modelArray(from: gl, GalleryItemModel.self)
                self?.galleryItems.append(contentsOf: ga)
                self?.bannerView.imagePaths = self?.galleryItems.map {
                                     $0.cover
                                 } ?? []
            }
                             
             self?.collectionView.reloadData()
             self?.collectionView.ldHeader.endRefreshing()
        }, abnormalClosure: { [weak self] (code, message) in
            print("abnormalClosure",code,message)
            self?.collectionView.ldHeader.endRefreshing()
        }) { [weak self] (message) in
            print("message")
            self?.collectionView.ldHeader.endRefreshing()
        }

        }
}

extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       return CGSize(width: (screenWidth - 11) / 2 , height: 160)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints {
                $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)))
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         self.comicLists.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         let comicListM = self.comicLists[section]
        return comicListM.comics.prefix(4).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecommendCell.self)
        let comicListM = self.comicLists[indexPath.section]
        let comicM = comicListM.comics[indexPath.row]
        cell.style = .titleAndDesc
        cell.model = comicM
        cell.coverImage.backgroundColor = UIColor.random
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle.count > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: RecommendHeader.self)
            let comicList = comicLists[indexPath.section]
            head.imgView.kf.setImage(with: URL(string: comicList.newTitleIconUrl))
            head.titleLbael.text = comicList.itemTitle
            head.moreActionClosure { [weak self] in
                switch comicList.comicType {
                case .thematic:
                let vc = LDPageViewController(titles: ["漫画","次元"], vcs: [SpecialViewController(argCon: 2),SpecialViewController(argCon: 4)], pageStyle: .navgationBar)
                self?.navigationController?.pushViewController(vc, animated: true)
                case .animation:
                let vc = LDWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                vc.title = "动画"
                self?.navigationController?.pushViewController(vc, animated: true)
                case .update:
                let updateVC = UpdateListViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                updateVC.title = comicList.itemTitle
                self?.navigationController?.pushViewController(updateVC, animated: true)
                default:
                let moreVC = MoreComicViewController(argCon: comicList.argCon, argName: comicList.argName, argValue: comicList.argValue)
                moreVC.title = comicList.itemTitle
                self?.navigationController?.pushViewController(moreVC, animated: true)
                }
                
                
            }
           
            
            return head
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: RecommendFooter.self)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        let item = comicList.comics[indexPath.row]
        
        if comicList.comicType == .billboard {
        let moreVC = MoreComicViewController(argName: item.argName, argValue: item.argValue)
        moreVC.title = item.name
        self.navigationController?.pushViewController(moreVC, animated: true)
            
        } else {
            
            switch item.linkType {
            case 2:
                guard let ext = item.ext.first else { return }
                let vc = LDWebViewController(url: ext.val)
                navigationController?.pushViewController(vc, animated: true)
                
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
}
