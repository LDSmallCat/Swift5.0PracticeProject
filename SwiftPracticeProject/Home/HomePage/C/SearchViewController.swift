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
        didSet { historyTableView.reloadData() } }
    private var relative: [SearchHotModel] = [] {
        didSet { searchTableView.reloadData() }
    }
    private var comicModel: MoreComicModel? {
        didSet {
            guard comicModel != nil else { return }
            resultTableView.reloadData()
        }
    }

    private lazy var searchHistory: [String]! = {
      UserDefaults.standard.value(forKey: SearchHistoryKey) as? [String] ?? [String]()
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private lazy var historyTableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.delegate = self
        tb.dataSource = self
        tb.register(headerFooterViewType: SearchHeaderView.self)
        tb.register(cellType: LDBaseTableViewCell.self)
        tb.register(headerFooterViewType: SearchFooterView.self)
        return tb
    }()
    
    private lazy var searchTableView: UITableView = {
        let sw = UITableView(frame: CGRect.zero, style: .grouped)
        sw.delegate = self
        sw.dataSource = self
        sw.register(headerFooterViewType: SearchHeaderView.self)
        sw.register(cellType: LDBaseTableViewCell.self)
        return sw
    }()
    
    private lazy var resultTableView: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .grouped)
        rw.delegate = self
        rw.dataSource = self
        rw.register(cellType: MoreComicTableViewCell.self)
        return rw
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
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", target: self, action: #selector(cancelAction))
    }
    
    @objc private func cancelAction() {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}
extension SearchViewController {
    private func refreshHotRequest() {
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        UApiLodingProvider.ldRequest(UApi.searchHot, successClosure: { [weak self] (json) in
            guard let arr = json["hotItems"].arrayObject else { return }
            self?.hotItems = modelArray(from: arr, SearchHotModel.self)
            
        }, abnormalClosure: nil, failureClosure: nil)
    }
    
    private func searchRelative(_ text: String) {
            historyTableView.isHidden = !text.isEmpty
            searchTableView.isHidden = text.isEmpty
            resultTableView.isHidden = true
            if text.isEmpty { return }
            currentRequest?.cancel()
        currentRequest = (UApiProvider.ldRequest(UApi.searchRelative(inputText: text), successClosure: { [weak self] (json) in
                guard let arr = json.arrayObject else { return }
                self?.relative = modelArray(from: arr, SearchHotModel.self)
            }, abnormalClosure: nil, failureClosure: nil)) as? Cancellable
   
    }
    private func searchResult(_ text: String) {
            historyTableView.isHidden = !text.isEmpty
            searchTableView.isHidden = true
            resultTableView.isHidden = text.isEmpty
            if text.isEmpty { return }
            searchBar.text = text
        UApiProvider.ldRequest(UApi.searchResult(argCon: 2, q: text), successClosure: { [weak self] (json) in
            
            guard let dict = json.dictionaryObject else { return }
            self?.comicModel = model(from: dict, MoreComicModel.self)
        }, abnormalClosure: nil, failureClosure: nil)
        let defaults = UserDefaults.standard
        var history = defaults.value(forKey: SearchHistoryKey) as? [String] ?? [String]()
        history.removeAll { $0 == text }
        history.insert(text, at: 0)
        searchHistory = history
        historyTableView.reloadData()
        defaults.set(searchHistory, forKey: SearchHistoryKey)
    }
}
extension SearchViewController: UITextFieldDelegate {
    @objc func textFiledTextDidChange(noti: Notification) {
        guard let textFiled = noti.object as? UITextField,
            let text = textFiled.text  else { return }
        searchRelative(text)
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
            case searchTableView: return relative.count
            default: return comicModel?.comics.count ?? 0
            
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
            case searchTableView:
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LDBaseTableViewCell.self)
                cell.textLabel?.text = relative[indexPath.row].name
                cell.textLabel?.textColor = UIColor.gray
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.separatorInset = .zero
                return cell
            case resultTableView:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MoreComicTableViewCell.self)
            cell.spinnerName = "总点击 "
            cell.model = comicModel?.comics[indexPath.row]
            return cell
            default: return UITableViewCell()
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == resultTableView ? 180 : navgationBarHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case historyTableView: return navgationBarHeight
        case searchTableView: return relative.isEmpty ? CGFloat.leastNormalMagnitude : navgationBarHeight
        default: return CGFloat.leastNormalMagnitude
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView {
            case historyTableView: return section == 0 ? 10 : tableView.frame.height - navgationBarHeight
            case searchTableView: return navgationBarHeight
            default: return CGFloat.leastNormalMagnitude
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch tableView {
            case historyTableView where section == 1:
                let footer = tableView.dequeueReusableHeaderFooterView(SearchFooterView.self)
                footer?.searchList = hotItems
                footer?.didSelectIndexClosure = { [weak self] index in
                let titles = ["详情","目录","评论"]
                let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
                let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
                    cv.comicID = self?.hotItems[index].comic_id ?? 0
                    cv.comicName = self?.hotItems[index].name ?? ""
                self?.navigationController?.pushViewController(cv, animated: true)
                    
                    
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
            case searchTableView:
            let header = tableView.dequeueReusableHeaderFooterView(SearchHeaderView.self)
            header?.titleLabel.text = "找到相关的漫画 \(relative.count) 本"
            header?.moreButton.isHidden = true
            return header
        default: return nil
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case historyTableView:
            searchResult(searchHistory[indexPath.row])
        case searchTableView:
            searchResult(relative[indexPath.row].name)
        default:
            guard let model = comicModel?.comics[indexPath.row] else { return }
            let titles = ["详情","目录","评论"]
            let vcs = [ComicDetailViewController(),ComicCatalogViewController(),ComicCommentViewController()]
            let cv = UComicBaseViewController(titles: titles, vcs: vcs, pageStyle: .topPaddingBar(240))
            cv.comicID = model.comicId
            cv.comicName = model.name
            navigationController?.pushViewController(cv, animated: true)
            
        }
    }
}
