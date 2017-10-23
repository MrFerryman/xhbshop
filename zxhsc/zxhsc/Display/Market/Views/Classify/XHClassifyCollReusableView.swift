//
//  XHClassifyCollReusableView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHClassifyCollReusableView: UICollectionReusableView, SDCycleScrollViewDelegate {
    
    var dataImgArr: Array<XHClassifyBannerModel> = [] {
        didSet {
            setupUI()
            
            var imgsArr: Array<String> = []
            for model in dataImgArr {
                imgsArr.append(XHImageBaseURL + model.icon!)
            }
            cycleScrollView.autoScrollTimeInterval = 3.0
            cycleScrollView.imageURLStringsGroup = imgsArr
            cycleScrollView.autoScroll = true
        }
    }
    
    /// 图片轮播点击事件回调
    var cycleImgViewClickedClosure: ((_ bannerModel: XHClassifyBannerModel) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(cycleScrollView)
        var width: CGFloat = 0
        if kUIScreenWidth == 320 {
            width = kUIScreenWidth - 85
        }else {
            width = kUIScreenWidth - 95
        }
        
        let height = (width - 24) * 165 / 375
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.top.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(height)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(cycleScrollView.snp.bottom).offset(24)
        }
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let model = dataImgArr[index]
        cycleImgViewClickedClosure?(model)
    }
    
    private lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView: SDCycleScrollView = SDCycleScrollView(frame: self.bounds, delegate: self, placeholderImage: UIImage(named: XHPlaceholdImage_LONG))
        cycleScrollView.infiniteLoop = true
        
        cycleScrollView.pageControlDotSize = CGSize(width: 5, height: 5)
        cycleScrollView.pageDotColor = .white
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView.scrollDirection = .horizontal
        
        return cycleScrollView
    }()
    
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.text = "精选推荐"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
