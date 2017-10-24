//
//  XHCancelRequest.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import Alamofire

struct XHCancelRequest {
    // 当前网络请求
    fileprivate var manager: DataRequest
}

extension XHCancelRequest {
    init(request: DataRequest) {
        manager = request
    }
}

extension XHCancelRequest {
    /// 取消当前网络请求队列
    func cancelRequest() {
        manager.cancel()
    }
}
