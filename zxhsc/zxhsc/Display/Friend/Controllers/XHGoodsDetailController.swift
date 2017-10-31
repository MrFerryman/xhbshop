//
//  XHGoodsDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD
import HUPhotoBrowser
import SSKeychain

class XHGoodsDetailController: UIViewController, UIGestureRecognizerDelegate {

    fileprivate let reuseId_goods = "XHGoodsDetailController_collectionView_CELL_goods"
    fileprivate let reuseId_comment = "XHGoodsDetailController_collectionView_CELL_comment"
    
    var isIntegral: Bool = false
    var is_19_9_goods: Bool = false
    var is_jiu_xi_goods: Bool = false
    var is_fu_xiao_goods: Bool = false
    
    var goodsId: String? {
        didSet {
            loadData()
        }
    }
    
    fileprivate var goodsDetailModel: XHGoodsDetailModel?
    
    /// 收藏ID
    fileprivate var collected_id: String?
    
    /// 选择的属性1
    fileprivate var property1: XHGoodsPropertyModel?
    /// 选择的属性2
    fileprivate var property2: XHGoodsPropertyModel?
    /// 选择的数量
    fileprivate var goodsNum: String?
    
    /// 是否是立即购买
    fileprivate var isMustToBuy: Bool = false
    /// 添加到购物车后返回来的订单在购物车中的ID
    fileprivate var addToShoppingCartBackID: String? {
        didSet {
            let confirmV = XHConfirmOrderController()
            confirmV.isIntegralGoods = self.isIntegral
            confirmV.is_fu_xiao_goods = is_fu_xiao_goods
            confirmV.is_jiu_xi_goods = is_jiu_xi_goods
            let cartModel = XHShoppingCartModel()
            cartModel.id = addToShoppingCartBackID
            cartModel.goods_id = self.goodsDetailModel?.detailData?.goods_id
            cartModel.icon = self.goodsDetailModel?.detailData?.icon
            cartModel.name = self.goodsDetailModel?.detailData?.title
            cartModel.xhb = (self.goodsDetailModel?.detailData?.xhb)!
            cartModel.price = self.goodsDetailModel?.detailData?.price
            cartModel.buyCount = self.goodsNum
            cartModel.property1 = self.property1?.value
            cartModel.property2 = self.property2?.value
            cartModel.tab_Id = property2 == nil ? (property1?.id ?? "0") : property2?.id
            cartModel.integral = "\(String(describing: (self.goodsDetailModel?.detailData?.integral ?? 0)))"
            confirmV.ordersArr = [cartModel]
            
            confirmV.comeFrom = isIntegral == true ? .integral_goods : .shoppingCart
            navigationController?.pushViewController(confirmV, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNav()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(goodsDetailModel?.detailData?.title)
    }
    
    private func loadData() {
        showHud(in: view)
        let paraDict = ["goods_id": (goodsId)!]
        var requestType: XHNetDataType = .getGoodsDetail
        if isIntegral == true, is_19_9_goods == false {
            requestType = .getIntegral_goodsDetail
        }else if isIntegral == true , is_19_9_goods == true {
            requestType = .getIntegral_goodsDetail
        }else if isIntegral == false, is_19_9_goods == false, is_jiu_xi_goods == true {
            requestType = .getIntegral_goodsDetail
        }else if isIntegral == false, is_19_9_goods == false, is_jiu_xi_goods == false, is_fu_xiao_goods == true {
            requestType = .getIntegral_goodsDetail
        }
        
        _ = XHRequest.shareInstance.requestNetData(dataType: requestType, parameters: paraDict, failure: { [weak self] (errorType) in
           self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (sth) in
            self?.hideHud()
            if sth is XHGoodsDetailModel {
                self?.goodsDetailModel = sth as? XHGoodsDetailModel
                self?.bottomView.goodsModel = (sth as? XHGoodsDetailModel)?.detailData
                TalkingData.trackPageBegin(self?.goodsDetailModel?.detailData?.title)
                self?.setupCollectionView()
                self?.collectionView.reloadData()
            }
        })
    }
    
    // MARK:- 收藏商品
    fileprivate func collectedProduct(_ sender: UIButton) {
        
        if judgeIfLogin() == false { return }
        
        showHud(in: view)
        let paraDict = ["spid": (goodsId)!]
        _ = XHRequest.shareInstance.requestNetData(dataType: .addProductCollection, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (sth) in
                self?.hideHud()
                if sth is String {
                    self?.collected_id = sth as? String
                    if (sth as! String) != "商品已经被收藏！！！",  (sth as! String) !=  "请先登录" {
                        sender.startAnimation(animationImgName: "shop_collected")
                        sender.isSelected = true
                        self?.showHint(in: (self?.view)!, hint: "收藏成功")
                    }else {
                        self?.showHint(in: (self?.view)!, hint: sth as! String)
                    }
                }
        })
    }
    
    // MARK:-  取消收藏
    fileprivate func cancelCollectionProduct(_ sender: UIButton) {
        showHud(in: view)
        let paraDict = ["id": collected_id ?? goodsDetailModel?.detailData?.collected_id]
        _ = XHRequest.shareInstance.requestNetData(dataType: .cancelCollection_goods, parameters: paraDict as? [String : String], failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (sth) in
                self?.hideHud()
                if sth is String {
                    if (sth as! String) == "操作成功" {
                        self?.showHint(in: (self?.view)!, hint: "取消成功")
                        sender.isSelected = false
                    }else {
                        self?.showHint(in: (self?.view)!, hint: sth as! String)
                    }
                }
        })
    }
    
