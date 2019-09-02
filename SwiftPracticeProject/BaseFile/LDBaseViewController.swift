//
//  LDBaseViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class LDBaseViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configNavigationBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configUI()
        loadData()
    }
    func loadData() { }
    func configUI() { }
    deinit {
            print("\(self) deinit")
    }
    func configNavigationBar() {
        guard let navi = navigationController as? LDNavigationViewController else { return }
        if navi.visibleViewController == self {
            navi.barStyle(.theme)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"), target: self, action: #selector(self.pressBack))
            }
        }
        
           
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
   }
}

extension LDBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{

        return .lightContent
    }
}
