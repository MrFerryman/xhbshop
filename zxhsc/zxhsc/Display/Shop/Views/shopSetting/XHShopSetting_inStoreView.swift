//
//  XHShopSetting_inStoreView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopSetting_inStoreView: UIView {

    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var desciptionL: UILabel!
    
    /// 添加图片点击事件回调
    var addImagesCellClickedClosure: ((_ imagsArr: [String]) -> ())?
    /// 图片点击事件回调
    var imagesViewClickedClosure: ((_ imagesArr: [String], _ clickedIdx: Int) -> ())?
    /// 关闭按钮点击事件回调
    var closeButtonClickedClosure: ((_ index: Int) -> ())?
    
//    var imagesArr: [UIImage] = [] {
//        didSet {
////            collectionView.imagesArr = imagesArr
//        }
//    }
    
    var iconUrlsArr: [String] = [] {
        didSet {
            collectionView.iconUrlsArr = iconUrlsArr
        }
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(desciptionL.snp.bottom).offset(4)
        }
        
        collectionView.limitPagesNum = 9
        collectionView.isScrollEnabled = true
        
        /// 添加图片点击事件回调
        collectionView.addImagesCellClickedClosure = { [weak self] imagesArr in
            self?.addImagesCellClickedClosure?(imagesArr)
        }
        
        /// 图片点击事件回调
        collectionView.imagesViewClickedClosure = { [weak self] images, index in
            self?.imagesViewClickedClosure?(images, index)
        }
        
        /// 关闭按钮点击事件回调
        collectionView.closeButtonClickedClosure = { [weak self] index in
            self?.closeButtonClickedClosure?(index)
        }
    }
    
    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 10)
        layout.itemSize = CGSize(width: 70, height: 70)
        return layout
    }()
    
    private lazy var collectionView: XHSelectImagesCollView = {
        let collectionView: XHSelectImagesCollView = XHSelectImagesCollView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = true
        return collectionView
    }()

}
