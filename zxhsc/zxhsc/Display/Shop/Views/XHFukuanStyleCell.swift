//
//  XHFukuanStyleCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHFukuanStyleCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var leftL: UILabel!
    
    @IBOutlet weak var selectedBtn: UIButton!
    
    @IBOutlet weak var icon01: UIImageView!
    
    @IBOutlet weak var icon02: UIImageView!
    
    @IBOutlet weak var marginCon: NSLayoutConstraint!
    
    @IBOutlet weak var widthCon: NSLayoutConstraint!
    
    @IBOutlet weak var leftCon: NSLayoutConstraint!
    
    /// 选中按钮 的点击事件
    var selectedButtonClickedClosure: ((_ model: XHFukuanStyleModel) -> ())?
    
    var zhifuModel: XHFukuanStyleModel? {
        didSet {
            titleL.text = zhifuModel?.title
            selectedBtn.isSelected = (zhifuModel?.isSelected)!
            if zhifuModel?.title == "余额支付" {
                leftL.isHidden = false
            }else {
                leftL.isHidden = true
            }
            
            if zhifuModel?.iconsArr != nil {
                icon01.image = UIImage(named: (zhifuModel?.iconsArr[0]) ?? "")!
                if (zhifuModel?.iconsArr.count) == 2 {
                    icon02.image = UIImage(named: (zhifuModel?.iconsArr[1])!)!
                    marginCon.constant = 5
                    widthCon.constant = 20
                }else {
                    marginCon.constant = 0
                    widthCon.constant = 0
                }
            }
        }
    }
    
    var banlance: CGFloat? {
        didSet {
            if banlance != nil {
                leftL.text = "可用余额: ￥\(banlance!)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectedButtonClicked(_ sender: UIButton) {
        sender.isSelected = true
        zhifuModel?.isSelected = true
        selectedButtonClickedClosure?(zhifuModel!)
    }
}
