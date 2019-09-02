//
//  SpecialViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class SpecialViewController: LDBaseViewController {
    private var page = 0
    private var argCon = 0
    private var specialModel: MoreComicModel? {
        didSet {
            guard let mm = specialModel else { return }
          
            if mm.page == 1 { if !mm.comics.isEmpty { specialList = mm.comics }
            }else{
            if !mm.comics.isEmpty { specialList.append(contentsOf: mm.comics) } }
            
            if mm.hasMore { page += 1 } else {
            tableView.ldFooter.endRefreshingWithNoMoreData() }
        }
    }
    private var specialList = [ComicModel]() { didSet { tableView.reloadData() }}

    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.backgroundColor = UIColor.background
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.delegate = self
        tb.ldHeader = LDRefreshHeader{[weak self] in
                     self?.page = 0;self?.loadData() }
        tb.ldFooter = LDRefreshFooter{[weak self] in self?.loadData() }
        tb.rowHeight = 200
        tb.register(cellType: SpecialTableViewCell.self)
        return tb
    }()
    convenience init(argCon: Int = 0) {
        self.init()
        self.argCon = argCon
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func loadData() {
        UApiLodingProvider.ldRequest(UApi.special(argCon: argCon, page: page + 1), successClosure: { [weak self] (json) in
            self?.tableView.ldFooter.endRefreshing()
            self?.tableView.ldHeader.endRefreshing()
            guard let dict = json.dictionaryObject else { return }
            self?.specialModel = model(from: dict, MoreComicModel.self)
            
        }, abnormalClosure: nil, failureClosure: nil)
    }
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }

    

}


extension SpecialViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { specialList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SpecialTableViewCell.self)
        cell.model = specialList[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = specialList[indexPath.row]
        var html: String?
        if item.specialType == 1 {
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_v3.html"
        } else if item.specialType == 2{
            html = "http://www.u17.com/z/zt/appspecial/special_comic_list_new.html"
        }
        guard let host = html else { return }
        let path = "special_id=\(item.specialId)&is_comment=\(item.isComment)"
        let url = [host, path].joined(separator: "?")
        let vc = LDWebViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
