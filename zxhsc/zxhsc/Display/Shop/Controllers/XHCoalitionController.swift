//
//  XHCoalitionController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  商盟 或 店铺

import UIKit
import PYSearch
import SSKeychain

class XHCoalitionController: UIViewController, UISearchBarDelegate, PYSearchViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
        setupUI()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK:- 开店按钮点击事件
    @objc private func openShopButtonClicked() {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        if token == nil, userid == nil {
            XHAlertController.showAlert(title: "提示", message: "您还未登录，请登录~", Style: .alert, confirmTitle: "登录", confirmComplete: {
                let login = XHLoginController()
                let nav = XHNavigationController(rootViewController: login)
                self.present(nav, animated: true, completion: nil)
            })
            return
        }
        
        let openS = XHShopProtocolController()
        openS.tabBarController?.tabBar.isHidden = true
        let nav = UINavigationController(rootViewController: openS)
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK:- 店铺二维码 按钮点击事件
    @objc private func myShop_qrCodeItemClicked() {
        let qrcode = XHMyShop_QRCodeController()
        setChildViewControllerNav()
        
        navigationController?.pushViewController(qrcode, animated: true)
    }
    
    // MARK:- 商盟按钮点击事件
    @objc private func bussinessFriendItemClick() {
        let friend = XHFriendViewController()
        setChildViewControllerNav()
        friend.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(friend, animated: true)
    }
    
    // MARK:- 搜索代理方法
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        searchResultVc.view.removeFromSuperview()
        searchViewController.searchBar.text = ""
        searchViewController.searchBar.resignFirstResponder()
    }


    // MARK:- 搜索框的代理方法
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        let hotSearches = Array<String>()
        let searchV = PYSearchViewController(hotSearches: hotSearches, searchBarPlaceholder: "店铺名称/分类名称") { [weak self] (searchVc, searchBar, searchText) in
            searchBar?.becomeFirstResponder()
            searchVc?.delegate = self
            searchVc?.cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
            if searchText != nil {
                self?.searchResultVc.searchKey = searchText
                searchVc?.view.addSubview((self?.searchResultVc.view)!)
                self?.searchResultVc.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo((searchVc?.view)!)
                })
                
                self?.searchResultVc.jumpToNextViewClosure = { model in
                    let shopVc = XHBussinessShopController()
                    shopVc.shopId = model.shopId
                    self?.navigationController?.pushViewController(shopVc, animated: true)
                }
            }
        }
        
        searchV?.hotSearchStyle = .borderTag
        searchV?.searchHistoryStyle = .borderTag
        setChildViewControllerNav()
        navigationController?.pushViewController(searchV!, animated: false)
        return true
    }

    // MARK:- 界面相关
    private func setupUI() {
        if isOpenShop == true {
            friendVc.view.removeFromSuperview()
            friendVc.removeFromParentViewController()
            view.addSubview(shopVc.view)
            addChildViewController(shopVc)
            shopVc.view.snp.makeConstraints({ (make) in
                make.edges.equalTo(view)
            })
        }else {
            shopVc.view.removeFromSuperview()
            shopVc.removeFromParentViewController()
            view.addSubview(friendVc.view)
            addChildViewController(friendVc)
            friendVc.view.snp.makeConstraints({ (make) in
                make.edges.equalTo(view)
            })
        }
    }
    
    private func setupNav() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        UIApplication.shared.statusBarStyle = .default
        
        if isOpenShop == true {
            let rightItem = UIBarButtonItem(title: "商盟", style: .plain, target: self, action: #selector(bussinessFriendItemClick))
            rightItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
            navigationItem.rightBarButtonItem = rightItem
            navigationItem.titleView = nil
            navigationItem.title = "店铺"
            
            let leftItem = UIBarButtonItem(title: "店铺二维码", style: .plain, target: self, action: #selector(myShop_qrCodeItemClicked))
            leftItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
             leftItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)], for: .highlighted)
            navigationItem.leftBarButtonItem = leftItem
        }else {
            let rightItem = UIBarButtonItem(title: "开店", style: .plain, target: self, action: #selector(openShopButtonClicked))
            
            navigationItem.titleView = searchBar
            rightItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
            navigationItem.rightBarButtonItem = rightItem
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    fileprivate func setChildViewControllerNav() {
        UIApplication.shared.statusBarStyle = .default
        
        tabBarController?.tabBar.isHidden = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333)]
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
    }
    
    // MARK:- ==== 懒加载 ========
    private lazy var friendVc: XHFriendViewController = XHFriendViewController()
    private lazy var shopVc: XHShopViewController = XHShopViewController()
    /// 搜索框
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入店铺名称"
        bar.setSearchFieldBackgroundImage(UIImage(named: "searchBar_bg"), for: .normal)
        bar.delegate = self
        bar.showsCancelButton = false
        bar.backgroundColor = .clear
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private lazy var searchResultVc: XHShopClassController = XHShopClassController()
}
