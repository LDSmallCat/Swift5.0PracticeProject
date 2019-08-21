//
//  LDApi.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import Moya


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

let timeoutClosure = { (endpoint: Endpoint, closure: MoyaProvider<LDApi>.RequestResultClosure) -> Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 10
        closure(.success(urlRequest))
    } else {
    closure(.failure(MoyaError.requestMapping(endpoint.url)))

    }
}
let ApiProvider = MoyaProvider<LDApi>(requestClosure: timeoutClosure)
let ApiLodingProvider = MoyaProvider<LDApi>(requestClosure: timeoutClosure, plugins: [loadingPlugin])

enum LDApi {
    case recommendList(sexType: Int)
    case vipList
    case subscribeList
    case rankList
    case test
}

extension LDApi: TargetType {
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
