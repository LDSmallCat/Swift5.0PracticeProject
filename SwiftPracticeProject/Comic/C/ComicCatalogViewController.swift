//
//  ComicCatalogViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicCatalogViewController: LDBaseViewController {
    private var isPositive = true
    var detailStackModel: DetailStaticModel! {
        didSet { tb.reloadData() }
    }
    
    lazy var tb: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 5
        lt.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        cv.register(supplementaryViewType: ComicCatalogHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(cellType: ChapterCollectionViewCell.self)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if detailStackModel == nil {
            guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
            detailStackModel = pvc.detailStackModel
            
        }
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension ComicCatalogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { detailStackModel.chapter_list.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ChapterCollectionViewCell.self)
        if isPositive {
            cell.cModel = detailStackModel.chapter_list[indexPath.row]
        }else {
            cell.cModel = detailStackModel.chapter_list.reversed()[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: ComicCatalogHeader.self)
            header.model = detailStackModel
            header.sortClosure = { [weak self] button in
                if self?.isPositive == true {
                    self?.isPositive = false
                    button.setTitle("倒序", for: .normal)
                }else{
                    self?.isPositive = true
                    button.setTitle("正序", for: .normal)
                }
                collectionView.reloadData()
            }
            return header
            
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: screenWidth, height: navgationBarHeight) }
    
}

extension ComicCatalogViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
            parent.slideDirection(down: scrollView.contentOffset.y < 0)
        }
}
