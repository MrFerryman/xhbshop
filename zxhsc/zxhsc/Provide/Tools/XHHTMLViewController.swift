//
//  XHHTMLViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHTMLViewController: UIViewController {

    var helpId: String? {
        didSet {
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        setupWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //导航栏透明
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.backgroundColor = .clear
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        self.navigationController?.navigationBar.shadowImage = UIImage()

    }
    
    private func loadData() {
        let paraDict: [String: String] = ["helpid": helpId!]
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .helpDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (model) in
            self?.hideHud()
            
            if model is XHHTMLModel {
                let htmlModel = model as! XHHTMLModel
                self?.title = htmlModel.title
                let resultStr =  String.kStringByReplaceString(string: htmlModel.alternate_fields1!, replaceStr: "src=", willReplaceStr: "width='100%' src=")
                self?.webView.loadHTMLString(resultStr, baseURL: nil)
            }else {
                let str = model as! String
                self?.showHint(in: (self?.view)!, hint: str)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupWebView() {
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(webView)
        webView.backgroundColor = .white
        webView.contentMode = .scaleAspectFill
        webView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
    }
    

   // MARK:- ====== 懒加载 ========
    // webView
    private lazy var webView: UIWebView = UIWebView()
    
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()

}
