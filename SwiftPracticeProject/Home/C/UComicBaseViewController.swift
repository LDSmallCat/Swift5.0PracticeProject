//
//  UComicBaseViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//


protocol ObserverTableViewSlide where Self: UIViewController {
    var navTitle: String { get }
    var height: CGFloat { get }
    var animateTime: TimeInterval { get }
    func slideDirection(down: Bool)
}
extension UComicBaseViewController: ObserverTableViewSlide {
    var navTitle: String { self.comicName }
    var animateTime: TimeInterval { 0.35 }
    var height: CGFloat {
        switch self.pageStyle {
        case let .topPaddingBar(height):
            return height
        default: return 0
        }
    }
    
}
extension ObserverTableViewSlide {
    func slideDirection(down: Bool) {
        let nav = self.navigationController as! LDNavigationViewController
        
        if nav.cBarStyle == .clear , down == true {  return }
        if nav.cBarStyle == .theme , down == false {  return }
        
        let barStyle: NavigationBarStyle = down ? .clear : .theme
        let y = down ? 0 : statusBarHeight + navgationBarHeight - self.height
        let rect = CGRect(x: 0, y: y, width: screenWidth, height: screenHeight + self.height - statusBarHeight - navgationBarHeight)
        UIView.animate(withDuration: animateTime, animations: {
             self.title = ""
             self.view.frame = rect
            nav.barStyle(barStyle)
        }) { (_) in
            if down { self.view.frame.size.height = screenHeight; }else{
                self.title = self.navTitle
            } } }
    
}



class UComicBaseViewController: LDPageViewController {
    lazy var header: ComicDetaileHeaderView = {
       let hr = ComicDetaileHeaderView()
        hr.backgroundColor = UIColor.blue
        return hr
    }()
   
    
    
    var comicID = 0
    var threadID = 0
    var comicName = ""
    var chapterList: [ChapterModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
     override func configNavigationBar() {
       super.configNavigationBar()
       guard let navi = navigationController as? LDNavigationViewController else { return }
           if navi.visibleViewController == self {
               navi.barStyle(.clear)
                   
       }
   }
    
    override func configUI() {
        super.configUI()
        
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(segment.snp.top)
        }
    }
}



