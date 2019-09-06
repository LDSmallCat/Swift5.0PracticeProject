//
//  ReadCollectionViewCell.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/5.
//  Copyright © 2019 caolaidong. All rights reserved.
//

struct ImageModel: Convertible {
    var location = ""
    var image_id  = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    var total_tucao = 0
    var webp = 0
    var type = 0
    var img05 = ""
    var img50 = ""
}

class ReadCollectionViewCell: LDBaseCollectionViewCell {

    var model: ImageModel? {
        didSet {
            guard let ml = model else { return }
            imgView.image = nil
            imgView.kf.setImage(with: URL(string: ml.location), placeholder: UIImage(named: "yaofan"))
        }
    }
    
    
    lazy var imgView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()


    override func configUI() {
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
