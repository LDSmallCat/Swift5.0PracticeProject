//
//  UApi.swift
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
    case detailRealtime(comicId: Int)
    case detailStatic(comicId: Int)
    case guessLike
    case commentList(object_id: Int, thread_id: Int, page: Int)
    case comicList(argCon: Int, argName: String, argValue: Int, page: Int)
    case special(argCon: Int, page: Int)
    case searchHot
    case searchRelative(inputText: String)
    case searchResult(argCon: Int, q: String)
}

extension UApi: TargetType {
    var baseURL: URL { URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")! }
    var path: String {
        switch self {
        case .recommendList: return "comic/boutiqueListNew"
        case .vipList: return "list/vipList"
        case .subscribeList: return "list/newSubscribeList"
        case .rankList: return "rank/list"
        case .detailRealtime: return "comic/detail_realtime"
        case .detailStatic: return "comic/detail_static_new"
        case .guessLike: return "comic/guessLike"
        case .commentList: return "comment/list"
        case .comicList: return "list/commonComicList"
        case .special: return "comic/special"
        case .searchHot: return "search/hotkeywordsnew"
        case .searchRelative: return "search/relative"
        case .searchResult: return "search/searchResult"
        }
    }
    
    var method: Moya.Method {
        switch self {
            default: return .get
        }
    }
    var task: Task {
        var parmeters: [String: Any] = [:]
        switch self {
        case .recommendList(let sexType):
            parmeters["sexType"] = sexType
        case .detailRealtime(let comicId):
            parmeters["comicid"] = comicId
        case .detailStatic(let comicId):
            parmeters["comicid"] = comicId
        case let .commentList(object_id, thread_id, page):
            parmeters["object_id"] = object_id
            parmeters["thread_id"] = thread_id
            parmeters["page"] = page
        case let .comicList(argCon, argName, argValue, page):
            parmeters["argCon"] = argCon
            parmeters["argName"] = argName
            parmeters["argValue"] = argValue
            parmeters["page"] = max(1, page)
        case let .special(argCon,page):
            parmeters["argCon"] = argCon
            parmeters["page"] = max(1, page)
        case let .searchRelative(inputText):
            parmeters["inputText"] = inputText
        case let .searchResult(argCon, q):
            parmeters["argCon"] = argCon
            parmeters["q"] = q
        default: break
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
                let outJsonData = JSON(response.data)
                let outCode = outJsonData["code"]
                if outCode.intValue == 1 {
                    let jsonData = outJsonData["data"]
                    let code = jsonData["stateCode"].intValue
                    let msg = jsonData["message"].stringValue
                    if code == 1 {
                        guard let se = successClosure else { return }
                        let data = jsonData["returnData"];se(data)
                    } else {
                        guard let ae = abnormalClosure else { return }
                        ae(code,msg)
                    }
                }else{
                    print("msg = " + outJsonData["msg"].stringValue)
                    print("code = " + outCode.stringValue)
                    guard let ae = abnormalClosure else { return }
                    ae(outCode.intValue,outJsonData["msg"].stringValue)
                }
          
            case let .failure(error):
            guard let fe = failureClosure else { return }
                fe(error.errorDescription ?? "网络错误")
            }
        }
            
    }
}
