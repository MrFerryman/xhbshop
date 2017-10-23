//
//  XHOpenShopFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOpenShopFooterView: UIView {

    @IBOutlet weak var branchView: UIView!
    
    @IBOutlet weak var personnalView: UIView!
    
    @IBOutlet weak var openBranchBtn: UIButton!
    
    @IBOutlet weak var openPersonnalBtn: UIButton!
    
    @IBOutlet weak var explainL: UILabel!
    
    @IBOutlet weak var explainBtn: UIButton!
    
    @IBOutlet weak var openBtn: UIButton!
    
    /// 店铺类型 0 - 品牌店 1 - 个人店
    fileprivate var shopStyle: Int?
    
    /// 说明文字点击事件回调
    var explainLabelTapGestureClosure: (() -> ())?
    
    /// 立即开通按钮点击事件回调
    var openButtonClickedClosure: ((_ shopStyle: Int?) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        explainBtn.isSelected = true
        openBtn.layer.cornerRadius = 8
        openBtn.layer.masksToBounds = true
        explainL.attributedText = NSAttributedString(string: explainL.text!, attributes: [NSAttributedStringKey.underlineStyle: 1])
        let tap = UITapGestureRecognizer(target: self, action: #selector(explainLableTap))
        explainL.addGestureRecognizer(tap)
        let bTap = UITapGestureRecognizer(target: self, action: #selector(openBranchBtnClicked(_:)))
        branchView.addGestureRecognizer(bTap)
        
//        let pTap = UITapGestureRecognizer(target: self, action: #selector(openPersonalBtnClicked(_:)))
//        personnalView.addGestureRecognizer(pTap)
    }
    @IBAction func openBranchBtnClicked(_ sender: UIButton) {
        openBranchBtn.isSelected = true
//        openPersonnalBtn.isSelected = false
        shopStyle = 0
    }
    @IBAction func openPersonalBtnClicked(_ sender: UIButton) {
//        openPersonnalBtn.isSelected = true
        openBranchBtn.isSelected = false
        shopStyle = 1
    }

    @IBAction func explainBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            openBtn.isEnabled = true
        }else {
            openBtn.isEnabled = false
        }
    }
    
    @IBAction func openBtnClicked(_ sender: UIButton) {
        openButtonClickedClosure?(shopStyle)
    }
    
    @objc private func explainLableTap() {
        explainLabelTapGestureClosure?()
    }
}
