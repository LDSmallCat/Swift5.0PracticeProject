//
//  ComicCatalogViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicCatalogViewController: LDBaseViewController {
    
    var chapterList: [ChapterModel] = [] {
        didSet { tb.reloadData() }
    }

    lazy var tb: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 5
        lt.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        cv.register(cellType: ChapterCollectionViewCell.self)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if chapterList.isEmpty {
            guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
            chapterList = pvc.chapterList
        }
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension ComicCatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { chapterList.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ChapterCollectionViewCell.self)
        cell.cModel = chapterList[indexPath.row]
        return cell
    }
    
    
    
    
}

extension ComicCatalogViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
            parent.slideDirection(down: scrollView.contentOffset.y < 0)
        }
}
