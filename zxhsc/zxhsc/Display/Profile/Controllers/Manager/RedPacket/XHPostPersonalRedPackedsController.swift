//
//  XHPostPersonalRedPackedsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHPostPersonalRedPackedsController: UIViewController, WXApiDelegate {
    @IBOutlet weak var topCon: NSLayoutConstraint!
    
    @IBOutlet weak var moneyTF: UITextField!
    
    
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var countTF: UITextField!
    
    @IBOutlet weak var putInButton: UIButton!
    
    
    @IBOutlet weak var moneyL: UILabel!
    
    @IBOutlet weak var topHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var middleCon: NSLayoutConstraint!
    
    @IBOutlet weak var bottomCon: NSLayoutConstraint!
    
    /// 是否是个人红包
    var isPersonalRedPacketes: Bool = true {
        didSet {
            viewName = isPersonalRedPacketes == true ? "发送个人红包页面" : "发送群红包页面"
        }
    }
    fileprivate var viewName = ""
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isPersonalRedPacketes == true {
            countView.isHidden = true
        }else {
            countView.isHidden = false
        }
        
        if kUIScreenWidth == 320 {
            topHeightCon.constant = 155
        }
        
        putInButton.layer.cornerRadius = 6
        putInButton.layer.masksToBounds = true
        setupNav()
        
        if KUIScreenHeight == 812 {
            topCon.constant = 90
            middleCon.constant = 60
            bottomCon.constant = 120
        }else {
            topCon.constant = 64
            middleCon.constant = 35
            bottomCon.constant = 35
        }
        
        moneyTF.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(payment_notification_success), name: NSNotification.Name(rawValue: NOTI_PAYMENT_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(payment_notification_failure), name: NSNotification.Name(rawValue: NOTI_PAYMENT_FAILURE), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 支付成功的通知
    @objc private func payment_notification_success() {
        XHAlertController.showAlertSigleAction(title: "提示", message: "支付成功", confirmTitle: "确定", confirmComplete: { [weak self] in
            let red = XHMyRedPackectsController()
            self?.navigationController?.pushViewController(red, animated: true)
        })
    }
    
    // MARK:- 支付失败的通知
    @objc private func payment_notification_failure() {
        XHAlertController.showAlertSigleAction(title: "提示", message: "支付失败", confirmTitle: "确定", confirmComplete: nil)
    }
    
    @objc private func textFieldValueChanged(textField: UITextField) {
        if textField.text?.isEmpty == true {
            moneyL.text = "￥0.0"
        }else {
            moneyL.text = "￥" + textField.text!
        }
    }
    
    // MARK:- 发送 发红包 请求
    private func sendRequest(paymentStyle: String, password: String?) {
        var paraDict = ["money": moneyTF.text!]
        if isPersonalRedPacketes == false {
            paraDict["times"] = countTF.text
        }
        
        XHRedPacketsViewModel.sendRedPackeds(target: self, paramter: paraDict) { [weak self] (result) in
            let orderID = NSString(string: result as! String).intValue
            if orderID != 0 {
                self?.payment(currentZhifuStyle: paymentStyle, orderId: result as! String, password: password)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result as? String, confirmTitle: "朕知道了", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 支付
    private func payment(currentZhifuStyle: String, orderId: String, password: String?) {
        switch currentZhifuStyle {
        
        case "联动优势支付":
            let baseURL = "http://wx2.zxhshop.cn/alipay/liandongpay/index.php?id="
            let webView = XHWebViewController()
            let order_ID: String =  orderId + "_rl"
            
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            let url = baseURL + order_ID + "&hyid=" + userid! + "&jine=" + moneyTF.text!
            
            webView.urlStr = url
            navigationController?.pushViewController(webView, animated: true)

        case "快钱支付":
            let baseURL = "http://appback.zxhshop.cn/"
            let webView = XHWebViewController()
            let url = baseURL + "shop_kuaiqian_fukuan_cart.php?&order_id=" + orderId + "&oid=" +  "1"
                webView.urlStr = url
           
            navigationController?.pushViewController(webView, animated: true)
            
        case "余额支付":
            
            if NSString(string: password!).length >= 6 {
                var paraDict: [String : String] = [:]
                paraDict["idlx"] = "r"
                paraDict["order_id"] = orderId
                paraDict["zhifupass"] = password
                XHFukuanStyleViewModel.payment_Banlance(paraDict, self, dataArrClosure: { [weak self] (result) in
                    XHAlertController.showAlertSigleAction(title: "提示", message:  result as? String, confirmTitle: "确定", confirmComplete: {
                        let myOrder = XHMyOrderController()
                        self?.navigationController?.pushViewController(myOrder, animated: true)
                    })
                })
            }else {
                showHint(in: view, hint: "请输入正确的支付密码")
            }
        case "快捷通支付": // 快捷通支付
            let baseURL = "http://wx2.zxhshop.cn/alipay/kjtpay/index.php?id="
            let webView = XHWebViewController()
            let order_ID: String = orderId + "_rl"
            
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            let url = baseURL + order_ID + "&hyid=" + userid! + "&jine=" + moneyTF.text!
            
            webView.urlStr = url
            navigationController?.pushViewController(webView, animated: true)
            
        case "微信支付":
            let paraDict = ["oid": "6", "ewm_order_id": orderId]
            XHRedPacketsViewModel.getWechatPaymentOrderDetail(target: self, paramter: paraDict, success: { (result) in
                if result is XHWechatOrderModel {
                    let model = result as! XHWechatOrderModel
                    let request = PayReq()
                    request.partnerId = "61957544"
                    request.prepayId = model.prepay_id
                    request.package = model.package
                    request.nonceStr = model.nonce_str
                    request.timeStamp = UInt32(NSString(string: model.timestamp!).intValue)
                    request.sign = model.sign
                    WXApi.send(request)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
                }
            })
        default:
            break
        }
    }
    
    // MARK:- 按钮点击事件
    @IBAction func putInMoneyButtonClicked(_ sender: UIButton) {
        if judge() == true {
            setupPaymentWindow()
        }
    }
    
    private func setupPaymentWindow() {
        UIApplication.shared.keyWindow?.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
        
        paymentWindow.priceStr = moneyTF.text
        let y = KUIScreenHeight / 3
        paymentWindow.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: KUIScreenHeight * 2 / 3)
        maskView.addSubview(paymentWindow)
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            self?.paymentWindow.frame = CGRect(x: 0, y: y, width: kUIScreenWidth, height: KUIScreenHeight * 2 / 3)
        }
        
        // MARK:  取消按钮的点击事件回调
        paymentWindow.cancelButtonClickedClosure = { [weak self] in
            UIView.animate(withDuration: 0.35, animations: {
                self?.paymentWindow.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: KUIScreenHeight * 2 / 3)
            }, completion: { (finished) in
                self?.paymentWindow.removeFromSuperview()
                self?.maskView.removeFromSuperview()
            })
        }
        
        // MARK: 确认支付按钮点击事件回调
        paymentWindow.confirmPaymentButtonClickedClosure = { [weak self] styleStr, password in
            UIView.animate(withDuration: 0.35, animations: {
                self?.paymentWindow.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: KUIScreenHeight * 2 / 3)
            }, completion: { (finished) in
                self?.paymentWindow.removeFromSuperview()
                self?.maskView.removeFromSuperview()
            })
            
            self?.sendRequest(paymentStyle: styleStr, password: password)
        }
    }

    private func setupNav() {
        title = "发红包"
    }
    
    private func judge() -> Bool {
        if NSString(string: moneyTF.text!).floatValue < 1.0 {
            showHint(in: view, hint: "红包金额不能少于 1 元，请重新输入~")
            return false
        }
        
        if isPersonalRedPacketes == false, NSString(string: countTF.text!).intValue < 1 {
            showHint(in: view, hint: "红包个数输入有误，请重新输入~")
            return false
        }
        
        return true
    }

    private lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = XHRgbaColorFromHex(rgb: 0x000000, alpha: 0.5)
        return view
    }()
    
    private lazy var paymentWindow = XHPaymentWindow()
}
