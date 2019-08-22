//
//  UComicViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/22.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class UComicViewController: LDBaseViewController {
   private lazy var header: UIView = {
        let hr = UIView()
        hr.backgroundColor = UIColor.yellow
        return hr
    }()
    
    private lazy var contV: UIView = {
        let cv = UIView()
        return cv
    }()
    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
   private lazy var sc: UIScrollView = {
        let sc = UIScrollView(frame: CGRect.zero)
        sc.delegate = self
        sc.showsVerticalScrollIndicator = true
        sc.backgroundColor = UIColor.white
        return sc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "UComicViewController"
    }
    

    override func configUI() {
        
        view.addSubview(sc)
        sc.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sc.addSubview(contV)
        contV.backgroundColor = UIColor.red
        contV.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        
        tb.backgroundColor = UIColor.blue
        contV.addSubview(tb)
        tb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(screenHeight)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        contV.addSubview(header)
        header.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalTo(tb.snp.top)
        }
        
        
        
    }

    override func configNavigationBar() {
        super.configNavigationBar()
        guard let navi = navigationController as? LDNavigationViewController else { return }
            if navi.visibleViewController == self {
                navi.barStyle(.clear)
                    
        }
    }
}
extension UComicViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = String(indexPath.row)
        return cell
        
    }
}
extension UComicViewController: UIScrollViewDelegate,UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tb {
                  print(scrollView.contentOffset.y)
                 if scrollView.contentOffset.y > 0 {
                     (navigationController as! LDNavigationViewController).barStyle(.theme)
                 } else {
                     (navigationController as! LDNavigationViewController).barStyle(.clear)
                 }
          }
       
    }
}
