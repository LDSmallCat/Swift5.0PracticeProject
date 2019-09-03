//
//  SearchFooterView.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/3.
//  Copyright © 2019 caolaidong. All rights reserved.
//


class SearchCell: LDBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.gray
        return tl
    }()
    
    override func configUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
}




typealias SearchFooterDidSelectedIndexClosure = (_ index: Int) -> Void

class SearchFooterView: BaseTableViewHeaderFooterView {
    var didSelectIndexClosure: SearchFooterDidSelectedIndexClosure?
    
    var searchList: [SearchHotModel] = [] { didSet {
        
        collectionView.reloadData() } }
    
    private lazy var collectionView: UICollectionView = {
        let ly = UICollectionViewFlowLayout()
        ly.minimumLineSpacing = 10
        ly.minimumInteritemSpacing = 10
        ly.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: ly)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        
        cv.dataSource = self
        cv.register(cellType: SearchCell.self)
        return cv
    }()

    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension SearchFooterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { searchList.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchCell.self)
        cell.titleLabel.text = searchList[indexPath.row].name
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.backgroundColor = UIColor.random
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(searchList[indexPath.row].cellWidth)
        return CGSize(width: searchList[indexPath.row].cellWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let didSelectedClosure = didSelectIndexClosure else { return }
        didSelectedClosure(indexPath.row)
    }
}
