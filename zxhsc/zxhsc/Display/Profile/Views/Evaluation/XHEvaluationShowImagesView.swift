//
//  XHEvaluationShowImagesView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHEvaluationShowImagesView: UIView {

    var dataImgArr: Array<String> = [] {
        didSet {
            var imgsArr: Array<String> = []
            for model in dataImgArr {
                imgsArr.append(XHImageBaseURL + model)
            }
            cycleScrollView.autoScrollTimeInterval = 3.0
            cycleScrollView.imageURLStringsGroup = imgsArr
            cycleScrollView.autoScroll = true
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = XHRgbaColorFromHex(rgb: 0x000000, alpha: 0.8)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(kUIScreenWidth)
        }
    }
    
    private lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: self.bounds, shouldInfiniteLoop: true, imageNamesGroup: self.dataImgArr)
        cycleScrollView?.pageControlDotSize = CGSize(width: 5, height: 5)
        cycleScrollView?.autoScroll = false
        cycleScrollView?.pageDotColor = .white
        cycleScrollView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated   
        cycleScrollView?.scrollDirection = .horizontal
        
        return cycleScrollView!
    }()
}
