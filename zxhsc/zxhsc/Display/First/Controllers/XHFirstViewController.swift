//
//  XHFirstViewController.swift
//  zxhsc
//
//  Created by 12345678 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import PYSearch
import SSKeychain
import MJRefresh
import swiftScan

let noti_name_jumpToClassRow = "XHNoti_name_jumpToClassRow"

class XHFirstViewController: UIViewController, UISearchBarDelegate {
    
    // MARK:- 私有属性
    fileprivate let reuseId = "XHFirstViewController_section"
    fileprivate let reuseId0 = "XHFirstViewController_section0"
    fileprivate let reuseId1 = "XHFirstViewController_section1"
    fileprivate let reuseId2 = "XHFirstViewController_section2"
    fileprivate let reuseId3 = "XHFirstViewController_section3"
    fileprivate let reuseId4 = "XHFirstViewController_section4"
    fileprivate let reuseId_digitil = "XHFirstViewController_section_digitil"
    fileprivate let reuseId_vertical = "XHFirstViewController_section_vertical"
    
    fileprivate let reuseId_section1_img = "XHMarketViewController_tableView_section1_image"
    fileprivate let reuseId_section1_wine = "XHMarketViewController_tableView_section1_wine"
    fileprivate let viewName = "首页"
    
    fileprivate var loopStrArr: [String] = []
    
