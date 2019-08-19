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
    private var sex: Int = 1
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
        cv.backgroundColor = UIColor.background
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        cv.scrollIndicatorInsets = cv.contentInset
        cv.ldHeader = LDRefreshHeader{ [weak self] in self?.loadData(sexType: self?.sex ?? 1)}
        cv.ldFooter = LDrefreshDiscoverFooter()
        cv.delegate = self
        cv.dataSource = self
        
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
        collectionView.snp.makeConstraints{ $0.edges.equalToSuperview()}
        
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
        
        print(item.linkType, item.id, item.cover)
        
    }
}

// MARK: - reuqest
extension RecommendViewController {
    func loadData(sexType: Int) {
        ApiProvider.request(LDApi.recommendList(sexType: sexType), callbackQueue: nil, progress: nil) { [weak self] (result) in
            
            guard let data = result.value?.data else { return }
            let json = JSON(data)
            let comicListsJson = json["data"]["returnData"]["comicLists"].arrayObject
            guard let comicListsArray = modelArray(from: comicListsJson, ComicListModel.self) else { return }
            self?.comicLists.append(contentsOf: comicListsArray)
           self?.collectionView.reloadData()
            
            let galleryItemsJson = json["data"]["returnData"]["galleryItems"].arrayObject
            guard let galleryArray = modelArray(from: galleryItemsJson, GalleryItemModel.self) else { return }
            self?.galleryItems.append(contentsOf: galleryArray)
            self?.bannerView.imagePaths = self?.galleryItems.map {
                $0.cover
            } ?? []
            
            
        }

    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    
}
