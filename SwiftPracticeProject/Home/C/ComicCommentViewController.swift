//
//  ComicCommentViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

class ComicCommentViewController: UComicBaseViewController {
    var commentList: ComicCommentListModel = ComicCommentListModel() {
        didSet { tb.reloadData() }
    }
    
    lazy var tb: UITableView = {
            let tb = UITableView(frame: CGRect.zero, style: .plain)
            tb.delegate = self
            tb.dataSource = self
            tb.register(cellType: ComicCommentTableViewCell.self)
            return tb
        }()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    func loadData() {
        guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
        UApiLodingProvider.ldRequest(UApi.commentList(object_id: pvc.comicID, thread_id: pvc.threadID, page: commentList.serverNextPage), successClosure: { (json) in
            guard let dict = json.dictionaryObject else {return}
            self.commentList = model(from: dict, ComicCommentListModel.self)
            
        }, abnormalClosure: nil, failureClosure: nil)
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

extension ComicCommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { commentList.commentList.count }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicCommentTableViewCell.self)
        
        cell.cModel = commentList.commentList[indexPath.row]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return commentList.commentList[indexPath.row].cellHeight }
    
}
extension ComicCommentViewController: UITableViewDelegate{
func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        parent.slideDirection(down: scrollView.contentOffset.y < 0)
    }
}
