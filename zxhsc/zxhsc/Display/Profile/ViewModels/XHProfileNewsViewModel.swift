//
//  XHProfileNewsViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHProfileNewsViewModel: NSObject {
    var dataSourceArr: Array<XHProfileManageModel>? = []
    
    override init() {
        
        let filePath = Bundle.main.path(forResource: "Profile_NewsCenter.plist", ofType: nil)
        let arr = NSArray(contentsOfFile: filePath!)
        let arrM = Mapper<XHProfileManageModel>().mapArray(JSONObject: arr)
        
        dataSourceArr = arrM
    }
}