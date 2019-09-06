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
    private var chapterList = [ImageModel]()
    private var detailStatic: DetailStaticModel? {
        didSet {
            guard let dm = detailStatic else { return }
            topBar.titleLabel.text = dm.comic.name
        }
    }
    lazy var topBar: ReadTopBar = {
        let tb = ReadTopBar()
        tb.backgroundColor = UIColor.white
        tb.backButton.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
        return tb
    }()
    
    lazy var bottomBar: ReadBottomBar = {
        let bb = ReadBottomBar()
        bb.backgroundColor = UIColor.white
        bb.diviceDirectionButton.addTarget(self, action: #selector(changeDeviceDirection(_:)), for: .touchUpInside)
        bb.chapterButton.addTarget(self, action: #selector(changeChapter(_:)), for: .touchUpInside)
        return bb
    }()
    var edgesInset: UIEdgeInsets {
        if #available(iOS 11.0, *) { return view.safeAreaInsets
        } else { return .zero } }
    
    private var isBarHidden: Bool = false {
        didSet {
            self.topBar.snp.updateConstraints {
            $0.top.equalTo(self.backScrollView).offset(self.isBarHidden ? -(self.edgesInset.top + navgationBarHeight) : 0)
            }
                            
            self.bottomBar.snp.updateConstraints {
            $0.bottom.equalTo(self.backScrollView).offset(self.isBarHidden ? (self.edgesInset.bottom + 120) : 0)
            }
            UIView.animate(withDuration: 0.5) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    lazy var backScrollView: UIScrollView = {
        let bw = UIScrollView()
        bw.delegate = self
        bw.minimumZoomScale = 1.0
        bw.maximumZoomScale = 1.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        bw.addGestureRecognizer(tap)
        
//        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
//        doubleTap.numberOfTapsRequired = 2
//        bw.addGestureRecognizer(doubleTap)
//        tap.require(toFail: doubleTap)
        return bw
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.sectionInset = .zero
        lt.minimumLineSpacing = CGFloat.leastNormalMagnitude
        lt.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cv.backgroundColor = UIColor.background
        cv.delegate = self
        cv.dataSource = self
        cv.ldHeader = LDRefreshAutoHeader {[weak self] in
            self?.loadData(with: self?.previousIndex ?? 0, isPrevious: true, needClear: false, finished: { [weak self] (finish) in
                self?.previousIndex = self?.previousIndex ?? 0 - 1
            })
            
        }
        cv.ldFooter = LDRefreshAutoFooter {[weak self] in
            
            self?.loadData(with: self?.nextIndex ?? 0, isPrevious: false, needClear: false, finished: { [weak self] (finish) in
                self?.nextIndex =  self?.nextIndex ?? 0 + 1
            })
                    
        }
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
    
    override func configUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(backScrollView)
        }
        
        view.addSubview(topBar)
        topBar.snp.makeConstraints {
            $0.top.left.right.equalTo(backScrollView)
            $0.height.equalTo(navgationBarHeight)
        }
        
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalTo(backScrollView)
            $0.height.equalTo(120)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(with: selectIndex, isPrevious: false, needClear: false)
    }
    
}
extension ReadViewController {
    func loadData(with index: Int, isPrevious: Bool, needClear: Bool, finished:((_ finished: Bool) -> Void)? = nil) {
        guard let detailStatic = detailStatic else { return }
        topBar.titleLabel.text = detailStatic.comic.name
        if index <= -1 {
            collectionView.ldHeader.endRefreshing()
            
        } else if index >= detailStatic.chapter_list.count {
            collectionView.ldFooter.endRefreshingWithNoMoreData()
        } else {
            
            let chapterId = detailStatic.chapter_list[index].chapter_id
            UApiProvider.ldRequest(UApi.chapter(chapter_id: chapterId), successClosure: {[weak self] (json) in
                
                self?.collectionView.ldHeader.endRefreshing()
                self?.collectionView.ldFooter.endRefreshing()
                guard let arr = json["image_list"].arrayObject else { return }
                let modelArr = modelArray(from: arr, ImageModel.self)
                
                if needClear { self?.chapterList.removeAll() }
                if isPrevious {
                    self?.chapterList.insert(contentsOf: modelArr, at: 0)
                }else {
                    self?.chapterList.append(contentsOf: modelArr)
                }
                self?.collectionView.reloadData()
                guard let finished = finished else { return }
                finished(true)
                
            }, abnormalClosure: nil, failureClosure: nil)
        }
    }
}
extension ReadViewController {
     @objc func tapAction() { isBarHidden = !isBarHidden }
     @objc func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2, y: backScrollView.center.y - height / 2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
     
    }
     @objc func changeDeviceDirection (_ button: UIButton) {
        print("changeDeviceDirection")
     }
     @objc func changeChapter (_ button: UIButton) {
        print("changeChapter")
    }
    
}
extension ReadViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isBarHidden == false { isBarHidden = true }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        scrollView == backScrollView ? collectionView : nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == backScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width * scrollView.zoomScale, height: scrollView.frame.height * scrollView.zoomScale)
            print(scrollView.zoomScale)
            print(scrollView.contentSize)
        }
    }
}
extension ReadViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { chapterList.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ReadCollectionViewCell.self)
        cell.model = chapterList[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageModel = chapterList[indexPath.row] 
        let width = backScrollView.frame.width
        let height = width / imageModel.width * imageModel.height
        return CGSize(width: width, height: height)
    }
    
    
}
