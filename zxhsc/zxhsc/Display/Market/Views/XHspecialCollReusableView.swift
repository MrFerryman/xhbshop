//
//  XHspecialCollReusableView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHspecialCollReusableView: UICollectionReusableView {
    
    var imgName: String? {
        didSet {
            if imgName != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + imgName!), placeholderImage: UIImage(named: XHPlaceholdImage_LONG), options: .progressiveDownload)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgView.image = UIImage(named: "market_banner_health")
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    private lazy var imgView: UIImageView = UIImageView()
}
