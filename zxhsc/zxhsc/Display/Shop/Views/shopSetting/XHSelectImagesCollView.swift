//
//  XHSelectImagesCollView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSelectImagesCollView: UICollectionView {

    /// 添加图片点击事件回调
    var addImagesCellClickedClosure: ((_ imagsArr: [String]) -> ())?
    /// 图片点击事件回调
    var imagesViewClickedClosure: ((_ imagesArr: [String], _ clickedIdx: Int) -> ())?
    /// 关闭按钮点击事件回调
    var closeButtonClickedClosure: ((_ index: Int) -> ())?
    
    fileprivate let reuseId = "XHSelectImagesCollView_collectionView"
    fileprivate let reuseId_add = "XHSelectImagesCollView_collectionView_add"
    
    var iconUrlsArr: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    var limitPagesNum: Int = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId_add)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 关闭按钮点击事件
    @objc fileprivate func imagesButtonClicked(_ sender: UIButton) {
        closeButtonClickedClosure?(sender.tag)
    }

}
extension XHSelectImagesCollView: UICollectionViewDelegate, UICollectionViewDataSource {
    // 有几组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 有几行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if iconUrlsArr.count < limitPagesNum {
            return iconUrlsArr.count + 1
        }
        return limitPagesNum
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if iconUrlsArr.count <= limitPagesNum, indexPath.row < iconUrlsArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
            
            let imgView = UIImageView()
            cell.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }

            let closeButton = UIButton(type: .custom)
            closeButton.tag = indexPath.row
            closeButton.setImage(UIImage(named: "shop_setting_close"), for: .normal)
            closeButton.addTarget(self, action: #selector(imagesButtonClicked(_:)), for: .touchUpInside)
            cell.contentView.addSubview(closeButton)
            closeButton.snp.makeConstraints({ (make) in
                make.top.right.equalTo(cell.contentView)
                make.width.height.equalTo(20)
            })
            
            imgView.sd_setImage(with: URL(string: XHImageBaseURL + iconUrlsArr[indexPath.row]), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId_add, for: indexPath)
            let imgView = UIImageView()
            cell.contentView.addSubview(imgView)
            imgView.snp.makeConstraints { (make) in
                make.edges.equalTo(cell.contentView)
            }
            imgView.image = UIImage(named: "evaluation_addImage")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if iconUrlsArr.count <= limitPagesNum, indexPath.row < iconUrlsArr.count {
            imagesViewClickedClosure?(iconUrlsArr, indexPath.row)
        }else {
            addImagesCellClickedClosure?(iconUrlsArr)
        }
    }
}
