//
//  XHProfileCollView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHProfileCollView: UICollectionView {

    // 数据源
    var dataSourceArr: Array<XHProfileManageModel>? = []

    // 点击回调
    var collViewItemClickClosure: ((_ model: XHProfileManageModel, _ index: Int) -> ())?
    
    var isLogin: Bool = false
    var isManage: Bool = true
    
    fileprivate let collReuseIdentifier: String = "XHProlieManageCell_collectionView_Reuse"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        
        register(UINib(nibName: "XHManageCollViewCell", bundle: nil), forCellWithReuseIdentifier: collReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

extension XHProfileCollView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLogin == false, isManage == true {
            return (dataSourceArr?.count)! - 1
        }else {
            return (dataSourceArr?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collReuseIdentifier, for: indexPath) as! XHManageCollViewCell
        cell.manageModel = dataSourceArr?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: XHProfileManageModel = (dataSourceArr?[indexPath.row])!
        collViewItemClickClosure?(model, indexPath.row)
    }
    
}
