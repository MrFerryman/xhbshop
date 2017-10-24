//
//  XHMarketHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketHeaderView: UIView, SDCycleScrollViewDelegate {

    var dataImgArr: Array<String> = ["home_zhuanti1", "home_banner_2", "home_zhuanti2", "home_banner_2", "home_qiche"]
    
    /// 图片轮播点击事件回调
    var cycleImgViewClickedClosure: ((_ index: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RandomColor()
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 图片轮播器

        addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        cycleImgViewClickedClosure?(index)
    }
    
    private lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: self.bounds, shouldInfiniteLoop: true, imageNamesGroup: self.dataImgArr)
        cycleScrollView?.delegate = self
        cycleScrollView?.pageControlDotSize = CGSize(width: 5, height: 5)
        cycleScrollView?.pageDotColor = .white
        cycleScrollView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView?.scrollDirection = .horizontal
        
        return cycleScrollView!
    }()
}
