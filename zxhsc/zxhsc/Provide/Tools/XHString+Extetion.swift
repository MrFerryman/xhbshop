//
//  XHString+Extetion.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHString_Extetion: NSObject {

}

extension String {
    //字符串replace方法
    static func kStringByReplaceString(string:String,replaceStr:String,willReplaceStr:String) ->String{
        return string.replacingOccurrences(of: replaceStr, with: willReplaceStr)
    }
}
