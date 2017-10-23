//
//  XHShopViewController.swift
//  zxhsc
//
//  Created by 12345678 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHShopViewController: UIViewController {

    fileprivate let reuseId = "XHShopViewController_reuseId"
    fileprivate var shopModel: XHMyShopModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        
        setupTableView()
        
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        loadMyShop()
    }
    
    // MARK:- 获取我的店铺信息
    @objc private func loadMyShop() {
        XHMyShopViewModel.getMyShopInfo(self) { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            if result is XHMyShopModel {
                self?.headerView.shopModel = result as? XHMyShopModel
                self?.shopModel = result as? XHMyShopModel
                self?.footerView.shopModel = result as? XHMyShopModel
                if self?.shopModel?.shop_status == 2 {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "抱歉！您的店铺未通过审核！", confirmTitle: "朕知道了", confirmComplete: nil)
                    self?.footerView.reason = (result as? XHMyShopModel)?.judge_content
                }
            }else {
                if (result as! String) == "请重新登陆！" {
                    let login = XHLoginController()
                    let nav = XHNavigationController(rootViewController: login)
                    self?.present(nav, animated: true, completion: nil)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
                }
            }
        }
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

    // MARK:- ======== 界面相关 =======
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadMyShop))
        
        setHeaderDragableIamge()
    }
    
    // MARK:- 设置头部可拉伸图片
    fileprivate func setHeaderDragableIamge() {
        headerImageView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 155)
        bgView.addSubview(headerImageView)
        
        tableView.backgroundView = bgView
        tableView.tableHeaderView = headerView
        
        /// 升级店铺按钮点击事件回调
        headerView.upShopButtonClickedClosure = { [weak self] in
            self?.setChildViewControllerNav()
            let up = XHShopUpgradeController()
            self?.navigationController?.pushViewController(up, animated: true)
        }
        
        
        tableView.tableFooterView = footerView
        footerView.footerButtonClickedClosure = { [weak self] sender in
            
            switch sender.tag {
            case 1001: // 进入店铺
                self?.setChildViewControllerNav()
                let shopV = XHBussinessShopController()
                shopV.isMyShop = true
                shopV.shopId = self?.shopModel?.shop_id
                self?.navigationController?.pushViewController(shopV, animated: true)
            case 1002: // 物流下载
                self?.setChildViewControllerNav()
                let webView = XHWebViewController()
                webView.urlStr = "http://wx2.zxhshop.cn/download/wliao.html"
                self?.navigationController?.pushViewController(webView, animated: true)
            case 1003: // 店铺设置
                self?.setChildViewControllerNav()
                let setting = XHShopSettingController()
                
                self?.navigationController?.pushViewController(setting, animated: true)
            case 1004: // 商家订单
                self?.setChildViewControllerNav()
                let order = XHMyShopOrderController()
                order.navigationItem.title = "商家订单"
                self?.navigationController?.pushViewController(order, animated: true)
            case 1005: // 用户订单
                self?.setChildViewControllerNav()
                let order = XHShopOrderDetailController()
                order.navigationItem.title = "用户订单"
                self?.navigationController?.pushViewController(order, animated: true)
            case 1006: // 退货订单
                self?.setChildViewControllerNav()
                let order = XHShopOrderDetailController()
                order.isReturnSales = true
                order.navigationItem.title = "退货订单"
                self?.navigationController?.pushViewController(order, animated: true)
            case 1007: // 商家付款
                self?.setChildViewControllerNav()
                let fukuanV = XHShopsFukuanController()
                fukuanV.shopModel = self?.shopModel
                self?.navigationController?.pushViewController(fukuanV, animated: true)
            default:
                break
            }
        }
    }
    
    fileprivate func setChildViewControllerNav() {
        UIApplication.shared.statusBarStyle = .default
        
        tabBarController?.tabBar.isHidden = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333)]
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
    }

    // MARK:- 设置导航栏
    private func setupNav() {
        navigationItem.title = "店铺"
    }
    
   // MARK:- ======= 懒加载 =========
    /// tableView
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
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
    
    fileprivate lazy var headerView: XHShopHeaderView = {
        let view: XHShopHeaderView = Bundle.main.loadNibNamed("XHShopHeaderView", owner: self, options: nil)?.last as! XHShopHeaderView
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 155)
        return view
    }()
    
    private lazy var footerView: XHShopFooterView = {
        let view: XHShopFooterView = Bundle.main.loadNibNamed("XHShopFooterView", owner: self, options: nil)?.last as! XHShopFooterView
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: (KUIScreenHeight - 64 - 44 - 155))
        return view
    }()
}

extension XHShopViewController: UITableViewDelegate, UITableViewDataSource {
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell
    }
}
