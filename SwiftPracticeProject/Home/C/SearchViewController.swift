//
//  SearchViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/3.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

let SearchHistoryKey = "searchHistoryKey"

class SearchViewController: LDBaseViewController {
    private var currentRequest: Cancellable?
    private var hotItems: [SearchHotModel] = [] {
        didSet { historyTableView.reloadData() }
    }
    private var relative: [SearchHotModel]?
    private var comics: [ComicModel]?

    private lazy var searchHistory: [String]! = {
        ["1","2","44"]
      //UserDefaults.standard.value(forKey: SearchHistoryKey) as? [String] ?? [String]()
    }()
    
    private lazy var searchBar: UITextField = {
        let sr = UITextField()
        sr.backgroundColor = UIColor.white
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = UIFont.systemFont(ofSize: 15)
        sr.placeholder = "输入漫画名称/作者"
        sr.layer.cornerRadius = 15
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        sr.delegate = self
        sr.leftViewMode = .always
        sr.clearsOnBeginEditing = true
        sr.clearButtonMode = .whileEditing
        sr.returnKeyType = .search
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: sr)
        return sr
    }()
   
    private lazy var historyTableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.register(headerFooterViewType: SearchHeaderView.self)
        tb.register(cellType: LDBaseTableViewCell.self)
        tb.register(headerFooterViewType: SearchFooterView.self)
        return tb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshHotRequest()
    }
    
    override func configUI() {
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
}
extension SearchViewController {
    private func refreshHotRequest() {
        historyTableView.isHidden = false
        UApiLodingProvider.ldRequest(UApi.searchHot, successClosure: { [weak self] (json) in
            guard let arr = json["hotItems"].arrayObject else { return }
            self?.hotItems = modelArray(from: arr, SearchHotModel.self)
            
        }, abnormalClosure: nil, failureClosure: nil)
    }
}
extension SearchViewController: UITextFieldDelegate {
    @objc func textFiledTextDidChange(noti: Notification) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            switch tableView {
                case historyTableView: return 2
                default: return 1
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
            case historyTableView:
                return section == 0 ? searchHistory.prefix(5).count : 0
            default: return 10
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
            case historyTableView:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LDBaseTableViewCell.self)
                cell.textLabel?.text = searchHistory[indexPath.row]
                cell.textLabel?.textColor = UIColor.gray
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.separatorInset = .zero
                return cell
            default: return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case historyTableView: return 44
        default: return 44
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView {
            case historyTableView: return section == 0 ? 10 : tableView.frame.height - 44
            default: return CGFloat.leastNormalMagnitude
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch tableView {
            case historyTableView where section == 1:
                let footer = tableView.dequeueReusableHeaderFooterView(SearchFooterView.self)
                footer?.searchList = hotItems
                footer?.didSelectIndexClosure = { [weak self] index in
                    self?.refreshHotRequest()
                }
                return footer
            default: return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch tableView {
            
            case historyTableView:
                
            let header = tableView.dequeueReusableHeaderFooterView(SearchHeaderView.self)
            header?.titleLabel.text = section == 0 ? "看看你都搜过什么" : "大家都在搜"
            header?.moreButton.setImage(section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh"), for: .normal)
            header?.moreButton.isHidden = section == 0 ? searchHistory.isEmpty : false
            header?.moreActionClosure { [weak self] in
                if section == 0 {
                    self?.searchHistory.removeAll()
                    self?.historyTableView.reloadData()
                    UserDefaults.standard.removeObject(forKey: SearchHistoryKey)
                } else {
                    self?.refreshHotRequest()
                }
                
            }
            return header
            
        default: return UIView()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case historyTableView:
            print(searchHistory[indexPath.row])
        default:
            print(indexPath)
        }
    }
}
