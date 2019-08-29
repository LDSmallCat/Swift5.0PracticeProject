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
    var comicID: Int!
    var dStaticModel: DetailStaticModel?
    var dRealtimeModel: ComicDetailModel?
    var textM: DetailStaticComicModel?
    
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
    
    func loadData() {
        guard let pvc = self.parent?.parent as? UComicBaseViewController else { return }
        comicID = pvc.comicID
        
        UApiProvider.ldRequest(UApi.detailStatic(comicId: comicID), successClosure: { (json) in
            print(json)
            guard let model = model(from: json.dictionaryObject, DetailStaticModel.self) else { return }
            self.dStaticModel = model
            if let pvc = self.parent?.parent as? UComicBaseViewController {
                pvc.header.bgView.kf.setImage(with: URL(string: (self.dStaticModel!.comic.cover)))
                pvc.header.coverView.kf.setImage(with: URL(string: (self.dStaticModel!.comic.cover)))
                pvc.header.titleLabel.text = self.dStaticModel?.comic.name
                pvc.header.authorLabel.text = self.dStaticModel?.comic.author.name
                pvc.header.tags = (self.dStaticModel!.comic.classifyTags.map { $0.name })
                pvc.header.tagView.reloadData()
            }
            
            self.tb.reloadData()
        }, abnormalClosure: nil, failureClosure: nil)
  
        UApiProvider.ldRequest(UApi.detailRealtime(comicId: comicID), successClosure: { (json) in
                print(json)
            guard let model = model(from: json["comic"].dictionaryObject, ComicDetailModel.self) else { return }
            self.dRealtimeModel = model
            self.setupTicketCellString()
            self.tb.reloadData()
        }, abnormalClosure: nil, failureClosure: nil)

        UApiProvider.ldRequest(UApi.guessLike, successClosure: { (json) in
            let arr = modelArray(from: json["comics"].arrayObject, ComicModel.self)
            if arr != nil { self.guesslike.append(contentsOf: arr!) }
            self.tb.reloadData()
        }, abnormalClosure: nil, failureClosure: nil)
    }
    
    
    func setupTicketCellString() {
       guard let m = self.dRealtimeModel else { return }
        let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ", attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                        ])
        text.append(NSAttributedString(string: m.total_ticket, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]))
        text.insert(NSAttributedString(string: m.monthly_ticket, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]), at: 6)
        ticketsCellString = text
        
        let headerText = NSMutableAttributedString(string: "点击 收藏")
        headerText.insert(NSAttributedString(string: " \(m.click_total) ",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]), at: 2)
        headerText.append(NSAttributedString(string: " \(m.favorite_total) ",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        if let pvc = self.parent?.parent as? UComicBaseViewController {
            pvc.header.clickCollectLabel.attributedText = headerText
        }
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
            if self.dStaticModel != nil {
                cell.descLabel.text = "\("【\(self.dStaticModel!.comic.cate_id)】\(self.dStaticModel!.comic.description)")"
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicOtherWorksCell.self)
            if self.dStaticModel != nil {
                cell.detailTextLabel?.text = "\(self.dStaticModel!.otherWorks.count)本"
            }
            
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
            if self.dStaticModel != nil {
            let string = "\("【\(self.dStaticModel!.comic.cate_id)】\(self.dStaticModel!.comic.description)")"
            let height = 65 + string.getHeightFor(15, screenWidth - 30)
            return height
            }else { return CGFloat.leastNonzeroMagnitude }
            
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
