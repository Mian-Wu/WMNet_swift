//
//  WMApiModel.swift
//  net_swift
//
//  Created by 吴冕 on 2019/5/14.
//  Copyright © 2019 wumian. All rights reserved.
//

import Foundation
import HandyJSON

typealias WMBaseModel = HandyJSON

struct WMResponse<T: WMBaseModel> : WMBaseModel{
    var success: Bool = false
    // 数据
    var datas: T?
    // 错误提示
    var i18nMessage: String?
}
#warning("接口的传入模型，需要自己根据接口类型自己新增定义")
struct WMPreLogin: WMBaseModel {
    // 是否注册过
    var isRegister: Bool?
    // 是否是常用设备
    var commonEquipment: Bool?
}
