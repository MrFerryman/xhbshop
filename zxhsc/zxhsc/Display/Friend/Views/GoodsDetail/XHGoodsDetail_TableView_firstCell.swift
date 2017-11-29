//
//  XHGoodsDetail_TableView_firstCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetail_TableView_firstCell: UITableViewCell {

    @IBOutlet weak var productNameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var returnL: UILabel!
    @IBOutlet weak var brandImgView: UIImageView!
    
    @IBOutlet weak var integralPriceL: UILabel!
    
    
    var isIntegralGoods: Bool = false {
        didSet {
            integralPriceL.isHidden = !isIntegralGoods
        }
    }
    
    var is_jiu_xi_goods: Bool = false {
        didSet {
            if is_jiu_xi_goods == true {
                integralPriceL.isHidden = true
            }
        }
    }
    
    var is_fu_xiao_goods: Bool = false {
        didSet {
            if is_fu_xiao_goods == true {
                integralPriceL.isHidden = true
            }
        }
    }
    
    var detailModel: XHGoodsListModel? {
        didSet {
            productNameL.text = detailModel?.title
            
            var bei: CGFloat = 1
            
            if detailModel?.price != nil {
                priceL.text = "￥" + (detailModel?.price)!
                
                let xhbF = CGFloat((detailModel?.xhb)!)
                let priceF = ((detailModel?.price)! as NSString).floatValue
                bei = xhbF / CGFloat(priceF) * 100.0
            }
            
            if detailModel?.xhb != nil {
                returnL.attributedText = returnL.richLableWithRedImage(" \(String(describing: (detailModel?.xhb)!))(\(String(format: "%.1f", bei))倍)", fontSize: 10, imgName: "shop_yuanbao")
            }
            
            if detailModel?.listprice != nil, detailModel?.listprice != detailModel?.price {
                addSubview(listPriceL)
                listPriceL.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(priceL)
                    make.left.equalTo(integralPriceL.snp.right).offset(3)
                })
                
                let attri = NSMutableAttributedString(string: "￥" +  (detailModel?.listprice)!)
                let strLength = NSString(string: (detailModel?.listprice)!).length
                attri.addAttributes([NSAttributedStringKey.strikethroughStyle: 1], range: NSRange(location: 1, length: strLength))
                listPriceL.attributedText = attri
            }
            
            if isIntegralGoods == true {
                integralPriceL.isHidden = false
                if detailModel?.integral != nil {
                    priceL.text = "积分(循环宝):" + "\((detailModel?.integral)!)"
                }else {
                    priceL.text = "积分(循环宝):"
                }
                
                if detailModel?.price != nil {
                    let price = NSString(string: (detailModel?.price)!).floatValue
                    if price == 0.0 {
                        integralPriceL.text = ""
                    }else {
                        integralPriceL.text = "+￥" + "\(price)"
                    }
                }
                returnL.text = ""
            }else if is_jiu_xi_goods == true || is_fu_xiao_goods == true {
                returnL.attributedText = nil
            }
        }
    }
    
    var bussinessShop: XHBussinessShopModel? {
        didSet {
            if bussinessShop?.isBranch == "1" {
                brandImgView.isHidden = false
            }else {
                brandImgView.isHidden = true
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        integralPriceL.layer.cornerRadius = 3
        integralPriceL.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private lazy var listPriceL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
}
