//
//  LDPageViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

public enum PageStyle{
    
    case none
    case navgationBar
    case topBar
    case topPaddingBar(CGFloat)
    
    static func == (lhs: PageStyle, rhs: PageStyle) -> Bool {
        switch (lhs , rhs) {
        case (.none, .none): return true
        case (.navgationBar, .navgationBar): return true
        case (.topBar, .topBar): return true
        case (.topPaddingBar(_), .topPaddingBar(_)): return true
        default: return false
        }
    }
}

class LDPageViewController: LDBaseViewController {
    var pageStyle: PageStyle!
    lazy var sc: UIScrollView = {
        let sc = UIScrollView(frame: CGRect.zero)
        sc.showsVerticalScrollIndicator = true
        sc.backgroundColor = UIColor.white
        sc.isScrollEnabled = false
        return sc
    }()
    lazy var contV: UIView = { UIView() }()
    lazy var pageVC: UIPageViewController = {
       UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    lazy var segment: HMSegmentedControl = {
        let segment = HMSegmentedControl()
        segment.addTarget(self, action: #selector(changeIndex(segment:)), for: .valueChanged)
        return segment
    }()
    private(set) var vcs: [UIViewController]!
    
    private(set) var titles: [String]!
    private var currentSelectedIndex: Int = 0
        
    convenience init(titles: [String] = [],vcs: [UIViewController] = [], pageStyle: PageStyle = .none) {
        self.init()
        self.titles = titles
        self.vcs = vcs
        self.pageStyle = pageStyle
    }
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    @objc func changeIndex(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        if currentSelectedIndex == index { return }
        
        let target: [UIViewController] = [vcs[index]]
        let direction: UIPageViewController.NavigationDirection = currentSelectedIndex > index ? .reverse : .forward
        pageVC.setViewControllers(target, direction: direction, animated: true) { [weak self] ( _ ) in
            self?.currentSelectedIndex = index
        }
        
    }
    override func configUI() {
        guard let vcs = vcs else { return }
        addChild(pageVC)
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)
        
        switch pageStyle {
        case .none:
            view.addSubview(pageVC.view)
            pageVC.view.snp.makeConstraints{ $0.edges.equalToSuperview() }
        case .navgationBar:
            view.addSubview(pageVC.view)
            configSegment()
            segment.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 120, height: 40)
            navigationItem.titleView = segment
            pageVC.view.snp.makeConstraints{ $0.edges.equalToSuperview() }
        case .topBar:
            view.addSubview(pageVC.view)
            configSegment()
            view.addSubview(segment)
            segment.snp.makeConstraints { $0.top.left.right.equalToSuperview()
                $0.height.equalTo(40)
            }
            pageVC.view.snp.makeConstraints {
                $0.top.equalTo(segment.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
        case let .topPaddingBar(topPadding):
            vcs.forEach { pageVC.addChild($0) }
            view.addSubview(sc)
            sc.snp.makeConstraints { $0.edges.equalToSuperview() }
            sc.addSubview(contV)
            contV.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
            }
            
            configSegment()
            contV.addSubview(segment)
            segment.snp.makeConstraints {
                $0.top.equalToSuperview().offset(topPadding)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(40)
            }
            contV.addSubview(pageVC.view)
            pageVC.view.snp.makeConstraints {
                $0.top.equalTo(segment.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(screenHeight - 2*navgationBarHeight - statusBarHeight)
            }
        default: break
        }
        guard let titles = titles else { return }
        segment.sectionTitles = titles
        currentSelectedIndex = 0
        segment.selectedSegmentIndex = currentSelectedIndex
    }
   
    func configSegment() {
        switch pageStyle {
        case .navgationBar:
            segment.backgroundColor = UIColor.clear
            segment.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
            ]
            segment.selectedTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
            ]
            segment.selectionIndicatorLocation = .none
        case .topBar:
            segment.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]
            segment.selectedTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(r: 127, g: 221, b: 146),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]
            segment.selectionIndicatorLocation = .down
            segment.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146)
            segment.selectionIndicatorHeight = 2
            segment.borderType = .bottom
            segment.borderColor = UIColor.lightGray
            segment.borderWidth = 0.5
        case .topPaddingBar:
            segment.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]
            segment.selectedTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(r: 127, g: 221, b: 146),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]
            segment.selectionIndicatorLocation = .down
            segment.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146)
            segment.selectionIndicatorHeight = 2
            segment.borderType = .bottom
            segment.borderColor = UIColor.lightGray
            segment.borderWidth = 0.5
        default: break
        }
    }

}

extension LDPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil }
        var beforeIndex = index - 1
        if beforeIndex == -1 { beforeIndex = vcs.count - 1 }
        //guard  beforeIndex >= 0 else { return nil }
        return vcs[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil }
        var afterIndex = index + 1
        if afterIndex == vcs.count {
            afterIndex = 0
        }
        //guard  afterIndex <= vcs.count - 1 else { return nil }
        return vcs[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
           print(pageViewController.viewControllers!)
        guard let viewController = pageViewController.viewControllers?.last,
              let index = vcs.firstIndex(of: viewController) else { return  }
        currentSelectedIndex = index
        segment.setSelectedSegmentIndex(UInt(index), animated: true)
        guard titles != nil && pageStyle == PageStyle.none else {return}
        navigationItem.title = titles[index]
        
    }
    
//    func setDeleagte<T>(_ viewController: T) {
//        switch T {
//        case let vc = T as? UComicBaseViewController:
//            print(vc)
//        default: break
//            
//        }
//    }
}

//enum ControllerType: UIViewController {
//    case UComicBaseViewController
//    case VIPViewController
//}
