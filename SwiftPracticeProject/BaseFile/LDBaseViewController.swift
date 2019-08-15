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

       view.backgroundColor = UIColor.white
    }
    
    func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
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
