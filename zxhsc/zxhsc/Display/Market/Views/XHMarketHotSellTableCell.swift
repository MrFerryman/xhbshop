//
//  XHMarketHotSellTableCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketHotSellTableCell: UITableViewCell {

    /// collectionView的点击事件回调
    var hotSellCollViewClickClosure: ((_ indexPath: IndexPath) -> ())?
    
    /// 间距
    fileprivate let collMargin: CGFloat = 10
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 界面相关
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            //            make.left.right.equalTo(self)
            //            make.top.equalTo(10)
            //            make.bottom.equalTo(-10)
            make.edges.equalTo(self)
        }
        
        
    }
    
    // MARK:- 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = self.collMargin
        layout.minimumLineSpacing = self.collMargin
        layout.sectionInset = UIEdgeInsetsMake(0, market_hotSell_margin, 0, market_hotSell_margin)
        
        layout.itemSize = CGSize(width: (kUIScreenWidth - market_hotSell_margin * 3) / 2, height: market_hotsell_perItemHeight)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        //        collectionView.backgroundColor = .white
        return collectionView
    }()

}
