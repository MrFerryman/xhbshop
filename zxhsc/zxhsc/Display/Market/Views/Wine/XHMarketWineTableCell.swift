//
//  XHMarketWineTableCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketWineTableCell: UITableViewCell {

    /// 酒水item的点击事件回调
    var wineItemClickClosure: ((_ goodsModel: XHSpecialFavModel) -> ())?
    
    var goodsArr: [XHSpecialFavModel]? = [] {
        didSet {
            setupUI()
            collectionView.goodsArr = goodsArr
        }
    }
    
    fileprivate let collMargin: CGFloat = 12
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collectionView.collectionViewCellClickClosure = { [weak self] model  in
            self?.wineItemClickClosure?(model)
        }
    }
    
    // MARK:- 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, self.collMargin, 0, self.collMargin)
        
        layout.itemSize = CGSize(width: 95, height: 149)
        return layout
    }()
    
    private lazy var collectionView: XHMarketWineCollView = {
        let collectionView: XHMarketWineCollView = XHMarketWineCollView(frame: CGRect.zero, collectionViewLayout: self.layout)
        return collectionView
    }()

}
