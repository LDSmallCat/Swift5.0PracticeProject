//
//  LDApi.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//


let loadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = topVC else { return }
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)

    }
}

let utimeoutClosure = { (endpoint: Endpoint, closure: MoyaProvider<UApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 10
        closure(.success(urlRequest))
    } else {
    closure(.failure(MoyaError.requestMapping(endpoint.url)))

    }
}
let UApiProvider = MoyaProvider<UApi>(requestClosure: utimeoutClosure)
let UApiLodingProvider = MoyaProvider<UApi>(requestClosure: utimeoutClosure, plugins: [loadingPlugin])


enum HApi {
    case likemomentsad(lastid: String)
    
}
   
extension HApi: TargetType {
    var baseURL: URL { URL(string: "")! }
    
    var path: String {
        switch self {
        case .likemomentsad: return "http://soa-matchbox.huochaihe.net/v1/thread/likemomentsad"
        
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    var task: Task {
        var parmeters: [String: Any] = [:]
        parmeters["source"] = "APP"
        parmeters["uid"] = "978048"
        parmeters["register_id"] = ""
        parmeters["platform"] = "IOS"
        parmeters["udid"] = "cf17589255f1e5dde7ac4987db0468bd14b2d510"
        parmeters["user_id"] = "978048"
        parmeters["version"] = "4.10.9"
        parmeters["token_key"] = "OTc4MDQ4LOabueadpeS4nENjLCw2ZGFmMzszYWUyMDlhYWM0ZWM1MDg2NTUyZjNiZDA2ZDExMjc1Mw=="
        switch self {
        case .likemomentsad(let lastid):
             parmeters["lastid"] = lastid
             
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var sampleData: Data { return "".data(using: .utf8)! }

    var headers: [String : String]? { return nil }
    //var headers: [String : String]? { return ["Content-type" : "application/json"] }


}


enum UApi {
    case recommendList(sexType: Int)
    case vipList
    case subscribeList
    case rankList
    case test
}

extension UApi: TargetType {
    var baseURL: URL { URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")! }
    
    var path: String {
        switch self {
        case .recommendList: return "comic/boutiqueListNew"
        case .vipList: return "list/vipList"
        case .subscribeList: return "list/newSubscribeList"
        case .rankList: return "rank/list"
        case .test: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .test: return .post
        default: return .get
        }
    }
    var task: Task {
        var parmeters: [String: Any] = [:]
        switch self {
        case .recommendList(let sexType):
            parmeters["sexType"] = sexType
        case .vipList: break 
        case .subscribeList: break
        case .rankList: break
        case .test: break
        }
        
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var sampleData: Data { return "".data(using: .utf8)! }

    var headers: [String : String]? { return nil }
    //var headers: [String : String]? { return ["Content-type" : "application/json"] }


}


extension MoyaProvider {
    
    func ldRequest(_ target: Target, successClosure: ((_ returnData: JSON) -> Void)?,abnormalClosure:((_ code: Int, _ message: String) -> Void)?, failureClosure: ((_ failureString: String) -> Void)?)
        -> Void {
            
            request(target) { (result) in
                switch result {
                    case let .success(response):
                        let jsonData = JSON(response.data)["data"]
                        let code = jsonData["stateCode"].int!
                        
                        let msg = jsonData["message"].string!
                        
                        if code == 1 {
                            guard let se = successClosure else { return }
                            se(jsonData["returnData"])
                        }else{
                            
                            guard let ae = abnormalClosure else { return }
                            ae(code,msg)
                        }
                    
                    case let .failure(error):
                    guard let fe = failureClosure else { return }
                        fe(error.errorDescription ?? "网络错误")
                    }
            }
            
    }
}
