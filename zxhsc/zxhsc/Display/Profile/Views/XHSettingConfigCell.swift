//
//  XHSettingConfigCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSettingConfigCell: UITableViewCell {

    var title: String? {
        didSet {
            titleL.text = title
        }
    }
    
    var isImgCell = false {
        didSet {
            if isImgCell == true {
                imgView.isHidden = false
                contentL.isHidden = true
            }else {
                imgView.isHidden = true
                contentL.isHidden = false
            }
        }
    }
    
    var contentStr: String? {
        didSet {
            if isImgCell == true {
                let url = URL(string: XHImageBaseURL + contentStr!)
                self.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }else {
                contentL.text = contentStr
                contentL.textColor = XHRgbColorFromHex(rgb: 0x333333)
            }
        }
    }
    
    var img: UIImage? {
        didSet {
            imgView.image = img
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleL)
        contentView.addSubview(imgView)
        contentView.addSubview(contentL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleL.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(16)
        }
        
        imgView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(self).offset(-30)
            make.width.height.equalTo(50)
        })
        
        contentL.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-30)
            make.centerY.equalTo(contentView)
        }
    }
    
    // MARK:- 懒加载
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var contentL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0xefefef)
        label.text = "未设置"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var imgView: UIImageView = {
       let view =  UIImageView(image: UIImage(named: "profile_headerImg_icon"))
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        return view
    }()
}
