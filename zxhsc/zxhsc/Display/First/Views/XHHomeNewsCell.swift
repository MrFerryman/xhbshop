//
//  XHHomeNewsCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit


class XHHomeNewsCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    
    var noticeModel: XHHomeNoticeModel? {
        didSet {
            if noticeModel?.detail?.title != nil {
                let att = CCZTrotingAttribute()
                let matt = NSMutableAttributedString(string: (noticeModel?.detail?.title)!)
                att.attribute = matt
//                walkerL.addText((noticeModel?.detail?.title)!)
//                walkerL.walk()
                walkerL.text = noticeModel?.detail?.title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
//        walkerL.pause = 2.0
//        walkerL.type = .default
//        walkerL.rate = .RateNormal

        contentView.addSubview(walkerL)
        walkerL.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(contentView)
            make.left.equalTo(lineView.snp.right).offset(3)
        }
        
//        walkerL.walk()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    private lazy var walkerL: CCZTrotingLabel = CCZTrotingLabel()
    private lazy var walkerL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
