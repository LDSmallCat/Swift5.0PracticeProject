//
//  EmptyView.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/3.
//  Copyright © 2019 caolaidong. All rights reserved.
//

extension UIScrollView {
    
    private struct AssociatedKeys {
        static var uemptyKey: Void?
    }
    
    var empty: EmptyView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.uemptyKey) as? EmptyView
        }
        set {
            self.emptyDataSetDelegate = newValue
            self.emptyDataSetSource = newValue
           objc_setAssociatedObject(self, &AssociatedKeys.uemptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


class EmptyView: EmptyDataSetSource, EmptyDataSetDelegate {
    
    var image: UIImage?
    var title: String?

    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = image
        return img
    }()
    
    private lazy var emptyV: UIView = {
        let ev = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 400))
        return ev
    }()
    private lazy var titlelabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 15)
        tl.textColor = UIColor.gray
        tl.text = title
        return tl
    }()
    var imageSize: CGSize {
        get {
            
            return image?.size ?? CGSize.zero
        }
    }
    
    var allowShow: Bool = false
    var verticalOffset: CGFloat = 0
    
    
    private var tapClosure: (() -> Void)?
    
    init(image: UIImage? = UIImage(named: "nodata"), verticalOffset: CGFloat = -80,title: String = "点我重试~~" , tapClosure: (() -> Void)?) {
        self.image = image
        self.verticalOffset = verticalOffset
        self.tapClosure = tapClosure
        self.title = title
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? { image }
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        emptyV.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo(imageSize.width)
            $0.height.equalTo(imageSize.height)
        }
        emptyV.addSubview(titlelabel)
        titlelabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        return emptyV
        
    }
     func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
     func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else { return }
        tapClosure()
    }
}
