//
//  XHClassifyController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import PYSearch
import MJRefresh
import SSKeychain

class XHClassifyController: UIViewController {

    // MARK:- 私有属性
    fileprivate let reuseId_left = "XHClassifyController_reuseId_left"
    fileprivate let viewName = "类目页"
    
    fileprivate var classesListArr: Array<XHClassifyModel> = []
    fileprivate var recommendPage: Int = 0
    fileprivate var cancelRequest: XHCancelRequest?
    fileprivate var currentClassId: String?
    
    /// 推荐专区数组
    fileprivate var bannersArr: [XHClassifyBannerModel] = []
    fileprivate var recommendArr: [XHClassifyRecommendModel] = []
    fileprivate var hotArr: [XHClassifyHotModel] = []
    fileprivate var childClassArr: [XHClassifyChildModel] = []
    
    fileprivate var isSpecial: Bool = false {
        didSet {
            setItemSize()
        }
    }
    
    fileprivate var isRecommend: Bool = true
    
    fileprivate let collMargin: CGFloat = 11
    
    deinit {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        NotificationCenter.default.removeObserver(self)
        hideHud()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: classifyListPath) != nil {
            classesListArr = NSKeyedUnarchiver.unarchiveObject(withFile:classifyListPath) as! Array<XHClassifyModel>
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: cl_bannerPath) != nil {
            bannersArr = NSKeyedUnarchiver.unarchiveObject(withFile:cl_bannerPath) as! Array<XHClassifyBannerModel>
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: cl_recommendPath) != nil {
            recommendArr = NSKeyedUnarchiver.unarchiveObject(withFile:cl_recommendPath) as! Array<XHClassifyRecommendModel>
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: cl_hotPath) != nil {
            hotArr = NSKeyedUnarchiver.unarchiveObject(withFile:cl_hotPath) as! Array<XHClassifyHotModel>
        }

        // 设置tableView
        setupTableView()
        
        leftTableView.reloadData()
        rightCollectionView.reloadData()
        
        loadClassesList()
       loadReZoneData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: NSNotification.Name(rawValue: noti_name_jumpToClassRow), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default
        setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 通知事件
    @objc private func notification(_ sender: Notification) {
        let userInfo = sender.userInfo?["row"] as? String
        var index: Int = 0
        for i in 0 ..< classesListArr.count {
            if classesListArr[i].title == userInfo {
                index = i
            }
        }
        leftTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
        tableView(leftTableView, didSelectRowAt: IndexPath(row: index, section: 0))
    }
    
    // MARK:- 加载 推荐专区 数据
    fileprivate func loadReZoneData() {
        rightCollectionView.isSpecialZone = false
        loadRecommendZone_banner()
        loadRecommendZone_recommend()
        loadRecommendZone_hotClass()
    }
    
