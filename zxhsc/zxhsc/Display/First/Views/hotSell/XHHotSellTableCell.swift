//
//  XHHotSellTableCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHotSellTableCell: UITableViewCell {

    /// collectionView的点击事件回调
    var hotSellCollViewClickClosure: ((_ goodsModel: XHSpecialFavModel) -> ())?
    
    /// 数据源
    var dataSourceArr: [XHSpecialFavModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 间距
    fileprivate let collMargin: CGFloat = 10
    fileprivate let collReuseIdentifier: String = "XHHomeHotSellCollView_collectionView_Reuse"
    
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
            make.edges.equalTo(self)
        }
        
        collectionView.register(UINib(nibName: "XHHomeSellCollCell", bundle: nil), forCellWithReuseIdentifier: self.collReuseIdentifier)
    }
    
    // MARK:- 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = self.collMargin
        layout.minimumLineSpacing = self.collMargin
        layout.sectionInset = UIEdgeInsetsMake(self.collMargin, self.collMargin, -self.collMargin, self.collMargin)
        
        let with = (kUIScreenWidth - self.collMargin * 3) / 2
        let height = with + 46
        layout.itemSize = CGSize(width: with, height: height)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)

        collectionView.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()

}

extension XHHotSellTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHHomeSellCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: collReuseIdentifier, for: indexPath) as! XHHomeSellCollCell
        cell.goodsModel = dataSourceArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hotSellCollViewClickClosure?(dataSourceArr[indexPath.row])
    }
}
