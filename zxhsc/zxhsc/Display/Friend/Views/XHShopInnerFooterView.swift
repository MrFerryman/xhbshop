//
//  XHShopInnerFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopInnerFooterView: UIView, UITextFieldDelegate {
    
    /// 确认支付按钮点击事件回调
    var confirmButtonClickedClosure: ((_ money: String) -> ())?
    var shopModel: XHShopDetailModel?
    
    
    fileprivate let fontSize: CGFloat = 13
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 确认支付按钮点击事件
    @objc private func confirmButtonClicked() {
        confirmButtonClickedClosure?(textF.text!)
    }
    
    @objc private func textFieldEditing(_ textField: UITextField) {
        confirmBtn.isEnabled = textField.text?.isEmpty == true ? false : true
        confirmBtn.backgroundColor = textField.text?.isEmpty == true ? XHRgbColorFromHex(rgb: 0xeeeeee) : XHRgbColorFromHex(rgb: 0xea2000)
        let money = NSString(string: textField.text!).floatValue
        let result = CGFloat(money) * (shopModel?.scale ?? 0.0) / 100.0
        xhbL.text = String(format: "%.2f", result)
    }
    
    // MARK:- 界面相关
    private func setupUI() {
        addSubview(view1)
        view1.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalTo(self)
            make.height.equalTo(44)
        }
        
        view1.addSubview(custom_fontL)
        custom_fontL.snp.makeConstraints { (make) in
            make.centerY.equalTo(view1)
            make.left.equalTo(16)
        }
        
        view1.addSubview(yuan_fontL)
        yuan_fontL.snp.makeConstraints { (make) in
            make.centerY.equalTo(view1)
            make.right.equalTo(-16)
        }
        
        view1.addSubview(textF)
        textF.snp.makeConstraints { (make) in
            make.centerY.equalTo(view1)
            make.right.equalTo(yuan_fontL.snp.left).offset(-3)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        // -----------------------------------
        addSubview(view2)
        view2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(view1.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        
        view2.addSubview(giveL)
        giveL.snp.makeConstraints { (make) in
            make.centerY.equalTo(view2)
            make.left.equalTo(16)
        }
        
        view2.addSubview(xhb_fontL)
        xhb_fontL.snp.makeConstraints { (make) in
            make.centerY.equalTo(view2)
            make.right.equalTo(-16)
        }
        
        view2.addSubview(xhbL)
        xhbL.snp.makeConstraints { (make) in
            make.centerY.equalTo(view2)
            make.right.equalTo(xhb_fontL.snp.left).offset(-3)
        }
        
        addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
            make.top.equalTo(view2.snp.bottom).offset(30)
        }
    }
    
    // MARK:- 懒加载
    private lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var custom_fontL: UILabel = {
        let label = UILabel()
        label.text = "消费金额"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var textF: UITextField = {
        let field = UITextField()
        field.placeholder = "消费金额"
        field.textAlignment = .right
        field.delegate = self
        field.keyboardType = .decimalPad
        field.font = UIFont.systemFont(ofSize: fontSize)
        field.borderStyle = .none
        field.addTarget(self, action: #selector(textFieldEditing(_:)), for: .editingChanged)
        return field
    }()
    
    private lazy var yuan_fontL: UILabel = {
        let label = UILabel()
        label.text = "元"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var giveL: UILabel = {
        let label = UILabel()
        label.text = "赠送"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var xhb_fontL: UILabel = {
        let label = UILabel()
        label.text = "循环宝"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var xhbL: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确认支付", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
        btn.isEnabled = false
        btn.layer.cornerRadius = 6
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        return btn
    }()
}
