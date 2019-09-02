//
//  ComicCommentViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicCommentViewController: LDBaseViewController {
    var commentList: ComicCommentListModel? {
        didSet {
            guard let ct = commentList else {
                self.tb.ldFooter.endRefreshing(); return  }
            if ct.hasMore {
                self.tb.ldFooter.endRefreshing()
            } else { self.tb.ldFooter.endRefreshingWithNoMoreData() }
            cList.append(contentsOf: ct.commentList)
            tb.reloadData()
        }
    }
    
    var cList: [ComicCommentModel] = []
    
    lazy var tb: UITableView = {
            let tb = UITableView(frame: CGRect.zero, style: .grouped)
            tb.delegate = self
            tb.dataSource = self
            tb.register(cellType: ComicCommentTableViewCell.self)
            tb.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
            tb.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
            tb.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            tb.ldFooter = LDRefreshFooter{ self.loadData() }
            return tb
        }()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadData() {
        guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
        UApiLodingProvider.ldRequest(UApi.commentList(object_id: pvc.comicID, thread_id: pvc.threadID, page: commentList?.serverNextPage ?? 0), successClosure: { (json) in
            guard let dict = json.dictionaryObject else {return}
            self.commentList = model(from: dict, ComicCommentListModel.self)
            
        }, abnormalClosure: nil, failureClosure: nil)
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }

}

extension ComicCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cList.count }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicCommentTableViewCell.self)
        
        cell.cModel = cList[indexPath.row]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cList[indexPath.row].cellHeight }
    
}

extension ComicCommentViewController: UITableViewDelegate {
func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        parent.slideDirection(down: scrollView.contentOffset.y < 0)
    }
}
