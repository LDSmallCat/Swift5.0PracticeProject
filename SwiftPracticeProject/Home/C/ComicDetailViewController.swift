//
//  ComicDetailViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//



class ComicDetailViewController: LDBaseViewController {
    var descCellHeight: CGFloat = 150
    
    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.background
        tb.showsVerticalScrollIndicator = false
        tb.register(cellType: ComicDetailDescriptionCell.self)
        tb.estimatedRowHeight = 150
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    func loadData() {
  
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
            4
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicDetailDescriptionCell.self)
        let pv = self.parent?.parent as! UComicBaseViewController
        
        cell.descLabel.text = "\("【\(pv.comicModel.cate_id)】\(pv.comicModel.description)")"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            let pv = self.parent?.parent as! UComicBaseViewController
            let string = "\("【\(pv.comicModel.cate_id)】\(pv.comicModel.description)")"
            let height = 65 + string.getHeightFor(15, screenWidth - 30)
            
            return height
        default:
            return descCellHeight
        }
       
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        parent.slideDirection(down: scrollView.contentOffset.y < 0)
    }

}
