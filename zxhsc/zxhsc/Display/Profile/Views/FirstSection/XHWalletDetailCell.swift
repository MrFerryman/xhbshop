//
//  XHWalletDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWalletDetailCell: UITableViewCell {

    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var subtitleL: UILabel!
    
    var walletModel: XHWalletModel? {
        didSet {
            titleL.text = (walletModel?.jylx)! + (walletModel?.zffs)!
            if walletModel?.fuhao == "-" {
                 detailL.textColor = XHRgbColorFromHex(rgb: 0x50e35d)
            }else {
                 detailL.textColor = XHRgbColorFromHex(rgb: 0xea2000)
            }
            detailL.text = (walletModel?.fuhao)! + (walletModel?.sum)!
            
            subtitleL.text = walletModel?.time
        }
    }
    
    var withdrawModel: XHWithdrawModel? {
        didSet {
            
           titleL.text = withdrawModel?.status
            if withdrawModel?.status_count == 0 {
                titleL.text = (withdrawModel?.reason)! + "处理中..."
            }else if withdrawModel?.status_count == 1 {
                titleL.text = (withdrawModel?.reason)! + "成功"
            }else if withdrawModel?.status_count == 2 {
                titleL.text = (withdrawModel?.reason)! + "失败"
            }
            
             detailL.textColor = XHRgbColorFromHex(rgb: 0x50e35d)
            detailL.text = "-" + (withdrawModel?.money)!
            
            subtitleL.text = withdrawModel?.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        titleL.text = "539个循环宝参与分配"
//        subtitleL.text = "2017-08-02 10:26:50"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