    // MARK:- 数据加载
    private func loadClassesList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getClassifyList, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.loadClassesList()
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHClassifyModel] {
                self?.classesListArr = sth as! [XHClassifyModel]
                self?.leftTableView.reloadData()
                let indexPath =  IndexPath(item: 0, section: 0)
                self?.leftTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            }
        }
    }
    
    // MARK:- 推荐专区 banner数据加载
    fileprivate func loadRecommendZone_banner() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getRecommend_banner, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHClassifyBannerModel] {
                self?.rightCollectionView.bannersArr = sth as? [XHClassifyBannerModel]
                self?.rightCollectionView.reloadData()
            }
        })
    }
    
    // MARK:- 推荐专区 推荐数据加载
    fileprivate func loadRecommendZone_recommend() {
        showHud(in: view)
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getRecommend_recommendData, failure: { [weak self] (errorType) in
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
                if sth is [XHClassifyRecommendModel] {
                    self?.recommendArr = sth as! [XHClassifyRecommendModel]
                    self?.rightCollectionView.recommendArr = self?.recommendArr
                }
        })
    }
    
    // MARK:- 推荐专区 热门分类加载
    fileprivate func loadRecommendZone_hotClass() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getRecommend_hotClass, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (sth) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if sth is [XHClassifyHotModel] {
                    self?.rightCollectionView.hotClassArr?.removeAll()
                    self?.hotArr = sth as! [XHClassifyHotModel]
                    self?.rightCollectionView.hotClassArr = self?.hotArr
                }
        })
    }
    
    // MARK:- 特惠专区
    fileprivate func getSpecialZoneData() {
        showHud(in: view)
        recommendPage += 1
        let paraDict = ["typeid": "53", "page": "\(recommendPage)"]
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getSpecialFavData, parameters: paraDict, failure: { [weak self] (errorType) in
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
            if self?.rightCollectionView.mj_footer != nil {
                if (sth as! [XHSpecialFavModel]).count == 0 {
                    self?.rightCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self?.rightCollectionView.mj_footer.endRefreshing()
                }
            }
            if sth is [XHSpecialFavModel] {
                self?.rightCollectionView.specialModelArr?.append(contentsOf: (sth as! [XHSpecialFavModel]))
                self?.rightCollectionView.isSpecialZone = true
                self?.rightCollectionView.reloadData()
            }
        })
    }
    
    // MARK:- 其他子类数据获取
    fileprivate func getOtherChildClassesData() {
        recommendPage += 1
//        cancelRequest?.cancelRequest()
        showHud(in: view)
        let paraDict = ["type_id": currentClassId!, "page": "\(recommendPage)"]
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getClassifyChildData, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            if self?.rightCollectionView.mj_footer != nil {
                self?.rightCollectionView.mj_footer.endRefreshing()
            }
        }, success: { [weak self] (sth) in
            self?.hideHud()
            if self?.recommendPage == 1 {
                self?.rightCollectionView.otherChildModelArr?.removeAll()
            }
            if self?.rightCollectionView.mj_footer != nil {
                if (sth as! [XHClassifyChildModel]).count == 0 {
                    self?.rightCollectionView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self?.rightCollectionView.mj_footer.endRefreshing()
                }
            }
            if sth is [XHClassifyChildModel] {
                self?.rightCollectionView.otherChildModelArr?.append(contentsOf: sth as! [XHClassifyChildModel])
                self?.rightCollectionView.isSpecialZone = false
                self?.rightCollectionView.reloadData()
            }
            
            if self?.recommendPage == 1, self?.rightCollectionView.otherChildModelArr?.count != 0 {
                self?.rightCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            
            if (sth as! [XHClassifyChildModel]).count == 0 {
                self?.showHint(in: (self?.view)!, hint: "暂无更多数据~")
            }
        })
        
    }

    // MARK:- ========= 事件相关 =============
    // MARK:- 搜索按钮点击事件
    @objc private func searchButtonClicked() {
        XHSearchManager.instance.pushSearchViewController(targetVc: self, placeholdStr: "请输入商品或品牌关键字", isAnimation: true) { (searchVc, searchBar, textString) in
        }
        XHSearchManager.instance.searchResultGoodsDetailItemClickedClosure = { [weak self] model in
            let goodsDetailV = XHGoodsDetailController()
            self?.setupChildViewController()
            goodsDetailV.goodsId = model.id
            self?.navigationController?.pushViewController(goodsDetailV, animated: true)
        }
    }
    
    // MARK:- 购物车按钮
    @objc private func buyCarClick() {
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        if token != nil, userid != nil {
            let car = XHShoppingCartController()
            setupChildViewController()
            navigationController?.pushViewController(car, animated: true)
        }else {
            let login = XHLoginController()
            let nav = XHNavigationController(rootViewController: login)
            present(nav, animated: true, completion: nil)
        }
    }
    
    fileprivate func setupChildViewController() {
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        tabBarController?.tabBar.isHidden = true
    }

    // MARK:- ========= 界面相关 ============
    // MARK:- 设置导航栏
    private func setupNav() {
        navigationItem.title = "全部分类"
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item

        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        
        // 消息
        let  rightItem = UIBarButtonItem(image:  UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchButtonClicked))
        navigationItem.rightBarButtonItem = rightItem
        
        // 购物车
        let carImg = UIImage(named: "market_buycar")?.withRenderingMode(.alwaysOriginal)
        let  leftItem = UIBarButtonItem(image: carImg, style: .plain, target: self, action: #selector(buyCarClick))
        navigationItem.leftBarButtonItem = leftItem
        if shoppingCartGoodsNum != 0 {
            leftItem.showBadge(with: .redDot, value: 4, animationType: .scale)
        }
    }
    
    // MARK:- 刷新
    @objc private func refresh() {
        if isSpecial == true {
            getSpecialZoneData()
        }else {
            getOtherChildClassesData()
        }
    }
    
    // MARK:- 设置tableview
    private func setupTableView() {
        // 设置左侧
        setupLeftTableView()
        
        // 设置右侧
        setupRigthCollectionView()
    }
    
    private func setupLeftTableView() {
        view.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(view)
            make.width.equalTo(85)
        }
        
        leftTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_left)
    }
    
    private func setupRigthCollectionView() {
        setItemSize()
        
        view.addSubview(rightCollectionView)
        rightCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(leftTableView.snp.right)
            make.right.equalTo(view)
            make.bottom.equalTo(-44)
            make.top.equalTo(view).offset(64)
        }
        
        // 头部轮播图片点击事件回调
        rightCollectionView.topCycleImageClickedClosure = { [weak self] bannerModel in
            self?.setupChildViewController()
            switch (bannerModel.type)! {
            case 1:
                let specialV = XHSpecialViewController()
                specialV.sessionId = bannerModel.id
                specialV.title = bannerModel.title
                self?.navigationController?.pushViewController(specialV, animated: true)
            case 2:
                let goodsDetailV = XHGoodsDetailController()
                goodsDetailV.goodsId = bannerModel.id
                self?.navigationController?.pushViewController(goodsDetailV, animated: true)
            case 3:
                let shopV = XHBussinessShopController()
                shopV.shopId = bannerModel.id
                self?.navigationController?.pushViewController(shopV, animated: true)
            case 6:
                let webView = XHWebViewController()
                webView.urlStr = "http://" + (bannerModel.httpUrl ?? "")
                self?.navigationController?.pushViewController(webView, animated: true)
            default:
                break
            }
        }
        
        // 精选推荐item点击事件回调
        rightCollectionView.recommendItemClickedCosure = { [weak self] recoModel in
            self?.setupChildViewController()
            switch (recoModel.type)! {
            case 1:
                let specialV = XHSpecialViewController()
                specialV.sessionId = recoModel.id
                specialV.title = recoModel.title
                self?.navigationController?.pushViewController(specialV, animated: true)
            case 2:
                let goodsDetailV = XHGoodsDetailController()
                goodsDetailV.goodsId = recoModel.id
                self?.navigationController?.pushViewController(goodsDetailV, animated: true)
            case 3:
                let shopV = XHBussinessShopController()
                shopV.shopId = recoModel.id
                self?.navigationController?.pushViewController(shopV, animated: true)
            default:
                break
            }
        }
        
        // 热门分类item点击事件回调
        rightCollectionView.hotClassesItemClickedClosure = { [weak self] hotModel in
            self?.setupChildViewController()
            let hotVc = XHHotClassifyViewController()
            hotVc.type_id = hotModel.id
            self?.navigationController?.pushViewController(hotVc, animated: true)
        }
        
        /// 特惠专区item点击事件
        rightCollectionView.specialZoneItemClickedClosure = { [weak self] specialModel in
            self?.setupChildViewController()
            let goodsDetailV = XHGoodsDetailController()
            goodsDetailV.goodsId = specialModel.id
            self?.navigationController?.pushViewController(goodsDetailV, animated: true)
        }
        
        /// 其他分类item点击事件
        rightCollectionView.otherClassChildItemClickedClosure = { [weak self] childModel in
            self?.setupChildViewController()
            let hotVc = XHHotClassifyViewController()
            hotVc.type_id = childModel.id
            self?.navigationController?.pushViewController(hotVc, animated: true)
        }
    }
    
    private func setItemSize() {
        var width: CGFloat = 0
        
        if kUIScreenWidth == 320 {
            width = kUIScreenWidth - 85
        }else {
            width = kUIScreenWidth - 95
        }
        let height = (kUIScreenWidth - width) * 165 / 375
        
        layout.headerReferenceSize = CGSize(width: width, height: height)
        
        var itemWidth: CGFloat = (width - 46) / 3
        var itemHeight: CGFloat = itemWidth * 113 / 79
        if kUIScreenWidth == 320 {
            itemHeight = itemHeight + 30
            if self.isSpecial == true {
                itemHeight = itemHeight + 15
                itemWidth = itemWidth + 30
            }
        }
        
        if self.isSpecial == true {
            itemHeight = itemHeight + 30
        }
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        if isRecommend != true {
            
            rightCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
        }else {
            rightCollectionView.mj_footer = nil
        }
        
    }
    
    // MARK:-  ========== 懒加载 ==========
    // 左侧tableView
    fileprivate lazy var leftTableView: UITableView = {
       let tablView = UITableView(frame: CGRect.zero, style: .plain)
        tablView.delegate = self
        tablView.dataSource = self
        tablView.rowHeight = 45
        tablView.separatorColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)
        tablView.separatorInset = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: -30)
        return tablView
    }()
    
    // 右侧的collectionView
    // MARK:- 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = self.collMargin
        layout.minimumLineSpacing = self.collMargin
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(0, self.collMargin, 0, self.collMargin)
        
        return layout
    }()
    
    fileprivate lazy var rightCollectionView: XHClassifyCollView = {
        let collectionView: XHClassifyCollView = XHClassifyCollView(frame: CGRect.zero, collectionViewLayout: self.layout)
        return collectionView
    }()
}
extension XHClassifyController: UITableViewDelegate, UITableViewDataSource {
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesListArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_left, for: indexPath)

        setupCell(cell: cell)
        
        cell.textLabel?.text = classesListArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            currentClassId = nil
            rightCollectionView.isPushArea = true
            isRecommend = true
            isSpecial = false
            rightCollectionView.isSpecialZone = false
            recommendPage = 0
            loadReZoneData()
        }else if indexPath.row == 1 {
            currentClassId = nil
            rightCollectionView.isPushArea = false
            isRecommend = false
            rightCollectionView.isSpecialZone = true
            isSpecial = true
            recommendPage = 0
            getSpecialZoneData()
        }else {
            currentClassId = classesListArr[indexPath.row].id
            rightCollectionView.isSpecialZone = false
            isRecommend = false
            isSpecial = false
            recommendPage = 0
            rightCollectionView.isPushArea = false
            
            getOtherChildClassesData()
        }
        
        rightCollectionView.secTitleStr = classesListArr[indexPath.row].title!
        rightCollectionView.reloadData()
        
        leftTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func setupCell(cell: UITableViewCell) {
        cell.backgroundColor = UIColor(red: 245 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1.0)
        
        cell.selectedBackgroundView = UIView(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = .white
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.highlightedTextColor = XHRgbColorFromHex(rgb: 0xea2000)
        cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x333333)
    }
}
