//
//  RankViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class RankViewController: LDBaseViewController {
    private var rankList = [RankModel]()
    private lazy var te: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.rowHeight = screenWidth * 0.4
        tb.separatorStyle = .none
        tb.dataSource = self
        tb.tableFooterView = UIView()
        tb.register(cellType: RankCell.self)
        tb.ldHeader = LDRefreshHeader(refreshingBlock: { [weak self] in self?.loadData()  })
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configUI() {
        view.addSubview(te)
        te.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges) }
    }
    override func loadData() {
        UApiLodingProvider.ldRequest(UApi.rankList, successClosure: { (json) in
            guard let arr = json["rankinglist"].arrayObject else {return}
            let rk = modelArray(from: arr, RankModel.self)
            self.rankList.append(contentsOf: rk)
            self.te.reloadData()
            self.te.ldHeader.endRefreshing()
        }, abnormalClosure: nil, failureClosure: nil)
    }
}
extension RankViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rankList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RankCell.self)
        cell.model = rankList[indexPath.row]
        return cell
        
    }
}