    // MARK:- ========= 事件相关 ============
    /// MARK:- 加入购物车事件
    private func addToShoppingCarClicked() {
        
        if judgeIfLogin() == false { return }
        
        // 逻辑判断
        if goodsDetailModel?.havePro != 0, property1 == nil, property2 == nil, goodsNum == nil {
            productPropertyCellClicked()
            return
        }else if goodsDetailModel?.havePro != 0, property1 == nil {
            productPropertyCellClicked()
            return
        }else if goodsNum == nil {
            productPropertyCellClicked()
            return
        }
        
        var paraDict = ["num": goodsNum ?? "1", "spid": (goodsDetailModel?.detailData?.goods_id)!, "adval": "0", "zdval": "0"]
        
        if property1 != nil, property2 == nil {
            paraDict["bqid"] = (property1?.id)!
        }else if property1 != nil, property2 != nil {
            paraDict["bqid"] = (property2?.id)!
        }else {
            paraDict["bqid"] = "0"
        }
        
        XHGoodsDetailViewModel.addGoodsToShoppingCart(paraDict: paraDict, self) { [weak self] (result) in
            let sth = NSString(string: result).integerValue
            
            if sth != 0 {
                if self?.isMustToBuy == true {
                    self?.addToShoppingCartBackID = "\(sth)"
                }else {
                    self?.showHint(in: (UIApplication.shared.keyWindow)!, hint: "已添加至购物车^_^")
                }
            }else {
                self?.showHint(in: (UIApplication.shared.keyWindow)!, hint: result)
                if result == "请重新登陆！" {
                    self?.maskViewTapGesture()
                    let time: TimeInterval = 0.4
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] in
                        let login = XHLoginController()
                        let nav = UINavigationController(rootViewController: login)
                        self?.present(nav, animated: true, completion: nil)
                    }
                }else if result.isEmpty == true {
                    self?.showHint(in: (UIApplication.shared.keyWindow)!, hint: "未知错误~")
                }
            }
        }
    }
    
    /// MARK:- 立即购买事件
    @objc private func buyNowClicked() {
        
        if judgeIfLogin() == false { return }
        
        // 逻辑判断
        if goodsDetailModel?.havePro != 0, property1 == nil, property2 == nil, goodsNum == nil {
            productPropertyCellClicked()
            return
        }else if goodsDetailModel?.havePro != 0, property1 == nil {
            productPropertyCellClicked()
            return
        }else if goodsNum == nil {
            productPropertyCellClicked()
            return
        }
        
        let time: TimeInterval = 0.4
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] in
            
            self?.addToShoppingCarClicked()
        }
    }
    
    // MARK:- 蒙版视图轻点手势事件
    @objc private func maskViewTapGesture() {
        UIView.animate(withDuration: 0.3, animations: {
            self.propertyView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 450)
        }) { (isFinished) in
            self.propertyView.removeFromSuperview()
            self.goodsMaskView.removeFromSuperview()
        }
    }
    
    // MARK:- 分享按钮点击事件
    @objc private func sharedButtonClicked() {
        // 1. 创建分享参数
        let saveImage = UIImage(named: "profile_header_icon")
        
        // 分享文本
        var sharedText: String?
        if goodsDetailModel?.detailData?.title != nil {
            sharedText = "您的好友为您推荐：" + (goodsDetailModel?.detailData?.title)!
        }
        
        // 标题
        let sharedTitle = "循环宝商城商品推荐"
        // url
        let sharedUrl = URL(string: "http://wx2.zxhshop.cn/index.php?m=Product&a=show&id=" + (goodsId)!)
        
        XHSharedManager.sharedInstance.shared(sharedText: sharedText, saveImage: saveImage, sharedUrl: sharedUrl, sharedTitle: sharedTitle)
    }
    
    // MARK:- 商品属性cell的点击事件
    fileprivate func productPropertyCellClicked() {
        UIApplication.shared.keyWindow?.addSubview(goodsMaskView)
        goodsMaskView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
        
        propertyView.isIntegralGoods = isIntegral
        propertyView.is_fu_xiao_goods = is_fu_xiao_goods
        propertyView.is_nine_xi_goods = is_jiu_xi_goods
        propertyView.goodsModel = goodsDetailModel
        propertyView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 450)
        goodsMaskView.addSubview(propertyView)
        UIView.animate(withDuration: 0.3) {  [weak self] in
            self?.propertyView.frame = CGRect(x: 0, y: KUIScreenHeight - 450 * KUIScreenHeight / 667, width: kUIScreenWidth, height: 450 * KUIScreenHeight / 667)
        }

        /// 加入购物车按钮回调事件
        propertyView.addToBuyCarButtonClickedClosure = { [weak self] in
            self?.isMustToBuy = false
            self?.addToShoppingCarClicked()
        }
        
        /// 立即购买按钮回调事件
        propertyView.nowBuyButtonClickedClosure = { [weak self] in
            self?.maskViewTapGesture()
            self?.isMustToBuy = true
            self?.buyNowClicked()
        }
        
        /// 关闭按钮回调事件
        propertyView.closeButtonClosure = { [weak self] in
            self?.maskViewTapGesture()
        }
        
        /// 选择属性回调事件
        propertyView.propertySelectedClosure = { [weak self] property1, property2, goodsNum in
            self?.property1 = property1
            self?.property2 = property2
            self?.goodsNum = "\(goodsNum)"
            self?.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        /// 属性视图中产品图片的点击事件回调
        propertyView.productIconViewClickedClosure = { imgView, icon in
            HUPhotoBrowser.show(from: imgView, withURLStrings: [icon], placeholderImage: UIImage(named: XHPlaceholdImage), at: 0, dismiss: nil)
        }
    }
    
    // MARK:- == 手势事件的代理方法
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: propertyView) == true {
            return false
        }
        return true
    }
    
    // MARK:- ======== 界面布局 ==========
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
        
        collectionView.register(XHGoodsDetailCollCell.self, forCellWithReuseIdentifier: reuseId_goods)
        collectionView.register(XHCommentCollCell.self, forCellWithReuseIdentifier: reuseId_comment)
        
        if isIntegral == false, is_jiu_xi_goods == false, is_fu_xiao_goods == false {
            view.addSubview(bottomView)
            bottomView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(view)
                make.height.equalTo(44)
            }
        }else  {
            view.addSubview(nowBuyButton)
            nowBuyButton.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(view)
                make.height.equalTo(44)
            })
        }
        
        // 立即购买
        bottomView.nowBuyButtonClickedClosure = { [weak self] sender in
            self?.buyNowClicked()
        }
        
        // 添加至购物车
        bottomView.addToBuyCarButtonClickedClosure = { [weak self] sender in
            self?.addToShoppingCarClicked()
        }
        
        // 购物车
        bottomView.buyCarButtonClickedClosure = { [weak self] sender in
            let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            
            if token != nil, userid != nil {
                let shoppingCart = XHShoppingCartController()
                self?.navigationController?.pushViewController(shoppingCart, animated: true)
            }else {
                let login = XHLoginController()
                let nav = XHNavigationController(rootViewController: login)
                self?.present(nav, animated: true, completion: nil)
            }
        }
        
        // 收藏按钮
        bottomView.collectionButtonClickedClosure = { [weak self] sender in
            if sender.isSelected == false {
                self?.collectedProduct(sender)
            }else {
                self?.cancelCollectionProduct(sender)
            }
        }
    }
    
    private func setupNav() {
        let headerView = XHGoodsDetailHeaderView()
        headerView.backgroundColor = .clear
        headerView.frame = CGRect(x: 0, y: 0, width: 120, height: 44)
        navigationItem.titleView = headerView
        
        headerView.titleButtonClickedClosure = { [weak self] sender in
            self?.collectionView.scrollToItem(at: IndexPath(item: sender.tag, section: 0), at: .centeredHorizontally, animated: true)
            
            if sender.tag == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.bottomView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 44)
                    self?.bottomView.alpha = 0
                    self?.nowBuyButton.alpha = 0
                })
            }else if sender.tag == 0 {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.bottomView.frame = CGRect(x: 0, y: KUIScreenHeight - 44, width: kUIScreenWidth, height:  44)
                    self?.bottomView.alpha = 1
                    self?.nowBuyButton.alpha = 1
                })
            }
        }
        
        let sharedtem = UIBarButtonItem(image: UIImage(named: "shop_shared"), style: .plain, target: self, action: #selector(sharedButtonClicked))
        navigationItem.rightBarButtonItem = sharedtem
    }
    
    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: kUIScreenWidth, height: KUIScreenHeight - 64)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var bottomView: XHGoodsDetailBottomView = {
       let view = Bundle.main.loadNibNamed("XHGoodsDetailBottomView", owner: self, options: nil)?.last as! XHGoodsDetailBottomView
        return view
    }()
    
    private lazy var nowBuyButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("立即购买", for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(buyNowClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 蒙版
    fileprivate lazy var goodsMaskView: UIView = {
       let view = UIView()
        view.backgroundColor = XHRgbaColorFromHex(rgb: 0x000000, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapGesture))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        return view
    }()
    
    /// 属性视图
    fileprivate lazy var propertyView: XHGoodsDetail_goodsPropertyView = {
       let view = XHGoodsDetail_goodsPropertyView()
        view.backgroundColor = .white
        return view
    }()

}

