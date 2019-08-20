//
//  LDApi.swift
//  SwiftPracticeProject
//
//  Created by Mac on 2019/8/16.
//  Copyright © 2019 caolaidong. All rights reserved.
//

import UIKit

let ApiProvider = MoyaProvider<LDApi>()


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
