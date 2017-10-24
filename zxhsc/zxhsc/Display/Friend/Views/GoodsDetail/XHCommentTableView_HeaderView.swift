//
//  XHCommentTableView_HeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCommentTableView_HeaderView: UIView {

    /// 评价按钮点击事件回调
    var commentButtonClickedClosure: ((_ sender: UIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(allButton)
        allButton.isSelected = true
        addSubview(goodButton)
        addSubview(mediumButton)
        addSubview(badButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        allButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        goodButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(allButton.snp.right).offset(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        mediumButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(goodButton.snp.right).offset(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        
        badButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(mediumButton.snp.right).offset(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    // MARK:- ======= 事件相关 ========
    /// 全部按钮点击事件
    @objc private func styleButtonClicked(_ sender: UIButton) {
        sender.isSelected = true
        switch sender.tag {
        case 0:
            goodButton.isSelected = false
            mediumButton.isSelected = false
            badButton.isSelected = false
        case 1:
            allButton.isSelected = false
            mediumButton.isSelected = false
            badButton.isSelected = false
        case 2:
            allButton.isSelected = false
            goodButton.isSelected = false
            badButton.isSelected = false
        case 3:
            allButton.isSelected = false
            goodButton.isSelected = false
            mediumButton.isSelected = false
        default:
            break
        }
        
        commentButtonClickedClosure?(sender)
    }
    
    // MARK:- ====== 懒加载 ========
    /// 全部
    private lazy var allButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("全部", for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x666666), for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .selected)
        btn.setBackgroundImage(UIImage(named: "shop_comment_unselected"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "shop_comment_selected"), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 0
        btn.addTarget(self, action: #selector(styleButtonClicked(_:)), for: .touchUpInside)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    /// 好评
    private lazy var goodButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("好评", for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x666666), for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .selected)
        btn.setBackgroundImage(UIImage(named: "shop_comment_unselected"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "shop_comment_selected"), for: .selected)
        btn.tag = 1
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(styleButtonClicked(_:)), for: .touchUpInside)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    
    /// 中评
    private lazy var mediumButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("中评", for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x666666), for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .selected)
        btn.setBackgroundImage(UIImage(named: "shop_comment_unselected"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "shop_comment_selected"), for: .selected)
        btn.tag = 2
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(styleButtonClicked(_:)), for: .touchUpInside)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
    /// 差评
    private lazy var badButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("差评", for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x666666), for: .normal)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .selected)
        btn.setBackgroundImage(UIImage(named: "shop_comment_unselected"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "shop_comment_selected"), for: .selected)
        btn.tag = 3
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(styleButtonClicked(_:)), for: .touchUpInside)
        btn.adjustsImageWhenHighlighted = false
        return btn
    }()
}
