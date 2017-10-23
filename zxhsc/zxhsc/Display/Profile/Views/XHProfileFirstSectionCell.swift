//
//  XHProfileFirstSectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHProfileFirstSectionCell: UITableViewCell {

    @IBOutlet weak var walletButton: UIButton! // 钱包明细
    @IBOutlet weak var circleButton: UIButton! // 循环宝明细
    
    @IBOutlet weak var banlance: UILabel! // 余额
    
    @IBOutlet weak var balanceView: UIView!
    
    @IBOutlet weak var incomeL: UILabel! // 收益
    
    @IBOutlet weak var withdrawL: UILabel! // 提现
    
    @IBOutlet weak var excitationL: UILabel! // 正在激励
    
    
    @IBOutlet weak var addL: UILabel! // 今日新增
    
    
    @IBOutlet weak var totalGet: UILabel! // 累计获得
    
    
    /// 各item之间的间距
    @IBOutlet var margin: [NSLayoutConstraint]!
    
    var earningModel: XHUserEarningModel? {
        didSet {
            banlance.text = String(describing: (earningModel?.balance)!)
            incomeL.text = String(describing: (earningModel?.accu_earning)!)
            withdrawL.text = earningModel?.accu_withdraw ?? "0"
            if earningModel?.xhb_now != nil {
                excitationL.text = String(describing: (earningModel?.xhb_now)!)
            }
            
            if earningModel?.today_add != nil {
                addL.text = String(describing: (earningModel?.today_add)!)
            }
            
            totalGet.text = earningModel?.accu_xhb ?? "0"
        }
    }
    /// 钱包明细按钮点击事件回调
    var walletDetailButtonClickedClosure: (() -> ())?
    
    /// 循环宝明细按钮点击事件回调
    var circleDetailButtonClickedClosure: (() -> ())?
    
    /// 钱包余额手势点击事件回调
    var balanceViewTapGestureClosure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        walletButton.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 8)
        circleButton.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 8)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(balanceViewTapGesture))
        balanceView.addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if kUIScreenWidth == 320 {
            margin[0].constant = 20
            margin[1].constant = 20
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- 钱包余额视图点击事件
    @objc private func balanceViewTapGesture() {
        balanceViewTapGestureClosure?()
    }
    
    // MARK:- 钱包明细按钮点击事件
    @IBAction func walletButtonClicked(_ sender: UIButton) {
        walletDetailButtonClickedClosure?()
    }
    
    // MARK:- 循环宝明细按钮点击事件
    @IBAction func circleButtonClicked(_ sender: UIButton) {
        circleDetailButtonClickedClosure?()
    }
    
}
