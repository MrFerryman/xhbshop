//
//  XHWebViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import WebKit

class XHWebViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    var urlStr: String? {
        didSet {
            let url = URL(string: urlStr!)
            
//            let url = URL(string: "https://baike.baidu.com")
            webView.load(URLRequest(url: url!))
        }
    }
    
    /// js调用OC代码的回调
    var JSCallOCMethodClosure: (() -> ())?
    
    /// OC调用js代码的回调
    var OCCallJSMethodClosure: (() -> String)?
    
    /// 返回按钮点击事件回调
    var backBarButtonClickedClosure: (() -> ())?
    
  
    fileprivate var progressView: UIProgressView! = UIProgressView(frame: CGRect(x: 0, y: nav_height, width: kUIScreenWidth, height: 2))
    
    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "move")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupWebView() {
        
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(source: "function showAlert() { alert('在载入webview时通过Swift注入的JS方法'); }",
                                  injectionTime: .atDocumentStart, // 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
        config.userContentController.addUserScript(script)
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        config.userContentController.add(self, name: "JSCallOCMethod")
        
        view.addSubview(webView)
        view.addSubview(self.progressView)
    }
    
    private func setupNav() {
        let navItem = UIBarButtonItem(image: UIImage(named: "Back Chevron"), style: .plain, target: self, action: #selector(back))
        navigationItem.backBarButtonItem = navItem
    }
    
    @objc private func back() {
        backBarButtonClickedClosure?()
    }
    
    private lazy var config: WKWebViewConfiguration = {
        // 创建一个webiview的配置项
        let config = WKWebViewConfiguration()
        
        // webveiew的偏好设置
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        // 默认是不能透过JS自动打开窗口的，必须通过用户交互才能打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // web内容处理池
        config.processPool = WKProcessPool()
        
        // 通过JS与WebView内容交互配置
        config.userContentController = WKUserContentController()
        
        return config
    }()
    
    
    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: KUIScreenHeight), configuration: self.config)
        // 监听支持KVO的属性
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new, .old], context: nil)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        return webView
    }()
}

extension XHWebViewController {
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
       
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        weak var wself = self
        if keyPath == "loading" {
            print("loading")
        } else if keyPath == "title" {
            title = wself?.webView.title
        } else if keyPath == "estimatedProgress" {
            
            wself?.progressView.setProgress(Float((wself?.webView.estimatedProgress)!), animated: true)
            if (wself?.webView.estimatedProgress)! >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    wself?.progressView.alpha = 0.0
                }, completion: { (finish) in
                    wself?.progressView.setProgress(0.0, animated: true)
                })
            }
        }
        
        // 已经完成加载时，我们就可以做我们的事了
        if !webView.isLoading {
            // 手动调用JS代码
            self.webView.evaluateJavaScript((OCCallJSMethodClosure?()) ?? "") { (_, _) -> Void in
                if wself?.tabBarController?.tabBar != nil {
                    wself?.tabBarController?.tabBar.isHidden = true
                }
                //                wself?.OCCallJSMethodClosure?()
            }
            
            UIView.animate(withDuration: 0.55, animations: { () -> Void in
                wself?.progressView.alpha = 0.0;
            })
        }
    }
    
    // MARK: - WKNavigationDelegate
    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let hostname = (navigationAction.request as NSURLRequest).url?.host?.lowercased()
        
        // 处理跨域问题
        if navigationAction.navigationType == .linkActivated && !hostname!.contains(".baidu.com") {
            // 手动跳转
            UIApplication.shared.openURL(navigationAction.request.url!)
            
            // 不允许导航
            decisionHandler(.cancel)
        } else {
            self.progressView.alpha = 1.0
            
            decisionHandler(.allow)
        }
    }
    
    
    /// 开始导航跳转时会回调
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始导航跳转")
    }
    /// 接收到重定向时会回调
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到重定向")
    }
    
    // 在收到响应后，决定是否跳转
    //    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //
    //    }
    //
    /// 导航失败时回调
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertC = UIAlertController(title: "导航错误", message: String(describing: error.localizedDescription), preferredStyle: .alert)
        
        let cancelA = UIAlertAction(title: "确定", style: .cancel) { [weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
        }
        alertC.addAction(cancelA)
        present(alertC, animated: true, completion: nil)
    }
    /// 页面内容到达main frame时回调
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("页面内容到达main frame")
    }
    /// 导航完成时回调
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("导航完成")
    }
    /// 导航失败时回调
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("导航失败")
    }
    
    // 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
    // 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
    
    // 9.0才能使用，web内容处理中断时会触发
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("web内容处理中断")
    }
    
    // 在JS端调用alert函数时，会触发此代理方法。
    // JS端调用alert时所传的数据可以通过message拿到
    // 在原生得到结果后，需要回调JS，是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // JS端调用confirm函数时，会触发此方法
    // 通过message可以拿到JS端所传的数据
    // 在iOS端显示原生alert得到YES/NO后
    // 通过completionHandler回调给JS端
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "confirm", message: "JS调用confirm", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // JS端调用prompt函数时，会触发此方法
    // 要求输入一段文本
    // 在原生输入得到文本内容后，通过completionHandler回调给JS
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "alert", message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.textColor = .red
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(alert.textFields?.last?.text)
        }))
        present(alert, animated: true, completion: nil)
    }
}


