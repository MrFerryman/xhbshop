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
    
    @IBOutlet weak var rebackImgView: UIImageView!
    
    @IBOutlet weak var plusImgView: UIImageView!
    
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
            
            if sessionGoodsM?.integral != nil || isNineXI_goods == true || is_fu_xiao_goods == true {
                rebackL.isHidden = true
                plusL.isHidden = true
                rebackImgView.isHidden = true
                plusImgView.isHidden = true
                integralL.isHidden = false
                
                if isNineXI_goods == true || is_fu_xiao_goods == true {
                    integralL.text = ""
                }else {
                    let integral = NSString(string: (sessionGoodsM?.integral)!).floatValue
                    integralL.text = "+" + String(format: "%.2f", integral)
                }
            }else {
                rebackL.isHidden = false
                plusL.isHidden = false
                rebackImgView.isHidden = false
                plusImgView.isHidden = false
                integralL.isHidden = true
            }
        }
    }
    
    /// 是否是九玺产品
    var isNineXI_goods: Bool = false
    /// 是否是复消专区
    var is_fu_xiao_goods: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rebackL.backgroundColor = UIColor(patternImage: UIImage(named: "special_Rectangle_red")!)
        addSubview(integralL)
        integralL.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceL)
            make.right.equalTo(self).offset(-3)
        }
    }

    private lazy var integralL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = XHRgbColorFromHex(rgb: 0x53B6FF)
        return label
    }()
}
