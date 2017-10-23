//
//  XHTableFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHTableFooterView: UIView {
    
    var title: String? {
        didSet {
            fontL.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(fontL)
        addSubview(leftLine)
        addSubview(rightLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fontL.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        leftLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(16)
            make.right.equalTo(fontL.snp.left).offset(-5)
            make.height.equalTo(0.5)
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-16)
            make.left.equalTo(fontL.snp.right).offset(5)
            make.height.equalTo(0.5)
        }
    }
    
    // label
    private lazy var fontL: UILabel = {
       let label = UILabel()
        label.text = "上拉会有更多精彩内容..."
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        return label
    }()

    // 左边线
    private lazy var leftLine: UIView = {
       let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xcccccc)
        return view
    }()
    
    /// 右边线
    private lazy var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xcccccc)
        return view
    }()
}
