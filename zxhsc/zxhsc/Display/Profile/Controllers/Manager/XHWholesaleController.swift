//
//  XHWholesaleController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  大额支付

import UIKit

class XHWholesaleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getExplain()
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getExplain() {
        let paraDict = ["helpid": "40"]
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .helpDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            self?.getExplain()
            }, success: { [weak self] (sth) in
                self?.hideHud()
                let model = sth as! XHHTMLModel
                self?.title = model.title
                self?.webView.loadHTMLString(model.alternate_fields1!, baseURL: nil)
        })
    }
    
    
    private func setupNav() {
        view.backgroundColor = .white
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            if KUIScreenHeight == 812 {
                make.height.equalTo(90)
            }else {
                make.height.equalTo(64)
            }
        }
        
        view.addSubview(webView)
        webView.backgroundColor = .clear
        
        webView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(topView.snp.bottom).offset(50)
        }
    }

    // MARK:= ======== 懒加载 =========
    // 头部视图
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // webView
    private lazy var webView: UIWebView = UIWebView()
}
