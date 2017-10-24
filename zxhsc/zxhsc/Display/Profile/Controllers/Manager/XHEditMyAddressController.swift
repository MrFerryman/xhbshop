//
//  XHEditMyAddressController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHEditMyAddressController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var locationL: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    
    
    @IBOutlet weak var cityL: UILabel!
    
    @IBOutlet weak var detailLocationTV: ZYPlaceHolderTextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var saveButtonClicked: UIButton!
    
    
    
    var myAddressModel: XHMyAdressModel?
    
    fileprivate let viewName = "添加地址页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTF.text = myAddressModel?.addressee
        phoneNumTF.text = myAddressModel?.phoneNum
        if myAddressModel?.city != nil {
            cityL.text = myAddressModel?.city
        }
        
        detailLocationTV.text = myAddressModel?.street
        
        setupBasic()
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
    
    // MARK:- 上传数据
    private func uploadData() {
        
        let paraDict = ["address_id": myAddressModel?.address_id ?? "", "shoujianren": nameTF.text!, "lianxidianhua": phoneNumTF.text!, "jiedao": detailLocationTV.text!, "shiqu": cityL.text!, "moren": myAddressModel?.isDefault ?? "0"]
        
        showHud(in: view, hint: "上传中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .setMyAddress, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            self?.showHint(in: (self?.view)!, hint: sth as! String)
            if (sth as! String) == "添加成功！" || (sth as! String) == "编辑成功！" {
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if judge() == true {
            uploadData()
        }
    }
    
    // MARK:- 位置视图的点击事件
    @objc private func locationClicked() {
        nameTF.resignFirstResponder()
        phoneNumTF.resignFirstResponder()
        XHPickerViewManager.instance.show()
        XHPickerViewManager.instance.pichkerViewReturnClosure = { [weak self] province, city in
            self?.locationL.text = province + " " + city
        }
        
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            nameTF.resignFirstResponder()
            phoneNumTF.resignFirstResponder()
            detailLocationTV.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    // MARK:- 简单的逻辑判断
    private func judge() -> Bool{
        
        if nameTF.text?.isEmpty == true {
            showHint(in: view, hint: "收货人名称不能为空")
            return false
        }
        
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumTF.text!) == false {
            showHint(in: view, hint: "收货人电话号码有误，请重新输入")
            phoneNumTF.becomeFirstResponder()
            return false
        }
        
        if locationL.text?.isEmpty == true {
            showHint(in: view, hint: "请设置收货地址")
            return false
        }
        
        if NSString(string: detailLocationTV.text).length < 5 {
            showHint(in: view, hint: "请输入正确的详细地址")
            return false
        }
        
        return true
    }


    // MARK:- 设置基本
    private func setupBasic() {
        
        title = "收货地址"
        
        detailLocationTV.placeholder = " 请输入详细地址，不少于5个字"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(locationClicked))
        locationView.addGestureRecognizer(tap)
        
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = true
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
}
