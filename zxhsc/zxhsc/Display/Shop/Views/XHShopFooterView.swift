//
//  XHShopFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopFooterView: UIView {

    @IBOutlet weak var goInShopBtn: UIButton! // 进入店铺
    
    @IBOutlet weak var orderManageBtn: UIButton! // 商家订单
    
    @IBOutlet weak var downloadBtn: UIButton! // 物料下载
    
    @IBOutlet weak var shopManageBtn: UIButton! // 店铺管理
    
    @IBOutlet weak var userOrderBtn: UIButton! // 用户订单
    
    
    @IBOutlet weak var returnSalesBtn: UIButton! // 退货订单
    
    
    @IBOutlet weak var goToFukuanBtn: UIButton!
    
    @IBOutlet weak var resonL: UILabel!
    
    var shopModel: XHMyShopModel? {
        didSet {
            switch (shopModel?.shop_status)! {
            case 0:
                goToFukuanBtn.setTitle("正在审核中...", for: .normal)
            case 2:
                goToFukuanBtn.setTitle("审核未通过", for: .normal)
            default:
                goToFukuanBtn.setTitle("商家付款", for: .normal)
            }
        }
    }
    
    var reason: String? {
        didSet {
            resonL.isHidden = false
            resonL.text = "未通过审核原因: " + (reason ?? "")
        }
    }
    
    var footerButtonClickedClosure: ((_ sender: UIButton) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        goToFukuanBtn.layer.cornerRadius = 6
        goToFukuanBtn.layer.masksToBounds = true
        
        resonL.isHidden = true
    }
  
    // MARK:- 进入店铺按钮点击事件
    @IBAction func goInShopBtnClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    // MARK:- 商家订单按钮点击事件
    @IBAction func orderManageBtnClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    // MARK:- 物料下载按钮点击事件
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    // MARK:- 店铺管理按钮点击事件
    @IBAction func shopManageBtnClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 || shopModel?.shop_status == 2 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    // MARK:- 用户订单按钮点击事件
    @IBAction func userOrderButtonClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    // MARK:- 退货订单按钮点击事件
    @IBAction func salesReturnButtonClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    
    
    @IBAction func goToFukuanBtnClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            footerButtonClickedClosure?(sender)
        }
    }
    

}
