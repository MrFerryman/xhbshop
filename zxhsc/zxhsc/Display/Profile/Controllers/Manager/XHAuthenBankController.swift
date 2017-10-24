//
//  XHAuthenBankController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAuthenBankController: UIViewController {

    @IBOutlet weak var cardNumberTF: UITextField! // 银行卡号
    
    @IBOutlet weak var openAreaBtn: UIButton!
    
    @IBOutlet weak var openBankBtn: UIButton!
    
    @IBOutlet weak var openBankBrand: UIButton!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var bankModel: XHMyBankModel?
    /// 省
    fileprivate var province: String?
    /// 市
    fileprivate var city: String?
    /// 银行名称
    fileprivate var bankName: String?
    /// 营业网点名称
    fileprivate var bankBranchCode: String?
    
    fileprivate let viewName = "认证设置_设置银行卡页面"
    
    fileprivate var banksArr: Array<XHBankListModel> = []
    fileprivate var bankNameArr: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.layer.cornerRadius = 6
        saveButton.layer.masksToBounds = true
        
        cardNumberTF.text = bankModel?.cardNum
        if bankModel?.bankDetal?.province != nil, bankModel?.bankDetal?.city != nil {
            openAreaBtn.setTitle((bankModel?.bankDetal?.province)! + " " + (bankModel?.bankDetal?.city)!, for: .normal)
            province = bankModel?.bankDetal?.province
            city = bankModel?.bankDetal?.city
        }
        if bankModel?.bankDetal?.bank_name != nil {
            openBankBtn.setTitle(bankModel?.bankDetal?.bank_name, for: .normal)
        }
        
        if bankModel?.bankDetal?.branch_bank_name != nil {
            openBankBrand.setTitle(bankModel?.bankDetal?.branch_bank_name, for: .normal)
            bankBranchCode = bankModel?.bankDetal?.bank_numb
        }
        
        phoneNumberTF.text = bankModel?.phoneNum
        
        title = "银行卡认证"
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 选择开户地区按钮点击事件
    @IBAction func openAreaButtonClicked(_ sender: UIButton) {
        XHPickerViewManager.instance.show()
        XHPickerViewManager.instance.pichkerViewReturnClosure = { [weak self] province, city in
            self?.openAreaBtn.setTitle(province + " " + city, for: .normal)
            self?.province = province
            self?.city = city
            self?.openBankBtn.setTitle("请选择开户银行", for: .normal)
            self?.openBankBrand.setTitle("请选择开户网点", for: .normal)
        }
    }
    
    // MARK:- 选择开户银行按钮点击事件
    @IBAction func openBankButtonClicked(_ sender: UIButton) {
        
        if province?.isEmpty == true || city?.isEmpty == true {
            showAlert(string: "开户地区不能为空")
            return
        }

        getBankList()
        XHPickerViewManager.instance.siglePickerViewClosure = { [weak self] title in
            self?.bankName = title
            self?.openBankBtn.setTitle(title, for: .normal)
            self?.openBankBrand.setTitle("请选择开户网点", for: .normal)
        }
    }
    
    // MARK:- 获取银行列表
    private func getBankList() {
        if province != nil, city != nil {
            let paraDict = ["provice": province!, "bank_city": city!]
            showHud(in: view)
            _ = XHRequest.shareInstance.requestNetData(dataType: .getBankList, parameters: paraDict, failure: { [weak self] (errorType) in
                self?.hideHud()
                var title: String?
                switch errorType {
                case .timeOut:
                    title = "网络请求超时，请重新请求~"
                default:
                    title = "网络请求错误，请重新请求~"
                }
                self?.showHint(in: (self?.view)!, hint: title!)
            }, success: {[weak self] (sth) in
                self?.hideHud()
                self?.bankNameArr.removeAll()
                if sth is [XHBankListModel] {
                    let banksArr = sth as! [XHBankListModel]
                    
                    for bankM in banksArr {
                        self?.bankNameArr.append(bankM.bank_name!)
                    }
                    if banksArr.count != 0 {
                        XHPickerViewManager.instance.showSinglePickerView(dataArr: (self?.bankNameArr)!)
                    }else {
                        XHAlertController.showAlertSigleAction(title: nil, message: "该地区没有支持的相关银行", confirmTitle: "确定", confirmComplete: nil)
                    }
                }
            })
        }else {
            XHAlertController.showAlertSigleAction(title: nil, message: "请选择开户地区", confirmTitle: "确定", confirmComplete: nil)
        }
    }
    
    // MARK:- 选择开户网点按钮点击事件
    @IBAction func openBankBrandButtonClicked(_ sender: UIButton) {
        
        if openBankBtn.titleLabel?.text == "请选择开户银行" {
            showAlert(string: "开户银行不能为空")
            return
        }
        
        getBankBranchList()
        XHPickerViewManager.instance.siglePickerViewClosure = { [weak self] title in
            self?.openBankBrand.setTitle(title, for: .normal)
            self?.openBankBrand.titleLabel?.textAlignment = .left
            for branchM in (self?.banksArr)! {
                if branchM.branch_bank_name == title {
                    self?.bankBranchCode = branchM.cnaps
                }
            }
        }
    }
    
    // MARK:- 获取营业网点列表
    private func getBankBranchList() {
        let paraDict = ["provice": province!, "bank_city": city!, "name": bankName!]
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getBankBranchList, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: {[weak self] (sth) in
                self?.hideHud()
                self?.bankNameArr.removeAll()
                if sth is [XHBankListModel] {
                    let banksArr = sth as! [XHBankListModel]
                    self?.banksArr = banksArr
                    for bankM in banksArr {
                        self?.bankNameArr.append(bankM.branch_bank_name!)
                    }
                    XHPickerViewManager.instance.showSinglePickerView(dataArr: (self?.bankNameArr)!)
                }
        })
    }
    
    // MARK:- 保存按钮点击事件
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if judge() == true {
            
            saveData()
        }
    }
    
    private func saveData() {
        let paraDict = ["mobile": (phoneNumberTF.text)!, "name": (bankModel?.name)!, "zhengid": (bankModel?.idCardNum)!, "cardid": (cardNumberTF.text)!, "cnaps": bankBranchCode!]
        showHud(in: view, hint: "保存中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .saveBankData, parameters: paraDict, failure: { [weak self] (errorType) in
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
            XHAlertController.showAlertSigleAction(title: nil, message: sth as? String, confirmTitle: "确定", confirmComplete: { 
                if (sth as! String) == "信息添加成功！" || (sth as! String) ==  "信息修改成功！" {
                    let authenController = self?.navigationController?.childViewControllers[1]
                    self?.navigationController?.popToViewController(authenController!, animated: true)
                }
            })
        }
    }
    
    private func judge() -> Bool {
        if XHRegularManager.isBankCardNumber(str: cardNumberTF.text!) == false {
            showAlert(string: "银行卡号输入有误，请重新输入")
            return false
        }
        
        if openAreaBtn.titleLabel?.text == "请选择开户地区" {
            showAlert(string: "开户地区不能为空")
            return false
        }
        
        if openBankBtn.titleLabel?.text == "请选择开户银行" {
            showAlert(string: "开户银行不能为空")
            return false
        }
        
        if openBankBrand.titleLabel?.text == "请选择开户网点" {
            showAlert(string: "开户网点不能为空")
            return false
        }
        
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumberTF.text!) == false {
            showAlert(string: "手机号码输入有误，请重新输入")
            return false
        }
        
        return true
    }

    private func showAlert(string: String) {
        showHint(in: view, hint: string)
    }
}
