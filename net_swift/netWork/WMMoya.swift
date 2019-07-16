//
//  WMMoya.swift
//  net_swift
//
//  Created by 吴冕 on 2019/5/13.
//  Copyright © 2019 wumian. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

public enum WMService {
    case preLogin(userName : String)
    case userCouponList(pageNum : String, status : String)
}

extension WMService: TargetType {
    public var needLogin: Bool {
        return false;
    }
    
    #warning("需要自己写")
    public var baseURL: URL {
        return URL(string: "接口的首地址")!
    }
    
    #warning("用case区分不同的接口，值为接口地址，需要新增自己写")
    public var path: String {
        switch self {
//        case .preLogin:
//            return "useracc/isregister"
//        case .userCouponList:
//            return "useracc/couponlists"
        default:
             return ""
        }
    }
    
    #warning("用case区分不同的接口和上面对应，值为请求方式，需要新增自己写")
    public var method: Moya.Method {
        switch self {
//        case .preLogin:
//            return .post
//        case .userCouponList:
//            return .get
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    #warning("用case区分不同的接口和上面对应，值为接口请求参数，需要新增自己写")
    public var task: Task {
        switch self {
            /*
             例：let userName:为传过来的参数值
             ["userName": userName]："userName"为接口的传入参数名字
             */
//        case .preLogin(let userName):
//            return .requestParameters(parameters: ["userName": userName], encoding: URLEncoding.default)
//        case .userCouponList(let pageNum, let status):
//            return .requestParameters(parameters: ["pageNum": pageNum, "status": status], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    #warning("请求头的编写，需要根据业务需要自己写")
    public var headers: [String : String]? {
        var heads = ["appVersion": Bundle.main.infoDictionary!["CFBundleShortVersionString"],
                     "machineType": "1",
                     "bundleID": Bundle.main.infoDictionary!["CFBundleIdentifier"]]
        var cookieString = "JYC-Node-App=%@"
        heads["Cookie"] = cookieString
        return heads as? [String : String]
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        return JSONDeserializer<T>.deserializeFrom(json: jsonString)!
    }
}
