//
//  XHHomePlaneView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomePlaneView: UIView {

    var infoString: String? {
        didSet {
            fontL.text = infoString
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 布局界面
    private func setupUI() {
        
        addSubview(fontL)
        fontL.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(kUIScreenWidth / 6)
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
            make.right.equalTo(fontL).offset(16)
        }
        
        self.bringSubview(toFront: fontL)
    }
    
    /// 图片
    private lazy var imgView: UIImageView = UIImageView(image: UIImage(named: "home_plane"))
    private lazy var fontL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

}
