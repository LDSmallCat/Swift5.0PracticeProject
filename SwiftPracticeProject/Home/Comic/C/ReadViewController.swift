//
//  ReadViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/5.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ReadViewController: LDBaseViewController {
    private var selectIndex = 0
    private var previousIndex = 0
    private var nextIndex = 0
    private var chapterList = [ChapterModel]()
    private var detailStatic: DetailStaticModel?
    lazy var backScrollView: UIScrollView = {
        let bw = UIScrollView()
        bw.delegate = self
        bw.minimumZoomScale = 1.0
        bw.maximumZoomScale = 1.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        bw.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        bw.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
        return bw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = 10
        lt.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.backgroundColor = UIColor.background
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: ReadCollectionViewCell.self)
        return cv
    }()
    convenience init(detailStatic: DetailStaticModel?, selectIndex: Int) {
        self.init()
        self.detailStatic = detailStatic
        self.selectIndex = selectIndex
        self.previousIndex = selectIndex - 1
        self.nextIndex = selectIndex + 1
    }
}
extension ReadViewController {
    func loadData(with index: Int, isPrevious: Bool, needClear: Bool, finished:((_ finished: Bool) -> Void)? = nil) {
        guard let detailStatic = detailStatic else { return }
        if index <= -1 {
            
        } else if index >= detailStatic.chapter_list.count {
            
        } else {
            
        }
    }
}
extension ReadViewController {
     @objc func tapAction() { }
     @objc func doubleTapAction() { }
}
extension ReadViewController: UICollectionViewDelegate {
    
    
}
extension ReadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
    
}
