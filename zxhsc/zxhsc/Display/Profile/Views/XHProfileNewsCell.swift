//
//  XHProfileNewsCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHProfileNewsCell: UITableViewCell {

    /// cell的collectionViewItem点击回调事件
    var cellCollViewItemClickClosure: ((_ model: XHProfileManageModel, _ index: Int) -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        collectionView.dataSourceArr = XHProfileNewsViewModel().dataSourceArr
        collectionView.isManage = false
        
        // 点击回调
        collectionView.collViewItemClickClosure = { [weak self] model, index in
            self?.cellCollViewItemClickClosure?(model, index)
        }
        
        self.bringSubview(toFront: collectionView)
    }
    
    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: kUIScreenWidth / 4, height: profile_manage_perRowHeight)
        return layout
    }()
    
    private lazy var collectionView: XHProfileCollView = {
        let collectionView: XHProfileCollView = XHProfileCollView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
}
