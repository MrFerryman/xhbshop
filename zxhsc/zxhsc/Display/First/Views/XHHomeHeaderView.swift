//
//  XHHomeHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeHeaderView: UIView, SDCycleScrollViewDelegate {
    
    /// item点击事件回调
    var cycleViewItemClickedClosure: ((_ model: XHClassifyBannerModel) -> ())?
    
    var dataImgArr: Array<XHClassifyBannerModel> = [] {
        didSet {
            
            cycleScrollView.backgroundColor = .white
            let banner = XHClassifyBannerModel()
            dataImgArr.insert(banner, at: 0)
            cycleScrollView.localizationImageNamesGroup = dataImgArr
            cycleScrollView.autoScrollTimeInterval = 3.0
            cycleScrollView.autoScroll = true
            setupUI()
        }
    }
    
    var circulationModel: XHCirculationModel? {
        didSet {
            cycleScrollView.localizationImageNamesGroup = dataImgArr
            cycleScrollView.autoScrollTimeInterval = 3.0
            cycleScrollView.autoScroll = true
        }
    }
    
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
        if index != 0 {
            cycleViewItemClickedClosure?(dataImgArr[index])
        }
    }
    
    func customCollectionViewCellClass(for view: SDCycleScrollView!) -> AnyClass! {
        return XHHeaderCycleCollView.self
    }
    
    func setupCustomCell(_ cell: UICollectionViewCell!, for index: Int, cycleScrollView view: SDCycleScrollView!) {
        let customCell: XHHeaderCycleCollView = cell as! XHHeaderCycleCollView
        customCell.index = index
        customCell.model = circulationModel
        if index == 0 {
            customCell.bgImgView.image = UIImage(named: "home_banner_1")
        }else {
            customCell.bgImgView.image = UIImage(named: XHPlaceholdImage_LONG)
            if dataImgArr[index].icon != nil {
                customCell.bgImgView.sd_setImage(with: URL(string: XHImageBaseURL + (dataImgArr[index].icon)!), placeholderImage: UIImage(named: XHPlaceholdImage_LONG), options: .progressiveDownload)
            }
        }
    }
    
    private lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: self.bounds, delegate: self, placeholderImage: UIImage(named: XHPlaceholdImage_LONG))
        cycleScrollView?.delegate = self
        cycleScrollView?.pageControlDotSize = CGSize(width: 5, height: 5)
        cycleScrollView?.pageDotColor = .white
        cycleScrollView?.autoScrollTimeInterval = 3.0
        cycleScrollView?.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        cycleScrollView?.scrollDirection = .horizontal
        
        return cycleScrollView!
    }()
}

class XHHeaderCycleCollView: UICollectionViewCell {
    
    var index: Int? {
        didSet {
            setupFirstView(index: index!)
        }
    }
    
    var model: XHCirculationModel? {
        didSet {
            indexNumL.text = model?.index
            bussinessNumL.text = model?.shopNum
            personNumL.text = model?.memberCount
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFirstView(index: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFirstView(index: Int) {
        contentView.addSubview(bgImgView)
        bgImgView.isUserInteractionEnabled = true
        bgImgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        
        if index == 0 {
            
            contentView.addSubview(indexL)
            addSubview(indexNumL)
            addSubview(bussinessL)
            addSubview(bussinessNumL)
            addSubview(personL)
            addSubview(personNumL)
            
            indexL.alpha = 1
            indexL.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(40)
            }
            
            indexNumL.alpha = 1
            indexNumL.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(indexL.snp.bottom).offset(5)
            }
            
            bussinessL.alpha = 1
            bussinessL.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.left).offset(60)
                make.bottom.equalTo(-30)
            }
            
            bussinessNumL.alpha = 1
            bussinessNumL.snp.makeConstraints { (make) in
                make.centerX.equalTo(bussinessL)
                make.bottom.equalTo(bussinessL.snp.top).offset(-3)
            }
            
            personL.alpha = 1
            personL.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.snp.right).offset(-60)
                make.bottom.equalTo(-30)
            }
            
            personNumL.alpha = 1
            personNumL.snp.makeConstraints { (make) in
                make.centerX.equalTo(personL)
                make.bottom.equalTo(personL.snp.top).offset(-3)
            }
        }else {
            indexL.alpha = 0
            indexNumL.alpha = 0
            bussinessL.alpha = 0
            bussinessNumL.alpha = 0
            personL.alpha = 0
            personNumL.alpha = 0
        }
    }
    
    
    // MARK:- 懒加载
    lazy var bgImgView: UIImageView = UIImageView(image: UIImage(named: "home_banner_1"))
    
    // 今日循环指数
    private lazy var indexL: UILabel = {
        let label = UILabel()
        label.text = "今日循环指数"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // 循环指数数值
    private lazy var indexNumL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "--"
        return label
    }()
    
    // 循环商家
    private lazy var bussinessL: UILabel = {
        let label = UILabel()
        label.text = "循环商家"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // 循环商家数值
    private lazy var bussinessNumL: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    // 循环使者
    private lazy var personL: UILabel = {
        let label = UILabel()
        label.text = "循环使者"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // 循环使者数据
    private lazy var personNumL: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
}
