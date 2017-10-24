//
//  XHFriendFirstSectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHFriendFirstSectionCell: UITableViewCell {

    // 是否展开
    var isOpen: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                if self.isOpen == true { // 应该是打开
                    self.rotateButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }else {
                    self.rotateButton.imageView?.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    var classesArr: Array<XHFriendClassModel> = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // 旋转按钮的点击事件
    var rotateButtonClosure: (() -> ())?
    
    // 类型item的点击回调
    var collectionViewItemClickedClosure: ((_ classModel: XHFriendClassModel) -> ())?
    
    fileprivate let reuseId_collectionView = "XHFriendFirstSectionCell_collectionView"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 可旋转按钮的点击事件
    @objc fileprivate func rotateButtonClicked(_ sender: UIButton) {
        rotateButtonClosure?()
    }

    private func setupCollectionView() {
        
        collectionView.register(UINib(nibName: "XHFriendClassCollCell", bundle: nil), forCellWithReuseIdentifier: reuseId_collectionView)
        
        // 底部视图
        contentView.addSubview(bottomImageView)
        bottomImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(32)
        }
        
        // 可旋转按钮
        bottomImageView.addSubview(rotateButton)
        rotateButton.snp.makeConstraints { (make) in
            make.center.equalTo(bottomImageView)
            make.width.height.equalTo(32)
        }
        
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.bottom.equalTo(bottomImageView.snp.top)
        }
    }
    
    // MARK:- ====== 懒加载 =========
    // collectionView
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: kUIScreenWidth / 4, height: 79)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // 底部视图
    private lazy var bottomImageView: UIImageView = {
       let imgView = UIImageView(image: UIImage(named: "coalition_flod"))
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    
    // 可旋转按钮
    private lazy var rotateButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "coalition_arrow"), for: .normal)
        btn.addTarget(self, action: #selector(rotateButtonClicked(_:)), for: .touchUpInside)
        return btn
    }()

}

extension XHFriendFirstSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // 几个格子
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHFriendClassCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId_collectionView, for: indexPath) as! XHFriendClassCollCell
        cell.classModel = classesArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = classesArr[indexPath.row]
        collectionViewItemClickedClosure?(model)
    }
}
