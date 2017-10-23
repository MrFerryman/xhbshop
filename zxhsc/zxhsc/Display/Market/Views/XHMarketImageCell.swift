//
//  XHMarketImageCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketImageCell: UITableViewCell {

    /// 图片的点击事件回调
    var imageClickedClosure: ((_ bannerModel: XHClassifyBannerModel) -> ())?
    
    var bannerGoodsImageClickedClosure: ((_ bannerGoodsModel: XHHomeBannerGoodsModel) -> ())?
    
    var isBannerGoods: Bool = false
    
    var bannerModel: XHClassifyBannerModel? {
        didSet {
            if bannerModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (bannerModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage_LONG), options: .progressiveDownload)
            }
        }
    }
    
    var bannerGoodsModel: XHHomeBannerGoodsModel? {
        didSet {
            if bannerGoodsModel?.icon_horizontal != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (bannerGoodsModel?.icon_horizontal)!), placeholderImage: UIImage(named: XHPlaceholdImage_LONG), options: .progressiveDownload)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 图片的点击事件
    @objc private func imageClicked() {
        if isBannerGoods == false {
            imageClickedClosure?(bannerModel!)
        }else {
            bannerGoodsImageClickedClosure?(bannerGoodsModel!)
        }
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        addSubview(imgView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(-4)
        }
    }
    
    // MARK:- 懒加载
    // 图片
    private lazy var imgView: UIImageView = {
       let view = UIImageView()
        view.isUserInteractionEnabled = true
//        view.contentMode = .scaleAspectFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        view.addGestureRecognizer(tap)
        return view
    }()
}
