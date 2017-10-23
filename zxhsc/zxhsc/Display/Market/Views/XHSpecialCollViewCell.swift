//
//  XHSpecialCollViewCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSpecialCollViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView! // 图片

    @IBOutlet weak var titleL: UILabel! // 产品标题
    
    @IBOutlet weak var priceL: UILabel! // 价格
    
    @IBOutlet weak var rebackL: UILabel! // 返利
    
    @IBOutlet weak var plusL: UILabel! // 倍数
    
    var sessionGoodsM: XHSpecialFavModel? {
        didSet {
            if sessionGoodsM?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (sessionGoodsM?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = sessionGoodsM?.title
            
            if sessionGoodsM?.price != nil {
                priceL.text = "￥" + (sessionGoodsM?.price)!
            }
            
            if sessionGoodsM?.xhbStr != nil {
                let xhb = NSString(string: (sessionGoodsM?.xhbStr)!).floatValue
                let xhbStr = String(format: "%.3f", xhb)
                rebackL.attributedText = XHRichLabel(frame: CGRect.zero).richLableWithImage(" \(String(describing: xhbStr))", fontSize: 10, isShowColor: false)
            }else {
                rebackL.attributedText = XHRichLabel(frame: CGRect.zero).richLableWithImage(" \(String(describing: (sessionGoodsM?.xhb)!))", fontSize: 10, isShowColor: false)
            }
            
            if sessionGoodsM?.timesStr != nil {
                plusL.text = "\(String(describing: (sessionGoodsM?.timesStr)!))" + "倍"
            }else {
                plusL.text = "\(String(describing: (sessionGoodsM?.times)!))" + "倍"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rebackL.backgroundColor = UIColor(patternImage: UIImage(named: "special_Rectangle_red")!)
    }

}