    /// 通知模型
    var noticeModel: XHHomeNoticeModel? {
        didSet {
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    /// 推荐部分 类型
    fileprivate var rec_stypeArr: [String] = []
    fileprivate let styleArr: [String] = ["notice", "special", "quality", "horizontal", "vertical", "title", "flow"]
    
    /// 推荐部分 banner部分
    fileprivate var rec_bannersArr: [XHClassifyBannerModel] = [] {
        didSet {
            tableView.reloadSections([2], with: .automatic)
        }
    }
    
    /// 推荐带商品banner数组
    fileprivate var rec_banners_goodsArr: [XHHomeBannerGoodsModel] = [] {
        didSet {
            rec_stypeArr.removeAll()
            horizontalGoodsArr.removeAll()
            verticalGoodsArr.removeAll()
            horizontal_count = 0
            for i in 0 ..< rec_banners_goodsArr.count {
                
                if rec_banners_goodsArr[i].style == "1" {
                    rec_stypeArr.append("banner")
                    rec_stypeArr.append("goods")
                    horizontal_count += 1
                    horizontalGoodsArr.append(rec_banners_goodsArr[i])
                }else {
                    verticalGoodsArr.append(rec_banners_goodsArr[i])
                }
            }
            tableView.reloadSections([3, 4], with: .automatic)
        }
    }
    
    /// 横屏产品个数
    var horizontal_count: Int = 0
    
    /// 横竖屏产品
    var horizontalGoodsArr: [XHHomeBannerGoodsModel] = []
    var verticalGoodsArr: [XHHomeBannerGoodsModel] = []
    
    /// 是否有竖屏banner
    var isHaveSplit: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 热卖单品数组
    fileprivate var hotSalesArr: [XHSpecialFavModel] = [] {
        didSet {
            tableView.reloadSections([5], with: .automatic)
        }
    }
    
    /// 专区图片数组
    fileprivate var zoneIconList: [XHTabbarIconModel] = [] {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: cl_bannerPath) != nil {
            headerView.dataImgArr = NSKeyedUnarchiver.unarchiveObject(withFile:cl_bannerPath) as! Array<XHClassifyBannerModel>
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: circulationPath) != nil {
            headerView.circulationModel = NSKeyedUnarchiver.unarchiveObject(withFile:circulationPath) as? XHCirculationModel
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: homeNoticePath) != nil {
            noticeModel = NSKeyedUnarchiver.unarchiveObject(withFile:homeNoticePath) as? XHHomeNoticeModel
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: homeRecommend_GoodsListPath) != nil {
            hotSalesArr = NSKeyedUnarchiver.unarchiveObject(withFile:homeRecommend_GoodsListPath) as! [XHSpecialFavModel]
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: home_bannerPath) != nil {
            rec_stypeArr.removeAll()
            rec_bannersArr = NSKeyedUnarchiver.unarchiveObject(withFile:home_bannerPath) as! [XHClassifyBannerModel]
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: homeBannerGoodsPath) != nil {
            rec_banners_goodsArr = NSKeyedUnarchiver.unarchiveObject(withFile:homeBannerGoodsPath) as! [XHHomeBannerGoodsModel]
        }
        
        if XHTabbarViewModel().tabbarIconList.count != 0 {
            zoneIconList = XHTabbarViewModel().tabbarIconList
        }else {
            XHTabbarViewModel().loadTabbarIconList(success: { [weak self] (tabbarIconList) in
                self?.zoneIconList = tabbarIconList
            })
        }
        
        // 设置导航栏
        setupNav()
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        // 设置tableView
        setupTableView()
        
        headerView.cycleViewItemClickedClosure = { [weak self] bannerModel in
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
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        lottoryImageView.removeFromSuperview()
//        loopView.removeFromSuperview()
        TalkingData.trackPageEnd(viewName)
    }
    
    @objc private func loadData() {
        XHHomeViewModel.sharedInstance.getHomeBannerList(self) { [weak self] (bannerList) in
            self?.headerView.dataImgArr = bannerList
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
        
        XHHomeViewModel.sharedInstance.getCirculation(self) { [weak self] (cirModel) in
            self?.headerView.circulationModel = cirModel
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
        
        XHHomeViewModel.sharedInstance.getNotice(self) { [weak self] (noticeModel) in
            self?.noticeModel = noticeModel
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            
            if noticeModel.notice?.isEmpty == false {
                self?.alertView.alertString = noticeModel.notice
                self?.alertView.alpha = 1.0
                UIApplication.shared.keyWindow?.addSubview((self?.alertView)!)
                self?.alertView.snp.makeConstraints({ (make) in
                    make.edges.equalTo(UIApplication.shared.keyWindow!)
                })
            }
        }
        
        alertView.confirmButtonClickedClosure = { [weak self] in
            self?.alertView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: KUIScreenHeight)
            UIView.animate(withDuration: 0.6, animations: {
                self?.alertView.alpha = 0.0
            }, completion: { (finished) in
                self?.alertView.removeFromSuperview()
            })
        }
        
        XHHomeViewModel.sharedInstance.getRecommend_goodsList(self) { [weak self] (goodsList) in
            self?.hotSalesArr = goodsList
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
        
        XHHomeViewModel.sharedInstance.getRecommend_bannersList(self) { [weak self] (bannersList) in
            self?.rec_bannersArr = bannersList
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
        
        XHHomeViewModel.sharedInstance.getRecommend_banners_goods_List(self) { [weak self] (bannerGoodsList) in
            self?.rec_banners_goodsArr = bannerGoodsList
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARK:- ======= 事件相关 ========
    // MARK:- 二维码扫描
    @objc private func qrcode() {
        ZhiFuBaoStyle()
    }
    // MARK:- 消息按钮
    @objc private func message() {
        let help = XHHelpCenterController()
        setupChildViewController()
        help.title = "帮助中心"
        navigationController?.pushViewController(help, animated: true)
    }
    
    // MARK:- 抽奖图片手势事件
    @objc private func lottoryImageViewTapGesture() {
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        if token != nil, userid != nil {
            setupChildViewController()
            let webView = XHWebViewController()
            var userInfo = Dictionary<String, String>()
            userInfo["userid"] = userid!
            userInfo["userkey"] = token!
            
            let urlStr = "http://lott.zxhshop.cn/turnplate/index.html?user=false" + "&userid=" + "\(userid!)" + "&userkey=" + "\(token!)"
            
            webView.urlStr = urlStr
            navigationController?.pushViewController(webView, animated: true)
            return
        }
        let login = XHLoginController()
        let nav = XHNavigationController(rootViewController: login)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    // MARK:- 搜索框的代理方法
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        tabBarController?.tabBar.isHidden = true
        XHSearchManager.instance.pushSearchViewController(targetVc: self, placeholdStr: "请输入商品或品牌关键字", isAnimation: false) { (searchVc, searchBar, textString) in }
        
        XHSearchManager.instance.searchResultGoodsDetailItemClickedClosure = { [weak self] model in
            let goodsDetail = XHGoodsDetailController()
            self?.setupChildViewController()
            goodsDetail.goodsId = model.id
            self?.navigationController?.pushViewController(goodsDetail, animated: true)
        }
    }
    
    // MARK:- 运营中心分布图按钮点击事件
    @objc fileprivate func operateCenterButtonClicked() {
        let center = XHCenterDistributeController()
        setupChildViewController()
        navigationController?.pushViewController(center, animated: true)
    }
    
    //MARK: ---模仿支付宝------
    func ZhiFuBaoStyle()
    {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 60;
        style.xScanRetangleOffset = 30;
        
        if UIScreen.main.bounds.size.height <= 480
        {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40;
            style.xScanRetangleOffset = 20;
        }
        
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2.0;
        style.photoframeAngleW = 16;
        style.photoframeAngleH = 16;
        
        style.isNeedShowRetangle = false;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_full_net")
        
        let vc = XHScanViewController()
        
        vc.scanStyle = style
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    // MARK:- ======= 界面相关 ========
    // MARK:- 设置tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(-44)
            make.top.equalTo(64)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "XHHomeNewsCell", bundle: nil), forCellReuseIdentifier: reuseId0)
        tableView.register(UINib(nibName: "XHMarketFirstSectionCell", bundle: nil), forCellReuseIdentifier: reuseId1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId2)
        tableView.register(XHHotSellTableCell.self, forCellReuseIdentifier: reuseId3)
        tableView.register(UINib(nibName: "XHPlatformCell", bundle: nil), forCellReuseIdentifier: reuseId4)
        
        tableView.register(UINib(nibName: "XHHome_DigitalCell", bundle: nil), forCellReuseIdentifier: reuseId_digitil)
        
        tableView.register(UINib(nibName: "XHHome_VerticalCell", bundle: nil), forCellReuseIdentifier: reuseId_vertical)
        
        tableView.register(XHMarketImageCell.self, forCellReuseIdentifier: reuseId_section1_img)
        tableView.register(XHMarketWineTableCell.self, forCellReuseIdentifier: reuseId_section1_wine)
        
        
        // MARK:- headerView
        tableView.tableHeaderView = headerView
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        tableView.tableFooterView = footerView
        footerView.title = "我是有底线的~"
    }
    
    // MARK:- 跳转到专场界面
    fileprivate func jumpToSessionView(_ sessionModel: XHClassifyBannerModel) {
        
        switch (sessionModel.type)! {
        case 1:
            setupChildViewController()
            let specialV = XHSpecialViewController()
            specialV.sessionId = sessionModel.id
            specialV.title = sessionModel.title
            navigationController?.pushViewController(specialV, animated: true)
        case 2:
            setupChildViewController()
            let goodsDetailV = XHGoodsDetailController()
            goodsDetailV.goodsId = sessionModel.id
            navigationController?.pushViewController(goodsDetailV, animated: true)
        case 3:
            setupChildViewController()
            let shopV = XHBussinessShopController()
            shopV.shopId = sessionModel.id
            navigationController?.pushViewController(shopV, animated: true)
        case 4:
            tabBarController?.selectedIndex = 3
        case 5:
            setupChildViewController()
            let integralV = XHIntegralController()
            navigationController?.pushViewController(integralV, animated: true)
        case 6:
            setupChildViewController()
            let webView = XHWebViewController()
            webView.urlStr = "http://" + (sessionModel.httpUrl ?? "")
            navigationController?.pushViewController(webView, animated: true)
        case 7:
            setupChildViewController()
            let goodsDetailV = XHGoodsDetailController()
            goodsDetailV.isIntegral = true
            goodsDetailV.goodsId = sessionModel.id
            navigationController?.pushViewController(goodsDetailV, animated: true)
        default:
            break
        }
    }
    
    // MARK:- 设置抽奖浮层图片
    private func setupLottoryView() {
        UIApplication.shared.keyWindow?.addSubview(lottoryImageView)
        lottoryImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(UIApplication.shared.keyWindow!).offset(80)
            make.right.equalTo(UIApplication.shared.keyWindow!)
            make.width.equalTo(84)
            make.height.equalTo(79)
        }
        
        let path = Bundle.main.path(forResource: "抽奖浮窗2", ofType:"gif")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        lottoryImageView.image = UIImage.sd_animatedGIF(with: data)
    }
    
    // MARK:- 设置导航栏
    private func setupNav() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        
        // 二维码扫描
        let leftItem = UIBarButtonItem(image: UIImage(named: "home_qrcode")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(qrcode))
        navigationItem.leftBarButtonItem = leftItem
        
        // 消息
        let  rightItem = UIBarButtonItem(image:  UIImage(named: "home_help")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(message))
        navigationItem.rightBarButtonItem = rightItem
        
        // 搜索框
        navigationItem.titleView = searchBar
    }
    
    fileprivate func setupChildViewController() {
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK:- ===== 懒加载 ========
    // 搜索框
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入商品或品牌关键字"
        bar.setSearchFieldBackgroundImage(UIImage(named: "searchBar_bg"), for: .normal)
        bar.delegate = self
        bar.showsCancelButton = false
        bar.backgroundColor = .clear
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    // TableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // headerView
    private lazy var headerView: XHHomeHeaderView = {
        let view = XHHomeHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 165 * kUIScreenWidth / 375)
        return view
    }()
    
    // -------------------------
    fileprivate lazy var sec2ImgView: UIImageView = UIImageView(image: UIImage(named: "home_remai"))
    fileprivate lazy var sec2Label: UILabel = {
        let label = UILabel()
        label.text = "精选推荐"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // ----------------------------
    fileprivate lazy var sec4ImgView: UIImageView = UIImageView(image: UIImage(named: "home_remai"))
    fileprivate lazy var sec4Label: UILabel = {
        let label = UILabel()
        label.text = "平台角色"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    fileprivate lazy var distributeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("运营中心分布图", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(operateCenterButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    private lazy var footerView: XHTableFooterView = XHTableFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 20))
    
    private lazy var lottoryImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(lottoryImageViewTapGesture))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    private lazy var loopView: XHHomeLoopView = XHHomeLoopView()
    private lazy var planeView: XHHomePlaneView = XHHomePlaneView()
    private lazy var alertView: XHHomeAlertView = Bundle.main.loadNibNamed("XHHomeAlertView", owner: nil, options: nil)?.first as! XHHomeAlertView
}

extension XHFirstViewController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return styleArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch styleArr[section] {
        case "quality":
            return rec_bannersArr.count
        case "horizontal":
            return rec_stypeArr.count
        case "vertical":
            return verticalGoodsArr.count
        default:
            return 1
        }
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        switch styleArr[indexPath.section] {
        case "notice": // 今日头条
            let cell: XHHomeNewsCell = tableView.dequeueReusableCell(withIdentifier: reuseId0, for: indexPath) as! XHHomeNewsCell
            cell.noticeModel = noticeModel
            return cell
        case "special": // 推荐专区
            let cell: XHMarketFirstSectionCell = tableView.dequeueReusableCell(withIdentifier: reuseId1, for: indexPath) as! XHMarketFirstSectionCell
            if zoneIconList.count != 0 {
                cell.tabbarModel = zoneIconList[0]
            }
            cell.buttonClickedClosure = { [weak self] sender in
                
                switch sender.tag {
                case 1001:
                    let rankV = XHScaleRankController()
                    self?.setupChildViewController()
                    self?.navigationController?.pushViewController(rankV, animated: true)
                case 1002:
                    self?.tabBarController?.selectedIndex = 1
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_name_jumpToClassRow), object: self, userInfo: ["row": "特惠专区"])
                case 1003:
//                    self?.tabBarController?.selectedIndex = 1
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_name_jumpToClassRow), object: self, userInfo: ["row": "汽车专区"])
                    let minusDouble = XHSpecialViewController()
                    self?.setupChildViewController()
                    minusDouble.is_fu_xiao_zone = true
                    minusDouble.sessionId = "24"
                    minusDouble.title = "复消专区"
                    self?.navigationController?.pushViewController(minusDouble, animated: true)
                case 1004:
//                    self?.tabBarController?.selectedIndex = 1
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: noti_name_jumpToClassRow), object: self, userInfo: ["row": "房屋地产"])
                    let nineXi = XHSpecialViewController()
                    self?.setupChildViewController()
                    nineXi.is_nineXi = true
                    nineXi.sessionId = "26"
                    nineXi.title = "九玺专区"
                    
