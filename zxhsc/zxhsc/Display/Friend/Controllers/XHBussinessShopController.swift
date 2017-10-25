//
//  XHBussinessShopController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/3.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain
import HUPhotoBrowser

class XHBussinessShopController: UIViewController {

    fileprivate let reuseId_firstSection = "XHBussinessShopController_firstSection"
    fileprivate let reuseId_goods = "XHBussinessShopController_goods"
    fileprivate let reuseId_headerView = "XHBussinessShopController_headerView"
    
    fileprivate let viewName = "商家店铺页面"
    
    fileprivate var shopDetailModel: XHShopDetailModel?
    fileprivate var goodsArr: [XHGoodsListModel] = []
    
    var isMyShop: Bool = false
    
    var shopId: String? {
        didSet {
            loadShopDetail()
            loadGoodsList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
        if isMyShop == false {
            view.addSubview(bottomBtn)
            bottomBtn.snp.makeConstraints({ (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(tableView.snp.bottom)
                make.height.equalTo(44)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadShopDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 数据请求
    private func loadShopDetail () {
        showHud(in: view)
        let paraDict = ["dmd_id": shopId!]
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            if sth is XHShopDetailModel {
                self?.shopDetailModel = sth as? XHShopDetailModel
                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }else {
                if (sth as! String) == "请重新登陆！" {
                    self?.hideHud()
                    let loginV = XHLoginController()
                    let nav = UINavigationController(rootViewController: loginV)
                    self?.present(nav, animated: true, completion: nil)
                }
                self?.showHint(in: (self?.view)!, hint: sth as! String)
            }
        }
    }
    
    // MARK:- 请求商品列表
    private func loadGoodsList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let paraDict = ["dmd_id": shopId!]
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopDetail_goodsList, parameters: paraDict, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.loadGoodsList()
        }, success: { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHGoodsListModel] {
                self?.goodsArr = sth as! [XHGoodsListModel]
                self?.tableView.reloadSections([1], with: .automatic)
                if (sth as! [XHGoodsListModel]).count > 0 {
                    self?.footerL.text = "没有更多内容了~"
                }else {
                    self?.footerL.text = "该商家暂无在售商品~"
                }
            }
        })
    }
    
    // MARK:- 添加店铺收藏
    fileprivate func addCollection_shop(_ sender: UIButton) {
        showHud(in: view)
        let paraDict = ["spid": shopId!]
        _ = XHRequest.shareInstance.requestNetData(dataType: .addShopCollection, parameters: paraDict, failure: { [weak self] (errorType) in
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
                    sender.isSelected = true
                    sender.startAnimation(animationImgName: "shop_collected")
                    sender.setTitle("已收藏", for: .normal)
                    sender.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 6)
                    self?.showHint(in: (self?.view)!, hint: "收藏成功")
                }
            }
        })
    }
    
    // 使头部图片可拉伸
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = headerImageView.frame // 头部图片的frame
        if scrollView.contentOffset.y < 0 {
            frame.origin.y = 0
            // 图片的高度加上偏移的值
            frame.size.height = 155 - scrollView.contentOffset.y
        }else {
            frame.origin.y = -scrollView.contentOffset.y
        }
        headerImageView.frame = frame
    }

    // MARK:- 设置头部可拉伸图片
    fileprivate func setHeaderDragableIamge() {
        headerImageView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 155)
        bgView.addSubview(headerImageView)
        
        tableView.backgroundView = bgView
        tableView.tableHeaderView = headerView
    }
    
    @objc private func shopInnerCustom() {
        let innerCustom = XHShopInnerCustomController()
        innerCustom.shopModel = shopDetailModel
        navigationController?.pushViewController(innerCustom, animated: true)
    }

    // MARK:- ======= 界面相关
    // MARK:- 设置tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if isMyShop == false {
                make.left.right.equalTo(view)
                make.bottom.equalTo(-44)
            }else {
                make.left.right.bottom.equalTo(view)
            }
            make.top.equalTo(64)
        }
        
        tableView.register(UINib(nibName: "XHBussFirstSectionCell", bundle: nil), forCellReuseIdentifier: reuseId_firstSection)
        
        tableView.register(UINib(nibName: "XHShopGoodsCell", bundle: nil), forCellReuseIdentifier: reuseId_goods)
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseId_headerView)
        
        footerView.addSubview(footerL)
        footerL.snp.makeConstraints { (make) in
            make.center.equalTo(footerView)
        }
        tableView.tableFooterView = footerView
        
        setHeaderDragableIamge()
    }
    
    // MARK:- 设置导航栏
    private func setupNav() {
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        title = "店铺"
    }

    // MARK:- ========= 懒加载
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // 头部可拉伸图片
    fileprivate lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "shop_headerIcon"))
        headerImageView.backgroundColor = .white
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    // 头部可拉伸图片 背景视图
    fileprivate lazy var bgView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 155))
    
    fileprivate lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 155)
        return view
    }()
    
    private lazy var footerView: UIView = {
       let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 40)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var footerL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.text = "没有更多内容了~"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("店内消费", for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(shopInnerCustom), for: .touchUpInside)
        return btn
    }()
}

