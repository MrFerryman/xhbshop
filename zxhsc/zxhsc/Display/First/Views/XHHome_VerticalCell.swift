//
//  XHHome_VerticalCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHome_VerticalCell: UITableViewCell {

    @IBOutlet weak var bigView: UIImageView!
    
    @IBOutlet weak var bigViewWidthCon: NSLayoutConstraint!
    
    @IBOutlet weak var bigViewHeightCon: NSLayoutConstraint!
    
    /// 每个格子的点击事件
    var eachItemClickedClosure: ((_ goodsModel: XHSpecialFavModel) -> ())?
    /// 大图片按钮的点击事件
    var bigImageViewClickedClosure: ((_ bannerModel: XHHomeBannerGoodsModel) -> ())?
    
    /// 数据模型
    var model: XHHomeBannerGoodsModel? {
        didSet {
            if model?.icon != nil {
                bigView.sd_setImage(with: URL(string: XHImageBaseURL + (model?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            collectionView.reloadData()
        }
    }
    
    fileprivate let reuseId_collection = "XHHome_VerticalCell_reuseId_collection"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        setupCollectionView()
        
        // 给大图片视图添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(bigImageViewClicked))
        bigView.addGestureRecognizer(tap)
    }
    
    @objc private func bigImageViewClicked() {
        bigImageViewClickedClosure?(model!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconHeight: CGFloat = self.frame.height - 28
        let iconWidth: CGFloat = iconHeight * 168 / 260
        bigViewHeightCon.constant = iconHeight
        bigViewWidthCon.constant = iconWidth
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.remakeConstraints { (make) in
            make.right.equalTo(bigView.snp.left)
            make.top.left.bottom.equalTo(self)
        }
        
        let iconHeight: CGFloat = 288 * kUIScreenWidth / 375 - 28
        let iconWidth: CGFloat = iconHeight * 168 / 260
        let itemWidth: CGFloat = (kUIScreenWidth - iconWidth - 44) / 2
        let itemHeight: CGFloat = iconHeight / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.register(UINib(nibName: "XHHome_Digital_collCell", bundle: nil), forCellWithReuseIdentifier: reuseId_collection)
    }
    
    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(14, 14, 14, 4)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
}
extension XHHome_VerticalCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // 几个格子
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHHome_Digital_collCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId_collection, for: indexPath) as! XHHome_Digital_collCell
        cell.goodsModel = model?.goodsArr[indexPath.row]
        cell.bannerModel = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eachItemClickedClosure?((model?.goodsArr[indexPath.row])!)
    }
}