                    self?.navigationController?.pushViewController(nineXi, animated: true)
                default:
                    break
                }
            }
            
            return cell
        case "quality": // 精品
            let cell: XHMarketImageCell = tableView.dequeueReusableCell(withIdentifier: reuseId_section1_img, for: indexPath) as! XHMarketImageCell
            
            cell.bannerModel = rec_bannersArr[indexPath.row]
            cell.isBannerGoods = false
            cell.imageClickedClosure = { [weak self] bannerModel in
                self?.jumpToSessionView(bannerModel)
            }
            return cell
        case "horizontal": // 横屏产品
            if rec_stypeArr[indexPath.row] == "banner" {
                let cell: XHMarketImageCell = tableView.dequeueReusableCell(withIdentifier: reuseId_section1_img, for: indexPath) as! XHMarketImageCell
                cell.bannerGoodsModel = horizontalGoodsArr[indexPath.row / 2]
                cell.isBannerGoods = true
                cell.bannerGoodsImageClickedClosure = { [weak self] bannerGoodsModel in
                    let specialV = XHSpecialViewController()
                    self?.setupChildViewController()
                    specialV.title = bannerGoodsModel.title
                    specialV.sessionId = bannerGoodsModel.id
                    self?.navigationController?.pushViewController(specialV, animated: true)
                }
                return cell
            }
            
            let cell: XHMarketWineTableCell = tableView.dequeueReusableCell(withIdentifier: reuseId_section1_wine, for: indexPath) as! XHMarketWineTableCell
            cell.goodsArr = horizontalGoodsArr[(indexPath.row - 1) / 2].goodsArr
            cell.wineItemClickClosure = { [weak self] goodsModel in
                let goodsDetail = XHGoodsDetailController()
                self?.setupChildViewController()
                goodsDetail.goodsId = goodsModel.id
                self?.navigationController?.pushViewController(goodsDetail, animated: true)
            }
            return cell
        case "vertical": // 竖屏产品
            
            if indexPath.row % 2 == 0 {
                let cell: XHHome_DigitalCell = tableView.dequeueReusableCell(withIdentifier: reuseId_digitil, for: indexPath) as! XHHome_DigitalCell
                cell.model = verticalGoodsArr[indexPath.row]
                /// 小格子点击
                cell.eachItemClickedClosure = { [weak self] goodsModel in
                    let goodsDetail = XHGoodsDetailController()
                    self?.setupChildViewController()
                    goodsDetail.goodsId = goodsModel.id
                    self?.navigationController?.pushViewController(goodsDetail, animated: true)
                }
                
                // 大格子点击
                cell.bigImageViewClickedClosure = { [weak self] bannerModel in
                    let specialV = XHSpecialViewController()
                    self?.setupChildViewController()
                    specialV.title = bannerModel.title
                    specialV.sessionId = bannerModel.id
                    self?.navigationController?.pushViewController(specialV, animated: true)
                }
                return cell
            }
            
            let cell: XHHome_VerticalCell = tableView.dequeueReusableCell(withIdentifier: reuseId_vertical, for: indexPath) as! XHHome_VerticalCell
            cell.model = verticalGoodsArr[indexPath.row]
            /// 小格子点击
            cell.eachItemClickedClosure = { [weak self] goodsModel in
                let goodsDetail = XHGoodsDetailController()
                self?.setupChildViewController()
                goodsDetail.goodsId = goodsModel.id
                self?.navigationController?.pushViewController(goodsDetail, animated: true)
            }
            
            // 大格子点击
            cell.bigImageViewClickedClosure = { [weak self] bannerModel in
                let specialV = XHSpecialViewController()
                self?.setupChildViewController()
                specialV.title = bannerModel.title
                specialV.sessionId = bannerModel.id
                self?.navigationController?.pushViewController(specialV, animated: true)
            }
            return cell
            
        case "title": // 标题
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId2, for: indexPath)
            setupSection2Cell(cell: cell)
            return cell
        case "flow": // 流布局
            let cell: XHHotSellTableCell = tableView.dequeueReusableCell(withIdentifier: reuseId3, for: indexPath) as! XHHotSellTableCell
            cell.dataSourceArr = hotSalesArr
            
            // 商品item的点击事件
            cell.hotSellCollViewClickClosure = { [weak self] model in
                let goodsDetail = XHGoodsDetailController()
                self?.setupChildViewController()
                goodsDetail.goodsId = model.id
                self?.navigationController?.pushViewController(goodsDetail, animated: true)
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
            if indexPath.section == 0 {
                cell.accessoryType = .disclosureIndicator
            }
            cell.backgroundColor = RandomColor()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let html = XHHTMLViewController()
            html.helpId = noticeModel?.detail?.help_id
            setupChildViewController()
            navigationController?.pushViewController(html, animated: true)
        }
    }
    
    // cell 的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch styleArr[indexPath.section] {
        case "notice":
            return 44
        case "special":
            return 101
        case "quality", "horizontal":
            return 165 * kUIScreenWidth / 375 + 4
        case "vertical":
            return 288 * kUIScreenWidth / 375
        case "title":
            return 34
        case "flow":
            let row: Int = Int((hotSalesArr.count) % 2 == 0 ? (hotSalesArr.count) / 2 : (hotSalesArr.count / 2 + 1))
            let with = (kUIScreenWidth - 10 * 3) / 2
            let height: CGFloat = with + 46
            return CGFloat(row) * height + CGFloat(row) * 12.0
        default:
            return 44
        }
    }
    
    // footer/header高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch styleArr[section] {
        case "quality":
            return 0.01
        case "vertical":
            return 6
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch styleArr[section] {
        case "quality":
            return 44
        case "horizontal":
            return 0.01
        default:
            return 3
        }
    }
    
    // 组标题
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch styleArr[section] {
        case "quality":
            let view = UIView()
            view.backgroundColor = .white
            view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 44)
            let label = UILabel()
            label.text = "商品精选"
            label.textColor = XHRgbColorFromHex(rgb: 0x333333)
            label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.center.equalTo(view)
            }
            
            return view
        default:
            return nil
        }
        
    }
    
    // MARK:- 设置第2组cell
    private func setupSection2Cell(cell: UITableViewCell) {
        cell.selectionStyle = .none
        // label
        cell.addSubview(sec2Label)
        sec2Label.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell)
            make.centerX.equalTo(cell.snp.centerX).offset(15)
        }
        // 图片
        cell.addSubview(sec2ImgView)
        sec2ImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cell)
            make.right.equalTo(sec2Label.snp.left).offset(-10)
            make.width.height.equalTo(15)
        }
    }
    
    private func setupSection4HeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 44)
        // 图片
        headerView.addSubview(sec4ImgView)
        sec4ImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(16)
            make.width.height.equalTo(15)
        }
        
        // label
        headerView.addSubview(sec4Label)
        sec4Label.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(sec4ImgView.snp.right).offset(8)
        }
        
        // 分布图按钮
        headerView.addSubview(distributeBtn)
        distributeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.right.equalTo(-16)
            make.width.equalTo(100)
        }
        
        // 分割线
        let line = UIView()
        line.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
        headerView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(headerView)
            make.height.equalTo(1)
        }
        return headerView
    }
}
