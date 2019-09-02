//
//  LDWebViewController.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/9/2.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import WebKit

class LDWebViewController: LDBaseViewController {
    var request: URLRequest!
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.allowsBackForwardNavigationGestures = true
        wv.uiDelegate = self
        wv.navigationDelegate = self
        return wv
    }()
    
    lazy var progressView: UIProgressView = {
        let pv = UIProgressView()
        pv.trackImage = UIImage(named: "nav_bg")
        pv.progressTintColor = UIColor.white
        return pv
    }()
    
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    
    override func configUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(2)
        }
    }

    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"), target: self, action: #selector(reload))
    }
    
    @objc func reload() {
        webView.reload()
    }
    
    override func pressBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
           navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension LDWebViewController: WKNavigationDelegate, WKUIDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
