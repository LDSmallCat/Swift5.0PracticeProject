//
//  LDRefresh.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

extension UIScrollView {
    var ldHeader: MJRefreshHeader {
        get { mj_header }
        set { mj_header = newValue }
    }
    var ldFooter: MJRefreshFooter {
        get { mj_footer }
        set { mj_footer = newValue }
    }
  
}

class LDRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                           UIImage(named: "refresh_loading_2")!,
                           UIImage(named: "refresh_loading_3")!], for: .refreshing)
        lastUpdatedTimeLabel.isHidden = true
        stateLabel.isHidden = true
    }
}

class LDRefreshAutoHeader: MJRefreshHeader {}
class LDRefreshFooter: MJRefreshBackNormalFooter {}
class LDRefreshAutoFooter: MJRefreshAutoFooter {}

class LDrefreshDiscoverFooter: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.background
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel.isHidden = true
        refreshingBlock = { self.endRefreshing() }
    }
}




















