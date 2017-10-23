//
//  XHClassifyCollView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHClassifyCollView: UICollectionView {

    /// 是否是推荐专区
    var isPushArea: Bool = true
    /// 是否是特惠专区
    var isSpecialZone: Bool = false
    
    /// 不是推荐专区时的组标题
   var secTitleStr: String = ""
    
    /// cell的点击事件回调
    var collectionViewCellClickClosure: ((_ indexPath: IndexPath) -> ())?
    /// 头部轮播图片点击事件回调
    var topCycleImageClickedClosure: ((_ bannerModel: XHClassifyBannerModel) -> ())?
    /// 推荐精选推荐item点击事件回调
    var recommendItemClickedCosure: ((_ recommendModel: XHClassifyRecommendModel) -> ())?
    /// 热门分类item点击事件回调
    var hotClassesItemClickedClosure: ((_ hotModel: XHClassifyHotModel) -> ())?
    /// 特惠专区item点击事件回调
    var specialZoneItemClickedClosure: ((_ specialModel: XHSpecialFavModel) -> ())?
    /// 其他子类item点击事件回调
    var otherClassChildItemClickedClosure: ((_ otherSpecialModel: XHClassifyChildModel) -> ())?
    
    /// 头部轮播模型数组
    var bannersArr: [XHClassifyBannerModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    
    /// 推荐专区数据数组
    var recommendArr: [XHClassifyRecommendModel]? = [] {
        didSet {
            self.reloadSections([0])
        }
    }
    
    /// 热门分类数据数组
    var hotClassArr: [XHClassifyHotModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    
    /// 特惠专区模型数组
    var specialModelArr: [XHSpecialFavModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    
    /// 其他子类模型数组
    var otherChildModelArr: [XHClassifyChildModel]? = [] {
        didSet {
            self.reloadData()
        }
    }
    
    fileprivate let collReuseIdentifier: String = "XHClassifyCollView_collectionView_Reuse"
    fileprivate let collReuseIdentifier_special: String = "XHClassifyCollView_collectionView_Reuse_special"
    fileprivate let reuseId_headerView: String = "XHClassifyCollView_collectionHeaderView_reuseView"
    fileprivate let reuseId_reuseView: String = "XHClassifyCollView_collectionHeaderView_reuseView_perSection"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .white
        delegate = self
        dataSource = self
        bounces = true
        register(UINib(nibName: "XHClassifyCollCell", bundle: nil), forCellWithReuseIdentifier: collReuseIdentifier)
        register(UINib(nibName: "XHSpecialFavCollCell", bundle: nil), forCellWithReuseIdentifier: collReuseIdentifier_special)
        
        register(XHClassifyCollReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_headerView)
        
        register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_reuseView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate lazy var secHeaderTitleL: UILabel = {
        let titleL = UILabel()
        titleL.textColor = XHRgbColorFromHex(rgb: 0x333333)
        titleL.font = UIFont.systemFont(ofSize: 13)
        return titleL
    }()
}

extension XHClassifyCollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isPushArea == true {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPushArea == true {
            switch section {
            case 0:
                return (recommendArr?.count)!
            default:
                return (hotClassArr?.count)!
            }
        }else if isSpecialZone == true {
            return (specialModelArr?.count)!
        }else {
            return (otherChildModelArr?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isSpecialZone == true {
            let cell: XHSpecialFavCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: collReuseIdentifier_special, for: indexPath) as! XHSpecialFavCollCell
            
            cell.specialModel = specialModelArr?[indexPath.row]
            return cell
        }
        
        let cell: XHClassifyCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: collReuseIdentifier, for: indexPath) as! XHClassifyCollCell
        if isPushArea == true {
            if indexPath.section == 1 {
                cell.hotModel = hotClassArr?[indexPath.row]
            }else {
                cell.recomModel = recommendArr?[indexPath.row]
            }
        }else {
            cell.childModel = otherChildModelArr?[indexPath.row]
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {


        if isPushArea == true, indexPath.section == 0 {
            
            let headerView: XHClassifyCollReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_headerView, for: indexPath) as! XHClassifyCollReusableView
            headerView.dataImgArr = bannersArr!
            
            // banner的点击事件回调
            headerView.cycleImgViewClickedClosure = { [weak self] bannerModel in
                self?.topCycleImageClickedClosure?(bannerModel)
            }
            return headerView
        }else {
            let reuseView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_reuseView, for: indexPath)
            reuseView.addSubview(secHeaderTitleL)
            secHeaderTitleL.snp.makeConstraints { (make) in
                make.left.equalTo(11)
                make.centerY.equalTo(reuseView)
            }
            
            if isPushArea == true {
                if indexPath.section == 0 {
                    secHeaderTitleL.text = "精选推荐"
                }else if indexPath.section == 1 {
                    secHeaderTitleL.text = "热门分类"
                }
            }else {
                secHeaderTitleL.text = secTitleStr
            }
            
            return reuseView
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPushArea == true {
            if indexPath.section == 0 { // 精选推荐
                let reModel = recommendArr?[indexPath.row]
                recommendItemClickedCosure?(reModel!)
            }else {
                let hotM = hotClassArr?[indexPath.row]
                hotClassesItemClickedClosure?(hotM!)
            }
        }else if isSpecialZone == true {
            let specialModel = specialModelArr?[indexPath.row]
            specialZoneItemClickedClosure?(specialModel!)
        }else {
            let childModel = otherChildModelArr?[indexPath.row]
            otherClassChildItemClickedClosure?(childModel!)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isPushArea == true {
            if section == 0 {
                return  CGSize(width: kUIScreenWidth - 95, height: 170)
            }else {
                return  CGSize(width: kUIScreenWidth - 95, height: 46)
            }
        }else {
            return  CGSize(width: kUIScreenWidth - 95, height: 46)
        }
    }
}
