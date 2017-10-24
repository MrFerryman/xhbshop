//
//  XHMarketWineCollView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketWineCollView: UICollectionView {

    /// cell的点击事件回调
    var collectionViewCellClickClosure: ((_ model: XHSpecialFavModel) -> ())?
    
    var goodsArr: [XHSpecialFavModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    
    fileprivate let collReuseIdentifier: String = "XHMarketWineCollView_collectionView_Reuse"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        delegate = self
        dataSource = self
        bounces = true
        
        register(UINib(nibName: "XHMarketWineCollCell", bundle: nil), forCellWithReuseIdentifier: collReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XHMarketWineCollView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (goodsArr?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHMarketWineCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: collReuseIdentifier, for: indexPath) as! XHMarketWineCollCell
        cell.goodsModel = goodsArr?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionViewCellClickClosure?((goodsArr?[indexPath.row])!)
    }
}