extension XHBussinessShopController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return goodsArr.count
        }
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHBussFirstSectionCell = tableView.dequeueReusableCell(withIdentifier: reuseId_firstSection, for: indexPath) as! XHBussFirstSectionCell
            cell.shopModel = shopDetailModel
            
            cell.collectionButtonClickedClosure = { [weak self] sender in
                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
                if  token != nil, userid != nil {
                    if sender.isSelected == true {
                        self?.showHint(in: (self?.view)!, hint: "您已收藏过该店铺~")
                    }else {
                        self?.addCollection_shop(sender)
                    }
                }else {
                    let login = XHLoginController()
                    let nav = XHNavigationController(rootViewController: login)
                    self?.present(nav, animated: true, completion: nil)
                }
            }
            
            cell.callPhoneNumberClickedClosure = { [weak self] shopModel in
                
                if XHRegularManager.isCalidateMobileNumber(num: (shopModel.phoneNum)!) == true {
                    let phoneStr = "tel:\(String(describing: (shopModel.phoneNum)!))"
                    let callWebView = UIWebView()
                    callWebView.loadRequest(URLRequest(url: URL(string: phoneStr)!))
                    self?.view.addSubview(callWebView)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "该店铺暂无相关联系电话", confirmTitle: "确定", confirmComplete: nil)
                }
            }
            
            cell.iconViewClickedClosure = { iconView, iconString in
                HUPhotoBrowser.show(from: iconView, withURLStrings: [iconString], placeholderImage: UIImage(named: XHPlaceholdImage), at: 0, dismiss: nil)
            }
            
            return cell
        }else {
            let cell: XHShopGoodsCell = tableView.dequeueReusableCell(withIdentifier: reuseId_goods, for: indexPath) as! XHShopGoodsCell
            cell.goodsModel = goodsArr[indexPath.row]
            cell.shopModel = shopDetailModel
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let model = goodsArr[indexPath.row]
            let goodsV = XHGoodsDetailController()
            goodsV.goodsId = model.goods_id
            navigationController?.pushViewController(goodsV, animated: true)
        }
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 254
        default:
            return 100
        }
    }
    
    // 头部尾部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0.01
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId_headerView)
            
            let bgView = UIView()
            bgView.backgroundColor = .white
            headerView?.addSubview(bgView)
            bgView.snp.makeConstraints({ (make) in
                make.edges.equalTo(headerView!)
            })
            
            let headerImg = UIImageView(image: UIImage(named: "shop_goods"))
            headerView?.addSubview(headerImg)
            headerImg.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerView!)
                make.left.equalTo(16)
                make.width.height.equalTo(15)
            })
            
            let headerTitleL = UILabel()
            headerTitleL.textColor = XHRgbColorFromHex(rgb: 0x333333)
            headerTitleL.text = "商品列表"
            headerTitleL.font = UIFont.systemFont(ofSize: 14)
            headerView?.addSubview(headerTitleL)
            headerTitleL.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerImg)
                make.left.equalTo(headerImg.snp.right).offset(4)
            })
            
            let line = UIView()
            line.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
            headerView?.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(headerView!)
                make.height.equalTo(1)
            })
            return headerView
        }
        
        return nil
    }
}
