//
//  UComicBaseViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//


protocol ObserverScrollowDeleagte: NSObjectProtocol{
    
    func scrollowView(contentOffsetY: CGFloat)
}

class UComicBaseViewController: LDPageViewController {
    
    static var comicModel: ComicModel! {
        didSet {
            
        }
    }
    weak var osd: ObserverScrollowDeleagte?

    override func viewDidLoad() {
        super.viewDidLoad()
  
        pageVC.children.forEach {
            if let vc = $0 as? UComicBaseViewController
            { vc.osd = self } }
    }
    
     override func configNavigationBar() {
       super.configNavigationBar()
       guard let navi = navigationController as? LDNavigationViewController else { return }
           if navi.visibleViewController == self {
               navi.barStyle(.clear)
                   
       }
   }
}

extension UComicBaseViewController: ObserverScrollowDeleagte {
    
    
    var aniTime : TimeInterval { get { 0.35 } }

    func scrollowView(contentOffsetY: CGFloat) {
        
        if contentOffsetY > 0 {
         (navigationController as! LDNavigationViewController).barStyle(.theme)
            
            UIView.animate(withDuration: aniTime) {
                switch self.pageStyle {
                case .topPaddingBar(let padding):
                     self.sc.contentOffset = CGPoint(x: 0, y: padding - statusBarHeight -  navgationBarHeight)
                default: break
            }
                
            }
                    
         } else {
             (navigationController as! LDNavigationViewController).barStyle(.clear)
            UIView.animate(withDuration: aniTime) {
                self.sc.contentOffset = CGPoint.zero
            }
            
         }
    }
 
}

extension UComicBaseViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
            osd?.scrollowView(contentOffsetY: scrollView.contentOffset.y)

    }
}
