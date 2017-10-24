//
//  XHAlertController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

struct XHAlertController {

}

extension XHAlertController {
    static func showAlert(title: String?, message: String?, Style: UIAlertControllerStyle, confirmTitle: String?, confirmComplete: (() -> ())?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: Style)
        if confirmTitle != nil {
            let confirmA = UIAlertAction(title: confirmTitle, style: .default, handler: { (action) in
                confirmComplete?()
            })
            alertC.addAction(confirmA)
        }
        
        let cancelA = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(cancelA)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
    }
    
    static func showAlertSigleAction(title: String?, message: String?, confirmTitle: String?, confirmComplete: (() -> ())?) {
        let alertV = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmA = UIAlertAction(title: confirmTitle, style: .cancel) { (action) in
            confirmComplete?()
        }
        alertV.addAction(confirmA)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertV, animated: true, completion: nil)
    }
}

