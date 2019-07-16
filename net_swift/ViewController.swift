//
//  ViewController.swift
//  net_swift
//
//  Created by 吴冕 on 2019/6/3.
//  Copyright © 2019 wumian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    #warning("全局搜索#warning，有部分需要自己根据业务新增修改")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataCenter.request(WMService.preLogin(userName: "电话号码"), model: WMPreLogin.self) { (isSuccess, res, error) in
            if isSuccess {
                NSLog("%zd-%zd", res?.isRegister ?? "", res?.commonEquipment ?? "")
            } else{
                NSLog("%@", error ?? "")
            }
        }
        /*
         判断用户是否登录
         */
        if dataCenter.isLogin {
        }
    }
}

