//
//  ComicDetailViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/23.
//  Copyright © 2019 caolaidong. All rights reserved.
//



class ComicDetailViewController: LDBaseViewController {
    var ticketsCellString = NSMutableAttributedString()
    var guesslike = [ComicModel](){ didSet { tb.reloadData() } }
    var comicModel: ComicModel!
    
    lazy var tb: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.background
        tb.showsVerticalScrollIndicator = false
        tb.register(cellType: ComicDetailDescriptionCell.self)
        tb.register(cellType: ComicOtherWorksCell.self)
        tb.register(cellType: ComicTicketsWorksCell.self)
        tb.register(cellType: ComicGuessLikeCell.self)
        tb.estimatedRowHeight = 150
        tb.separatorStyle = .none
        tb.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tb.sectionFooterHeight = 10
        tb.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    /*
     SwiftPracticeProject.UComicBaseViewController: 0x7ff77f02fe00>
     
     */
    func loadData() {
        guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
        comicModel = pvc.comicModel
        
        //头部数据
        UApiProvider.ldRequest(UApi.detailRealtime(comicId: comicModel.comicId), successClosure: { (json) in
        let text = NSMutableAttributedString(string: "点击 收藏")
        let clickString = NSAttributedString(string: " \(json["comic"]["click_total"].stringValue)", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
                                    ])
        let favoriteString = NSAttributedString(string: " \(json["comic"]["favorite_total"].stringValue)", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
                                                ])
        text.insert(clickString, at: 2)
        text.append(favoriteString)
        pvc.header.clickCollectLabel.attributedText = text
        pvc.header.bgView.kf.setImage(with: URL(string: self.comicModel.cover))
        pvc.header.coverView.kf.setImage(with: URL(string: self.comicModel.cover))
        pvc.header.titleLabel.text = self.comicModel.name
        pvc.header.authorLabel.text = self.comicModel.author_name
        pvc.header.tags = self.comicModel.tags
        pvc.header.tagView.reloadData()
        }, abnormalClosure: nil, failureClosure: nil)
        
        UApiProvider.ldRequest(UApi.detailStatic(comicId: comicModel.comicId), successClosure: { [weak self] (json) in

            self?.comicModel.otherWorkCount = JSON(json["otherWorks"].arrayValue).count
            self?.comicModel.cate_id = JSON(json["comic"]["cate_id"]).stringValue
            self?.tb.reloadData()
        }, abnormalClosure: nil, failureClosure: nil)

        UApiProvider.ldRequest(UApi.detailRealtime(comicId: comicModel.comicId), successClosure: { (json) in
            self.setupTicketCellString(json)
        }, abnormalClosure: nil, failureClosure: nil)

        UApiProvider.ldRequest(UApi.guessLike, successClosure: { (json) in
            let arr = modelArray(from: json["comics"].arrayObject, ComicModel.self)
            if arr != nil { self.guesslike.append(contentsOf: arr!) }
        }, abnormalClosure: nil, failureClosure: nil)
    }
    
   
    func setupTicketCellString(_ json: JSON) {
        let monthTicket = JSON(json["comic"]["monthly_ticket"]).stringValue
        let totalMonthTicket = JSON(json["comic"]["total_ticket"]).stringValue
        
        let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ", attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                        ])
        text.append(NSAttributedString(string: totalMonthTicket, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]))
        text.insert(NSAttributedString(string: monthTicket, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]), at: 6)
        ticketsCellString = text
        tb.reloadData()
    }
    override func configUI() {
        view.addSubview(tb)
        tb.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    
}


extension ComicDetailViewController: UITableViewDataSource ,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int { 4 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicDetailDescriptionCell.self)
            cell.descLabel.text = "\("【\(comicModel.cate_id)】\(comicModel.description)")"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicOtherWorksCell.self)
            cell.detailTextLabel?.text = "\(comicModel.otherWorkCount)本"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicTicketsWorksCell.self)
            
            cell.textLabel?.attributedText = ticketsCellString
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicGuessLikeCell.self)
            cell.guessMolde = guesslike
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let string = "\("【\(comicModel.cate_id)】\(comicModel.description)")"
            let height = 65 + string.getHeightFor(15, screenWidth - 30)
            
            return height
        case 2: return ticketsCellString.length > 0 ? 44 : CGFloat.leastNonzeroMagnitude
        case 1: return 44
        default: return 200
            
        }

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let parent = self.parent?.parent as? UComicBaseViewController else { return }
        parent.slideDirection(down: scrollView.contentOffset.y < 0)
    }

}