extension XHGoodsDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 有几组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 有几行
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell: XHGoodsDetailCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId_goods, for: indexPath) as! XHGoodsDetailCollCell
            cell.isIntegralGoods = isIntegral
            cell.is_nine_xi_goods = is_jiu_xi_goods
            cell.is_fu_xiao_goods = is_fu_xiao_goods
            cell.goodsDetailModel = goodsDetailModel
            if goodsNum != nil {
                cell.selectProperty = "\(property1?.value ?? "")" + " " + "\(property2?.value ?? "")" + " " + "“\(goodsNum ?? "")”"
            }else {
                cell.selectProperty = "\(property1?.value ?? "")" + " " + "\(property2?.value ?? "")" + " " + "\(goodsNum ?? "")"
            }
            
            /// tableViewCell的点击
            cell.goodsTableViewCellClickedClosure = { [weak self] indexPath in
                switch indexPath.section {
                case 1: // 选择商品属性
                    self?.productPropertyCellClicked()
                case 2: // 店铺
                    let shopV = XHBussinessShopController()
                    shopV.shopId = self?.goodsDetailModel?.supplier?.shopId
                    self?.navigationController?.pushViewController(shopV, animated: true)
                default:
                    break
                }
            }
            return cell
        }
        
        let cell: XHCommentCollCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId_comment, for: indexPath) as! XHCommentCollCell
        cell.controller = self
        cell.goodsId = goodsDetailModel?.detailData?.goods_id
        return cell
    }
}
