//
//  XHGoodsDetail_showPropertyCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SKTagView

class XHGoodsDetail_showPropertyCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var tagListView: SKTagView!
    
    /// tagView的点击事件回调
    var tagViewDidClickClosure: ((_ index: UInt, _ tagView: SKTagView, _ tageStrings: [XHGoodsPropertyModel], _ indexPath: IndexPath) -> ())?
    
    var tagStrings: [XHGoodsPropertyModel]? {
        didSet {
            tagListView.removeAllTags()
            
            for idx in 0 ..< Int((tagStrings?.count)!) {
                let propertyModel = tagStrings?[idx]
                var tag = SKTag()
                if propertyModel?.value != nil {
                    tag = SKTag(text: (propertyModel?.value)!)
                }
                
                tag.cornerRadius = 6
                tag.font = UIFont.systemFont(ofSize: 12)
                tag.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                tag.textColor = XHRgbColorFromHex(rgb: 0x333333)
                tag.bgColor = XHRgbColorFromHex(rgb: 0xeeeeee)
                
                if idx == 0, selectedStr == nil {
                    tag.textColor = XHRgbColorFromHex(rgb: 0xffffff)
                    tag.bgColor = XHRgbColorFromHex(rgb: 0xea2000)
                }
                
                let stock = NSString(string: (propertyModel?.stock)!).integerValue
                if stock == 0 {
                    tag.textColor = XHRgbColorFromHex(rgb: 0xaaaaaa)
                    tag.enable = false
                }else {
                    tag.enable = true
                }
                
                if propertyModel?.value == selectedStr {
                    tag.textColor = XHRgbColorFromHex(rgb: 0xffffff)
                    tag.bgColor = XHRgbColorFromHex(rgb: 0xea2000)
                }
                
                tagListView.addTag(tag)
            }
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            titleL.text = "属性" + String(describing: (indexPath?.row)! + 1)
        }
    }
    
    
    var selectedStr: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        tagListView.preferredMaxLayoutWidth = kUIScreenWidth - 20
        tagListView.padding = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0)
        tagListView.lineSpacing = 12
        tagListView.interitemSpacing = 8
        
        tagListView.didTapTagAtIndex = { [weak self] idx, tagView in
            self?.tagViewDidClickClosure?(idx, tagView!, (self?.tagStrings)!, (self?.indexPath)!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
