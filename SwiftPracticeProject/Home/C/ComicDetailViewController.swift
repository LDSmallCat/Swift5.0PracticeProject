//
//  ComicDetailViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//



class ComicDetailViewController: LDBaseViewController {
    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.background
        tb.showsVerticalScrollIndicator = false
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    func loadData() {

        UApiProvider.ldRequest(UApi.comicDetail(comicId: UComicBaseViewController.comicModel.comicId), successClosure: { (json) in
                //print(json)
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


extension ComicDetailViewController: UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            100
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = String(indexPath.row)
        return cell
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        //print(parent.segment.frame)
        //print(scrollView.contentOffset.y)
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print(scrollView.contentOffset.y)
        guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        parent.slideDirection(down: scrollView.contentOffset.y < 0)
    }

}
