//
//  LDTabBarController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDTabBarController: UITabBarController {
    
    let titleArr = ["声音","视频","我的"]
    let imageArr = ["tab_class","tab_book","tab_mine"]
    let selectedArr = ["tab_class_S","tab_book_S","tab_mine_S"]
    let typeVCs = [VoiceViewController.self,VideoViewController.self,MineViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setValue(LDTabBar(), forKeyPath: "tabBar")
        tabBar.isTranslucent = false
        
        addHomeVc()
        adddOtherVc()
        //self.selectedIndex = 1
    }
    func addHomeVc() {
        let titles = ["推荐","VIP","订阅","排行"]
        let vcs = [RecommendViewController(),VIPViewController(),SubscribeViewController(),RankViewController()]
        
        let nav = LDNavigationViewController(rootViewController: HomeViewController(titles: titles, vcs: vcs, pageStyle: .navgationBar))
        nav.tabBarItem.image = UIImage(named: "tab_home")
        nav.tabBarItem.selectedImage = UIImage(named: "tab_home_S")
        nav.tabBarItem.setTitleTextAttributes([
           NSAttributedString.Key.foregroundColor: UIColor.black
       ], for: .selected)
        addChild(nav)
                    
    }
    func adddOtherVc() {
        for index in 0..<titleArr.count {
            let title = titleArr[index]
            let image = imageArr[index]
            let selectedImage = selectedArr[index]
            let vc = typeVCs[index]
            addChild(title, image, selectedImage, vc)
                    
        }
    }
    
    func addChild(_ title: String, _ image: String, _ selectedImage: String, _ type: UIViewController.Type) {
        
           let child = LDNavigationViewController(rootViewController: type.init())
        
           //child.title = title
           child.tabBarItem.image = UIImage(named: image)
           child.tabBarItem.selectedImage = UIImage(named: selectedImage)
           child.tabBarItem.setTitleTextAttributes([
               NSAttributedString.Key.foregroundColor: UIColor.black
           ], for: .selected)
           addChild(child)
       }
    

}
extension LDTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}
