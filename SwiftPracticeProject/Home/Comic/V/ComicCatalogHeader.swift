//
//  ComicCatalogHeader.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/5.
//  Copyright © 2019 caolaidong. All rights reserved.
//

typealias ComicCatalogSortClosure = (_ button: UIButton) -> Void

class ComicCatalogHeader: LDBaseCollectionReusableView {
    
    var model: DetailStaticModel?  {
        didSet {
            guard let model = model else { return }
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            catalogLabel.text = "目录 \(format.string(from: Date(timeIntervalSince1970: model.comic.last_update_time))) 更新 \(model.chapter_list.last?.name ?? "")"
            
        }
    }
    
    
    var sortClosure: ComicCatalogSortClosure?
    private lazy var catalogLabel: UILabel = {
        let le = UILabel()
        le.textColor = UIColor.gray
        le.font = UIFont.systemFont(ofSize: 13)
        return le
    }()
    
    private lazy var sortButton: UIButton = {
        let sb = UIButton(type: .custom)
        sb.setTitle("倒序", for: .normal)
        sb.setTitleColor(UIColor.gray, for: .normal)
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sb.addTarget(self, action: #selector(sortAction(for:)), for: .touchUpInside)
        return sb
    }()
    
    @objc private func sortAction(for button: UIButton) {
        guard let sortClosure = sortClosure else { return }
        sortClosure(button)
    }
    
    override func configUI() {
        
        addSubview(sortButton)
        sortButton.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalTo(navgationBarHeight)
        }
        
        addSubview(catalogLabel)
        catalogLabel.snp.makeConstraints {
            $0.left.equalTo(10)
            $0.top.bottom.equalToSuperview()
            $0.right.equalTo(sortButton.snp.left).offset(-10)
        }
    }
}
