//
//  XHPaymentWindow.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/11/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPaymentWindow: UIView {
    
    var priceStr: String? {
        didSet {
            priceL.text = "￥" + (priceStr ?? "")
        }
    }
    /// 取消按钮的点击事件回调
    var cancelButtonClickedClosure: (() -> ())?
    /// 确认支付按钮点击事件回调
    var confirmPaymentButtonClickedClosure: ((_ style: String, _ password: String?) -> ())?

    fileprivate var reuseId = "XHPaymentWindow_payment_reuseID"
    fileprivate var reuseId_secret = "XHPaymentWindow_reuseId_secret"
    
    fileprivate lazy var listDatas: [XHFukuanStyleModel] = []
    
    /// 输入密码cell
    fileprivate lazy var secretImgView: UIImageView = UIImageView(image: UIImage(named: "payment_lock"))
    
    fileprivate lazy var secretTextField: UITextField = {
        let textF = UITextField()
        textF.placeholder = "请输入支付密码"
        textF.font = UIFont.systemFont(ofSize: 12)
        textF.isSecureTextEntry = true
        return textF
    }()
    
    /// 可用余额
    fileprivate var banlance: CGFloat = 0.0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var totalPrice: CGFloat = 0.0
    fileprivate var styleListArr: [Int] = []
    fileprivate var isBanlancePay: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 标识支付方式
    fileprivate var currentZhifuStyle: String = "微信支付"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        getEffectiveBanlance()
        getPaymentList()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 获取支付方式列表
    private func getPaymentList() {
        let vc = UIViewController()
        XHShoppingCartViewModel.getPaymentList(vc) { [weak self] (result) in
            if result is Array<Any> {
                let list = result as! Array<Int>
                self?.styleListArr = list
                self?.setPaymentStyleList(list)
            }
        }
    }
    
    // MARK:- 获取可用余额
    private func getEffectiveBanlance() {
        let vc = UIViewController()
        XHShoppingCartViewModel.getEffectiveBanlance(vc) { [weak self] (result) in
            if result is CGFloat {
                self?.banlance = result as! CGFloat
                self?.setPaymentStyleList((self?.styleListArr)!)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result as? String, confirmTitle: "确定", confirmComplete: {
                    if (result as! String) == "请重新登陆！" {
                        let login = XHLoginController()
                        let nav = UINavigationController(rootViewController: login)
                        self?.superview?.viewController()?.navigationController?.pushViewController(nav, animated: true)
                    }
                })
            }
        }
    }
    
    
    // MARK:-
    private func setPaymentStyleList(_ listArr: [Int]) {
        var styleList = Array<XHFukuanStyleModel>()
        for element in listArr {
            let model = XHFukuanStyleModel()
            switch element {
            case 0:
                model.title = "二维码支付"
                model.iconsArr = ["payment_wechat", "payment_zhifubao"]
                model.isSelected = false
                styleList.append(model)
            case 1:
                model.title = "易宝支付"
                model.iconsArr = ["payment_yibao"]
                model.isSelected = false
                styleList.append(model)
                //            case 2:
                //                model.title = "快钱支付"
                //                model.iconsArr = ["payment_kuaiqian"]
                //                model.isSelected = false
            //                styleList.append(model)
            case 3:
                model.title = "联动优势支付"
                model.iconsArr = ["payment_liandong"]
                model.isSelected = false
                styleList.append(model)
                //            case 4:
                //                model.title = "支付宝支付"
                //                model.iconsArr = ["payment_zhifubao"]
            //                model.isSelected = false
            case 5: //
                model.title = "快捷通支付"
                model.iconsArr = ["payment_kuaijidong"]
                model.isSelected = false
                styleList.append(model)
                
            default:
                break
            }
        }
        
        let wechat = XHFukuanStyleModel()
        wechat.title = "微信支付"
        wechat.iconsArr = ["payment_wechat"]
        wechat.isSelected = true
        styleList.append(wechat)
        
        if banlance > totalPrice {
            let yu_e = XHFukuanStyleModel()
            yu_e.title = "余额支付"
            yu_e.iconsArr = ["payment_yue"]
            yu_e.isSelected = false
            
            styleList.append(yu_e)
        }
        
        listDatas = styleList
        tableView.reloadData()
    }
    
    // MARK:- 事件相关
    // MARK:  取消按钮点击事件
    @objc private func cancelButtonClicked() {
        cancelButtonClickedClosure?()
    }
    
    // MARK: 确认支付按钮点击事件
    @objc private func confirmPaymentButtonClicked() {
        if currentZhifuStyle == "余额支付" {
            if secretTextField.text?.isEmpty == true {
                UIApplication.shared.keyWindow?.rootViewController?.showHint(in: UIApplication.shared.keyWindow!, hint: "请输入支付密码")
                return
            }
            confirmPaymentButtonClickedClosure?(currentZhifuStyle, secretTextField.text!)
        }else {
            confirmPaymentButtonClickedClosure?(currentZhifuStyle, nil)
        }
    }
    
    // MARK:- 界面相关
    private func setupUI() {
        addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(12)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleL)
            make.left.equalTo(14)
            make.width.equalTo(50)
            make.height.equalTo(35)
        }
        
        addSubview(seperateLine)
        seperateLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(cancelButton.snp.bottom)
            make.height.equalTo(1)
        }
        
        addSubview(confirmPaymentButton)
        confirmPaymentButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-20)
            make.height.equalTo(44)
        }
        
        addSubview(priceL)
        priceL.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-5)
            make.top.equalTo(seperateLine.snp.bottom).offset(16)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(priceL.snp.bottom).offset(20)
            make.bottom.equalTo(confirmPaymentButton.snp.top).offset(-20)
        }
        
        tableView.register(UINib(nibName: "XHFukuanStyleCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_secret)
    }
    
    // MARK:- 懒加载
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "payment_close"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleL: UILabel = {
        let label = UILabel()
        label.text = "选择支付方式"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var priceL: UILabel = {
        let label = UILabel()
        label.text = "￥0.0"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xcccccc)
        return view
    }()
    
    private lazy var confirmPaymentButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确认支付", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.addTarget(self, action: #selector(confirmPaymentButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
}

