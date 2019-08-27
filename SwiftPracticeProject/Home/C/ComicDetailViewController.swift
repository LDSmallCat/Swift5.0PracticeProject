//
//  ComicDetailViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//



class ComicDetailViewController: UComicBaseViewController{
    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    func loadData() {

        UApiProvider.ldRequest(UApi.comicDetail(comicId: UComicBaseViewController.comicId), successClosure: { (json) in
                print(json)
            }, abnormalClosure: { (code, message) in
                print(code,message)
            }, failureClosure: nil)
        
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
}


extension ComicDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            100
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = String(indexPath.row)
        return cell
        
    }
}
