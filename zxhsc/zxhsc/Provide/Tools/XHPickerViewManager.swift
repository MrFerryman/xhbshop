//
//  XHPickerViewManager.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPickerViewManager: NSObject, AddressPickerViewDelegate {

    static let instance = XHPickerViewManager()
    
    fileprivate var pickerDataArr: [String] = []
    
    var pichkerViewReturnClosure: ((_ province: String, _ city: String) -> ())?
    
    var siglePickerViewClosure: ((_ title: String) -> ())?
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
        
        maskView.alpha = 1
        maskView.addSubview(addressPickerView)
        
        UIView.animate(withDuration: 0.3) {
            self.addressPickerView.frame = CGRect(x: 0, y: KUIScreenHeight - 215, width: kUIScreenWidth, height: 215)
        }
    }
    
    func showSinglePickerView(dataArr: Array<String>) {
        
        pickerDataArr = dataArr
        pView.reloadAllComponents()
        
        UIApplication.shared.keyWindow?.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
        
        maskView.alpha = 1
        maskView.addSubview(pickerView)
        
        UIView.animate(withDuration: 0.5) {
            self.pickerView.frame = CGRect(x: 0, y: KUIScreenHeight - 215, width: kUIScreenWidth, height: 215)
        }
    }
    
    // MARK:- 地区选择器的代理方法
    func sureBtnClickReturnProvince(_ province: String!, city: String!, area: String!) {
        pichkerViewReturnClosure?(province, city)
        cancelBtnClick()
    }
    
    /** 取消按钮点击事件*/
    func cancelBtnClick() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.addressPickerView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 215)
            self.maskView.alpha = 0
            self.pickerView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 215)
        }) { (finish) in
            self.addressPickerView.removeFromSuperview()
            self.maskView.removeFromSuperview()
            self.pickerView.removeFromSuperview()
        }
    }
    
    /*确定按钮点击事件*/
    @objc func confirmButtonClicked() {
        let index = pView.selectedRow(inComponent: 0)
        siglePickerViewClosure?(pickerDataArr[index])
        cancelBtnClick()
    }
    
    // MARK:- 懒加载
    private lazy var addressPickerView: AddressPickerView = {
        let view = AddressPickerView(frame: CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 215))
        view.delegate = self
        return view
    }()
    
    private lazy var pickerView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 215))
        view.backgroundColor = .white
        // 取消
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(XHRgbColorFromHex(rgb: 0x333333), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints({ (make) in
            make.left.top.equalTo(view)
            make.width.equalTo(75)
            make.height.equalTo(44)
        })
        
        // 完成
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.setTitle("完成", for: .normal)
        confirmBtn.setTitleColor(XHRgbColorFromHex(rgb: 0x333333), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints({ (make) in
            make.right.top.equalTo(view)
            make.width.equalTo(75)
            make.height.equalTo(44)
        })
        
        view.addSubview(self.pView)
        self.pView.snp.makeConstraints({ (make) in
            make.right.left.bottom.equalTo(view)
            make.top.equalTo(view).offset(44)
        })
        
        return view
    }()
    
    private lazy var pView: UIPickerView = {
        let view = UIPickerView(frame: CGRect(x: 0, y: 44, width: kUIScreenWidth, height: 171))
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)
        
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var maskView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelBtnClick))
        view.addGestureRecognizer(tap)
        return view
    }()
}

extension XHPickerViewManager: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        siglePickerViewClosure?(pickerDataArr[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textColor = UIColor(red: 51.0 / 255, green: 51.0 / 255, blue: 51.0 / 255, alpha: 1.0)
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.textAlignment = .center
            pickerLabel?.backgroundColor = .clear
            pickerLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        pickerLabel?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        return pickerLabel!

    }
    
}
