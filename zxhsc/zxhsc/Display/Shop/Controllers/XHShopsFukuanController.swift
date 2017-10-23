//
//  XHShopsFukuanController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopsFukuanController: UIViewController {

    @IBOutlet weak var shopPhoneNumL: UILabel! // 商家电话
    
    @IBOutlet weak var scaleTF: UITextField! // 让利比例
    
    @IBOutlet weak var customerPhoneTF: UITextField! // 消费者手机号
    
    @IBOutlet weak var nicknameL: UILabel! // 消费者昵称
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var moneyTF: UITextField! // 消费金额
    
    @IBOutlet weak var totalPriceL: UILabel! // 总支付金额
    
    var shopModel: XHMyShopModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBesicView()
        
        if NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) != nil {
            
            let userModel = NSKeyedUnarchiver.unarchiveObject(withFile: userAccountPath) as? XHUserModel
            shopPhoneNumL.text = userModel?.account
        }
        
        scaleTF.text = shopModel?.scale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取消费者昵称
    private func getCustomerNickname() {
        let paraDict = ["muser": customerPhoneTF.text!]
        XHMyShopViewModel.getCustomerDetail(paraDict, self) { [weak self] (result) in
            if result is XHTempUserModel {
                self?.nicknameL.text = (result as! XHTempUserModel).nickname
                self?.activityView.isHidden = false
                self?.nicknameL.alpha = 0
                self?.nicknameL.alpha = 1
                self?.activityView.isHidden = true
                self?.nicknameL.textColor = XHRgbColorFromHex(rgb: 0x666666)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "朕晓得了", confirmComplete: nil)
            }
        }
    }
    
    // MARK:-  去结算按钮点击事件
    @IBAction func goToCaculateButtonClicked(_ sender: UIButton) {
        if judge() == true {
            let paraDict = ["muser": customerPhoneTF.text!, "bili": scaleTF.text!, "xiaofeijine": moneyTF.text!]
            XHMyShopViewModel.shop_payment_commitOrder(paraDict, self, dataArrClosure: { [weak self] (result) in
                let orderId = NSString(string: result as! String).integerValue
                if orderId != 0 {
                    let fukuan = XHFukuanStyleController()
                    fukuan.orderId = result as? String
                    fukuan.comeFrom = .shopping_pay
                    let orderModel = XHShoppingCartModel()
                    orderModel.buyCount = "1"
                    let scale: CGFloat = StringToFloat(str: (self?.scaleTF.text)!)
                    let money: CGFloat = StringToFloat(str: (self?.moneyTF.text)!)
                    orderModel.price = "\(scale * money)"
                    fukuan.shoppingCartList = [orderModel]
                    self?.navigationController?.pushViewController(fukuan, animated: true)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
                }
            })
           
        }
    }
    
    // MARK:- 消费者手机号输入完成后的方法
    @objc private func customerPhoneNumberEditDidEnd() {
        if XHRegularManager.isCalidateMobileNumber(num: customerPhoneTF.text!) == false {
            showHint(in: view, hint: "消费者手机号输入有误，请重新输入~")
        }else {
            getCustomerNickname()
        }
    }
    
    /// MARK:- 让利比例和消费者金额输入完成后调用的方法
    @objc private func moneyOrScaleDidEditEnd(_ textField: UITextField) {
        switch textField.tag {
        case 1001: // 让利比例
             let number: CGFloat = StringToFloat(str: textField.text ?? "0")
            if scaleTF.text?.isEmpty == true || number < 0.05 || number > 1 {
                showHint(in: view, hint: "让利比例数据有误，请重新输入~")
                return
            }
        default: // 消费金额
            if (moneyTF.text?.isEmpty)! == true || StringToFloat(str: moneyTF.text!) == 0.0 {
                showHint(in: view, hint: "消费金额输入有误，请重新输入~")
                return
            }
        }
        
        let scale: CGFloat = StringToFloat(str: scaleTF.text!)
        let money: CGFloat = StringToFloat(str: moneyTF.text!)
        totalPriceL.text = "￥\(scale * money)"
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            scaleTF.resignFirstResponder()
            customerPhoneTF.resignFirstResponder()
            moneyTF.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    private func setupBesicView() {
        title = "商家付款"
        activityView.isHidden = true
        /// 消费者手机
        customerPhoneTF.addTarget(self, action: #selector(customerPhoneNumberEditDidEnd), for: .editingDidEnd)
        /// 让利比例
        scaleTF.tag = 1001
        scaleTF.addTarget(self, action: #selector(moneyOrScaleDidEditEnd(_:)), for: .editingDidEnd)
        /// 消费金额
        moneyTF.tag = 1002
        moneyTF.addTarget(self, action: #selector(moneyOrScaleDidEditEnd(_:)), for: .editingDidEnd)
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    // MARK:- 逻辑判断
    private func judge() -> Bool {
        let number: CGFloat = StringToFloat(str: scaleTF.text ?? "0")
        if scaleTF.text == nil || number < 0.05 || number > 1 {
            showHint(in: view, hint: "让利比例数据有误，请重新输入~")
            return false
        }
        
        if XHRegularManager.isCalidateMobileNumber(num: customerPhoneTF.text!) == false {
            showHint(in: view, hint: "消费者手机号输入有误，请重新输入~")
            return false
        }
        
        if (moneyTF.text?.isEmpty)! == true || StringToFloat(str: moneyTF.text!) == 0.0 {
            showHint(in: view, hint: "消费金额输入有误，请重新输入~")
            return false
        }
        
        if scaleTF.text?.isEmpty == true || NSString(string: scaleTF.text!).floatValue < 0.05 || NSString(string: scaleTF.text!).floatValue > 1 {
            showHint(in: view, hint: "让利比例输入有误，请重新输入~")
            return false
        }
        
        return true
    }

    private func showAlert(message: String) {
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelA = UIAlertAction(title: "确认", style: .cancel, handler: nil)
        alertC.addAction(cancelA)
        present(alertC, animated: true, completion: nil)
    }
    
}
