//
//  HomeViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/15.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit


class HomeViewController: LDPageViewController {
        
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"), target: self, action: #selector(searchAction))
    }
    @objc private func searchAction() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}


extension HomeViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{

        return .darkContent
    }
}
