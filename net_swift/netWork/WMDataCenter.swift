//
//  WMDataCenter.swift
//  net_swift
//
//  Created by 吴冕 on 2019/5/13.
//  Copyright © 2019 wumian. All rights reserved.
//

import UIKit
import Moya
import SVProgressHUD
import SnapKit
import SAMKeychain

let dataCenter = WMDataCenter.sharedCenter
final class WMDataCenter {
    static let sharedCenter = WMDataCenter()
    // 获取用户是否登录
    var isLogin: Bool {
        return accesstoken != nil
    }
    // 用户令牌
    /*
     token,用SAMKeychainzc钥匙串保存，键值为TOKEN可以自己设键值
     */
    var accesstoken: String? = SAMKeychain.password(forService: Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String, account: "TOKEN") {
        didSet {
            if let token = accesstoken {
                SAMKeychain.setPassword(token, forService: Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String, account: "TOKEN")
            } else {
                SAMKeychain.deletePassword(forService: Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String, account: "TOKEN")
            }
        }
    }
    
    /// 网络请求插件
    private let WMProvider = MoyaProvider<WMService>(
        plugins: [
            JYCNetworkPlugin(),
            NetworkActivityPlugin {(state,_) in
                if state == .began{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            },
            // 日志
            NetworkLoggerPlugin(verbose: true, output: { (_, _, printing: Any...) in
                let stringArray: [String] = printing.map { $0 as? String }.compactMap { $0 }
                let string: String = stringArray.reduce("") { $0 + $1 + " " }
//                DDLogVerbose(string)
                NSLog("%@", string)
            })
        ]
    )
    
    func request<T: WMBaseModel>(_ target: WMService,
                                 model: T.Type,
                                 _ isShow: Bool = true,
                                 callback: @escaping (Bool, T?, String?) -> Void)  {
        if isShow {
            SVProgressHUD.show()
        }
        WMProvider.request(target) { result in
            switch result {
            case let .success(response):
                if isShow {
                    SVProgressHUD.dismiss()
                }
                // 没有数据
                guard (try? response.mapJSON()) != nil else {
                    callback(false,nil,nil)
                    return
                }
                // 有数据
                let resultModel = response.mapModel(WMResponse<T>.self)
                if resultModel.success == true {
                    callback(true,resultModel.datas,nil)
                } else {
                    // 401，登录失效
                    if response.statusCode == 401 {
                        dataCenter.accesstoken = nil
                    } else {
                        // 接口错误
                        if isShow {
                            if let i18nMessage = resultModel.i18nMessage {
                                SVProgressHUD.showError(withStatus: i18nMessage)
                            } else {
                                SVProgressHUD.showError(withStatus: "网络超时，请稍后重试")
                            }
                        }
                    }
                    callback(false,nil,resultModel.i18nMessage)
                }
            case let .failure(error):
                // 无网
                if isShow {
                    SVProgressHUD.showError(withStatus: "网络超时，请稍后重试")
                }
                callback(false,nil,error.errorDescription)
                return
            }
        }
    }
}

class JYCNetworkPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        mRequest.timeoutInterval = 30
        return mRequest
    }
}

public class WMProgressHUD:NSObject {
    public func show(show_s: String){
        SVProgressHUD.showInfo(withStatus: show_s)
    }
}

