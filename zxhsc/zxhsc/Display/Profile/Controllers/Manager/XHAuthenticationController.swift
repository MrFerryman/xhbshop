//
//  XHAuthenticationController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

var isEmpty_Authentication: Bool = false

class XHAuthenticationController: UIViewController {
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var unEmptyView: UIView! // 非空界面
    @IBOutlet weak var bankL: UILabel! // 银行名
    
    
    @IBOutlet weak var placeholdL: UILabel!
    
    @IBOutlet weak var lastNumL: UILabel! // 银行卡最后四位
    
    @IBOutlet weak var provinceL: UILabel! // 省
    
    @IBOutlet weak var cityL: UILabel! // 市
    
    @IBOutlet weak var bankBrandL: UILabel! // 支行
    
    @IBOutlet weak var phoneNumL: UILabel! // 预留手机号
    
    @IBOutlet weak var nameL: UILabel! // 持卡人
    
    @IBOutlet weak var idCardL: UILabel! // 身份证
    
    fileprivate var myBankModel: XHMyBankModel?
    
    fileprivate let viewName = "认证设置页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if kUIScreenWidth == 320 {
            placeholdL.text = "* * * *  * * * *  * * * *"
        }
        
        setupEmptyUI()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK:- 获取数据
    private func loadData() {
        
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyBankCards, failure: { [weak self] (errorType) in
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
            if sth is XHMyBankModel {
                self?.setupUnemptyUI()
                let bankModel = sth as! XHMyBankModel
                self?.myBankModel = bankModel
                self?.setupDetailData(bankModel)
            }else {
                self?.setupEmptyUI()
            }
        }
    }

    private func setupDetailData(_ bankModel: XHMyBankModel) {
        bankL.text = bankModel.bankDetal?.bank_name
        provinceL.text = bankModel.bankDetal?.province
        cityL.text = bankModel.bankDetal?.city
        bankBrandL.text = bankModel.bankDetal?.branch_bank_name
        phoneNumL.text = "银行预留手机号：" + bankModel.phoneNum!
        nameL.text = bankModel.name
        idCardL.text = bankModel.idCardNum
        if bankModel.cardNum != nil {
            let index = bankModel.cardNum?.index((bankModel.cardNum?.endIndex)!, offsetBy: -4)
            lastNumL.text = bankModel.cardNum?.substring(from: index!)
        }
    }
    
    @IBAction func changeBankCardButtonClicked(_ sender: UIButton) {
        if myBankModel?.canBeModified == "1" {
            let idenVc = XHAuthenBankController()
            idenVc.bankModel = myBankModel
            navigationController?.pushViewController(idenVc, animated: true)
            return
        }
        
       let idAuthenV = XHAuthenIdentiferController()
        idAuthenV.myBankModel = myBankModel
        navigationController?.pushViewController(idAuthenV, animated: true)
    }
    
    @objc func jumpToIDAuthen() {
        let idenVc = XHAuthenIdentiferController()
        navigationController?.pushViewController(idenVc, animated: true)
    }
    
    // 布局非空界面
    private func setupUnemptyUI() {
        unEmptyView.isHidden = false
        emptyView.isHidden = true
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lastNumL.text!, attributes: [NSAttributedStringKey.kern: 2])
        let paragraphStyle = NSMutableParagraphStyle()
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: NSString(string: lastNumL.text!).length))
        lastNumL.attributedText = attributedString
        lastNumL.sizeToFit()
    }
    
    // 布局空界面
    private func setupEmptyUI() {
        unEmptyView.isHidden = true
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(navView)
        }
        
        emptyView.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(emptyView)
            make.top.equalTo(emptyView).offset(140)
            make.width.equalTo(117)
            make.height.equalTo(116)
        }
        
        emptyView.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(emptyView)
            make.top.equalTo(emptyImgView.snp.bottom).offset(20)
        }
        
        emptyView.addSubview(addAuthBtn)
        addAuthBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(emptyView)
            make.top.equalTo(emptyL.snp.bottom).offset(40)
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
    }
    
    // MARK:- ======== 懒加载 ========
    // 空界面控件
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "bankCard_icon_empty"))

    // 文字
    private lazy var emptyL: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.text = "暂时没有添加认证信息"
        return label
    }()
    
    private lazy var addAuthBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xea2000), for: .normal)
        btn.setTitle("+添加认证信息", for: .normal)
        btn.setBackgroundImage(UIImage(named: "bankCard_add_empty"), for: .normal)
        btn.addTarget(self, action: #selector(jumpToIDAuthen), for: .touchUpInside)
        return btn
    }()
}
