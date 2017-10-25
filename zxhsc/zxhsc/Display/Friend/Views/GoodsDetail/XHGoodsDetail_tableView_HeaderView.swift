//
//  XHGoodsDetail_tableView_HeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetail_tableView_HeaderView: UIView, SDCycleScrollViewDelegate {

    var dataImgArr: Array<String> = [] {
        didSet {
            setupUI()
            
            var imgsArr: Array<String> = []
            for str in dataImgArr {
                imgsArr.append(XHImageBaseURL + str)
            }
            
            cycleScrollView.imageURLStringsGroup = imgsArr
        }
    }
    var cycleScrollViewDidClickedClosure: ((_ index: Int, _ imageView: SDCycleScrollView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // 图片轮播器
        addSubview(cycleScrollView)
        cycleScrollView.autoScrollTimeInterval = 3.0
        cycleScrollView.backgroundColor = .white
        cycleScrollView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        cycleScrollViewDidClickedClosure?(index, cycleScrollView)
    }
    
    private lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: self.bounds, shouldInfiniteLoop: true, imageNamesGroup: self.dataImgArr)
        cycleScrollView?.delegate = self
        cycleScrollView?.pageControlDotSize = CGSize(width: 5, height: 5)
        cycleScrollView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView?.scrollDirection = .horizontal
        
        return cycleScrollView!
    }()
    
}
