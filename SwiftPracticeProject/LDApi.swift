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
