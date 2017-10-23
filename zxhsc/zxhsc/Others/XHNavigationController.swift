//
//  XHNavigationController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        super.pushViewController(viewController, animated: animated)
    }

}
