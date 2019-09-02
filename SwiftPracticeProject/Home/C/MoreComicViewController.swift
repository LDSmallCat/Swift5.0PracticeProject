//
//  MoreComicViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class MoreComicViewController: LDBaseViewController {
    private var argCon: Int = 0
    private var argName: String = ""
    private var argValue: Int = 0
    private var page: Int = 0
    private var moreModel: MoreComicModel? {
        didSet {
            guard let mm = moreModel else { return }
          
            if mm.page == 1 { if !mm.comics.isEmpty { comicList = mm.comics }
            }else{
            if !mm.comics.isEmpty { comicList.append(contentsOf: mm.comics) } }
            
            if mm.hasMore { page += 1 } else {
            tb.ldFooter.endRefreshingWithNoMoreData() }
        }
    }
    private var comicList = [ComicModel]() {
        didSet { tb.reloadData() }
    }

    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.backgroundColor = UIColor.background
        tb.dataSource = self
        tb.delegate = self
        tb.ldHeader = LDRefreshHeader{[weak self] in
             self?.page = 0;self?.loadData() }
        tb.ldFooter = LDRefreshFooter{ self.loadData() }
        tb.register(cellType: MoreComicTableViewCell.self)
        tb.rowHeight = 180
        return tb
    }()
    
    
    convenience init(argCon: Int = 0, argName: String, argValue: Int = 0) {
        self.init()
        
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func loadData() {
        UApiLodingProvider.ldRequest(UApi.comicList(argCon: argCon, argName: argName, argValue: argValue, page: page + 1), successClosure: { [weak self] (json) in
            self?.tb.ldFooter.endRefreshing()
            self?.tb.ldHeader.endRefreshing()
            guard let dict = json.dictionaryObject else { return }
            self?.moreModel = model(from: dict, MoreComicModel.self)
         }, abnormalClosure: nil, failureClosure: nil)
        
    }
    

}

extension MoreComicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { comicList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MoreComicTableViewCell.self)
        cell.spinnerName = "更新时间"
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titles = ["详情","目录","评论"]
        let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
        let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
        cv.comicID = comicList[indexPath.row].comicId
        cv.comicName = comicList[indexPath.row].name
        navigationController?.pushViewController(cv, animated: true)
    }
}