extension XHPaymentWindow: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return isBanlancePay == true ? 2 : 1
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listDatas.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHFukuanStyleCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHFukuanStyleCell
            cell.banlance = banlance
            cell.zhifuModel = listDatas[indexPath.row]
            
            cell.selectedButtonClickedClosure = { [weak self] model in
                self?.currentZhifuStyle = model.title!
                for fuM in (self?.listDatas)! {
                    if fuM.title != model.title {
                        fuM.isSelected = false
                    }else {
                        fuM.isSelected = true
                        if fuM.title == "余额支付" {
                            self?.isBanlancePay = true
                        }else {
                            self?.isBanlancePay = false
                        }
                    }
                }
                tableView.reloadData()
                if self?.isBanlancePay == true {
                    tableView.scrollToRow(at: IndexPath(item: 0, section: 1), at: .bottom, animated: true)
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_secret, for: indexPath)
        self.setupSecretCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = listDatas[indexPath.row]
            currentZhifuStyle = model.title!
            for fuM in listDatas {
                if fuM.title != model.title {
                    fuM.isSelected = false
                }else {
                    fuM.isSelected = true
                    if fuM.title == "余额支付" {
                        isBanlancePay = true
                    }else {
                        isBanlancePay = false
                    }
                }
            }
            tableView.reloadData()
            if isBanlancePay == true {
                tableView.scrollToRow(at: IndexPath(item: 0, section: 1), at: .bottom, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 16
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isBanlancePay == true, section == 1 {
            return 10
        }
        return 0.01
    }
    
    fileprivate func setupSecretCell(cell: UITableViewCell) {
        cell.selectionStyle = .none
        cell.addSubview(secretImgView)
        secretImgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(cell)
            make.width.height.equalTo(20)
        }
        
        cell.addSubview(secretTextField)
        secretTextField.snp.makeConstraints { (make) in
            make.left.equalTo(secretImgView.snp.right).offset(6)
            make.centerY.equalTo(secretImgView)
            make.right.equalTo(-16)
        }
    }
}
