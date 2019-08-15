//
//  LDTabBarController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDTabBarController: UITabBarController {
    
    let titleArr = ["首页","声音","视频","我的"]
    let imageArr = ["tab_home","tab_class","tab_book","tab_mine"]
    let selectedArr = ["tab_home_S","tab_class_S","tab_book_S","tab_mine_S"]
    let typeVCs = [HomeViewController.self,VoiceViewController.self,VideoViewController.self,MineViewController.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        
        setValue(LDTabBar(), forKeyPath: "tabBar")
        tabBar.isTranslucent = false
        
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
