//
//  XHHomeAreaCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeAreaCell: UITableViewCell {

    @IBOutlet weak var rebateImgView: UIImageView!  // 返利专区
    
    @IBOutlet weak var carImgView: UIImageView! // 汽车专区
    
    @IBOutlet weak var houseImgView: UIImageView! // 房产专区
    
    /// 5倍专区点击回调
    var fiveRebateImgClickClosure: (() -> ())?
    
    /// 汽车专区点击回调
    var carImgClickClosure: (() -> ())?
    
    /// 房产专区点击回调
    var houseImgClickClosure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        // 返利
        let rebateTap = UITapGestureRecognizer(target: self, action: #selector(rebateImgTap))
        rebateImgView.addGestureRecognizer(rebateTap)
        // 汽车
        let carTap = UITapGestureRecognizer(target: self, action: #selector(carImgTap))
        carImgView.addGestureRecognizer(carTap)
        
        // 房产
        let houseTap = UITapGestureRecognizer(target: self, action: #selector(houseImgTap))
        houseImgView.addGestureRecognizer(houseTap)
    }
    
    // MARK:- 点击事件
    // MARK:- 5倍返利专区
    @objc private func rebateImgTap() {
        fiveRebateImgClickClosure?()
    }
    
    // MARK:- 汽车专区
    @objc private func carImgTap() {
        carImgClickClosure?()
    }
    
    // MARK:- 房地产专区
    @objc private func houseImgTap() {
        houseImgClickClosure?()
    }

}
