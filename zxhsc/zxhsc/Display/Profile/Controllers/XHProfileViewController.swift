//
//  XHProfileViewController.swift
//  zxhsc
//
//  Created by 12345678 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SnapKit
import SSKeychain
import MJRefresh

class XHProfileViewController: UIViewController {

    // MARK:- ====== 私有属性 ========
    fileprivate let sectionReuseIdentifier = "XHProfileViewControllerReuseIdentifier_sectionHeader" // 组标题视图
    fileprivate let section0ReuseIdentifier = "XHProfileViewControllerReuseIdentifier_section0Cell" // 第0组
    fileprivate let reuseIdentifier_freezed = "XHProfileViewControllerReuseIdentifier_freezed" // 冻结循环宝
    fileprivate let reuseIdentifier_unfreezed = "XHProfileViewControllerReuseIdentifier_unfreezed" // 当日解冻循环宝
    fileprivate let section1ReuseIdentifier = "XHProfileViewControllerReuseIdentifier_section1Cell" // 第1组
    fileprivate let section2ReuseIdentifier = "XHProfileViewControllerReuseIdentifier_section2Cell" // 第2组
    
    fileprivate let reuseIdentifier = "XHProfileViewControllerReuseIdentifier"
    
    fileprivate let viewName = "tab_个人中心页"
    
    fileprivate var styleArr: [String] = ["earning", "manager", "news", "connect"]  // cell的样式
    fileprivate let sectionMargin: CGFloat = 5
    
    fileprivate var userEarningModel: XHUserEarningModel? {
        didSet {
            if userEarningModel?.xhb_freezed != 0 {
                if unfreezed_XhbModel?.total_freezed != nil, unfreezed_XhbModel?.total_freezed != 0 {
                    styleArr = ["earning", "freezed", "unfreezed", "manager", "news", "connect"]
                }else {
                    styleArr = ["earning", "freezed", "manager", "news", "connect"]
                }
                tableView.reloadData()
            }
        }
    }
  
    fileprivate var unfreezed_XhbModel: XHXHB_UnfreezedModel? {
        didSet {
            if unfreezed_XhbModel?.total_freezed != 0  {
                if userEarningModel?.xhb_freezed != nil, userEarningModel?.xhb_freezed != 0 {
                    styleArr = ["earning", "freezed", "unfreezed", "manager", "news", "connect"]
                }else {
                    styleArr = ["earning", "unfreezed", "manager", "news", "connect"]
                }
                
            }else {
                if userEarningModel?.xhb_freezed != 0 {
                    styleArr = ["earning", "freezed", "manager", "news", "connect"]
                }else {
                    styleArr = ["earning", "manager", "news", "connect"]
                }
            }
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 布局UI
        setupUI()
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: userEarningPath) != nil {
            userEarningModel = NSKeyedUnarchiver.unarchiveObject(withFile:userEarningPath) as? XHUserEarningModel
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        if token != nil, userid != nil {
            judgeIfSettedPayPsw()
        }
        
        setHeaderDragableIamge()
        
        getUserEarning()
        
        getUnfreezedXHB()
        
        // 头部可拉伸视图
        setHeaderDragableIamge()
        
        setupUI()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 设置导航栏
        setupNav()
        tabBarController?.tabBar.isHidden = false
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    

    // MARK:- 判断是否设置过支付密码
    private func judgeIfSettedPayPsw() {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        let paraDict = ["userid": userid ?? "", "userkey": token ?? ""] 
        
        _ = XHRequest.shareInstance.requestNetData(dataType: .judgeSetedPayPsw, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.judgeIfSettedPayPsw()
        }, success: { [weak self] (str) in
            let idx = str as! String
            if idx == "0" {
                let set = XHSettingPayPswController()
                let nav = UINavigationController(rootViewController: set)
                self?.present(nav, animated: true, completion: nil)
            }
        })
    }
    
    // MARK:- 获取用户收益
    private func getUserEarning() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getUserEarning, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            if sth is XHUserEarningModel {
                let userE = sth as! XHUserEarningModel
                self?.userEarningModel = userE
            }else {
                let str = sth as! String
                self?.showHint(in: (self?.view)!, hint: str)
                
                if str == "请重新登陆！" {
                    SSKeychain.deletePassword(forService: userTokenName, account: "TOKEN")
                    SSKeychain.deletePassword(forService: userTokenName, account: "USERID")
                    self?.setHeaderDragableIamge()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK:- 获取解冻循环宝
    private func getUnfreezedXHB() {
        XHProfileViewModel.getUnfreezedXHB(target: self) { [weak self] (result) in
            if result is XHXHB_UnfreezedModel {
                self?.unfreezed_XhbModel = result as? XHXHB_UnfreezedModel
            }
        }
    }
    // MARK:- =============================================
    // 使头部图片可拉伸
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = headerImageView.frame // 头部图片的frame
        if scrollView.contentOffset.y < 0 {
            frame.origin.y = 0
            // 图片的高度加上偏移的值
            frame.size.height = 86 - scrollView.contentOffset.y
        }else {
            frame.origin.y = -scrollView.contentOffset.y
        }
        headerImageView.frame = frame
    }
    
    // MARK:- 弹出荐码控制器
    fileprivate func presentRecommendViewController(controller: UIViewController) {
        let nav = UINavigationController(rootViewController: controller)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK:- 刷新
    @objc private func refresh() {
        getUserEarning()
    }
    
    // MARK:- ======== UI相关 ==========
    // MARK:- 设置导航栏
    private func setupNav() {
        navigationItem.title = "个人中心"
        UIApplication.shared.statusBarStyle = .lightContent
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        //导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK:- 布局UI
    private func setupUI() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: sectionReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(UINib(nibName: "XHProfileFirstSectionCell", bundle: nil), forCellReuseIdentifier: section0ReuseIdentifier)
        tableView.register(UINib(nibName: "XHXHB_FreezedCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier_freezed)
        tableView.register(UINib(nibName: "XHXHB_UnfreezedCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier_unfreezed)
        tableView.register(XHProlieManageCell.self, forCellReuseIdentifier: section1ReuseIdentifier)
        tableView.register(XHProfileNewsCell.self, forCellReuseIdentifier: section2ReuseIdentifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            if KUIScreenHeight == 812 {
                make.bottom.equalTo(-75)
            }else {
                make.bottom.equalTo(-44)
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
    
    // MARK:- 设置头部可拉伸图片
    fileprivate func setHeaderDragableIamge() {
        headerImageView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 150)
        bgView.addSubview(headerImageView)
        
        tableView.backgroundView = bgView
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        if token != nil, userid != nil {
            tableView.tableHeaderView = headerConfigView
            
            if NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) != nil {
                
                headerConfigView.userModel = NSKeyedUnarchiver.unarchiveObject(withFile: userAccountPath) as? XHUserModel
            }
            
            // MARK:- 用户信息部分点击事件回调
            headerConfigView.cinfigViewTapGestureClosure = { [weak self] in
                let setting = XHSettingConfigController()
                self?.setChildViewControllerNav()
                setting.title = "修改资料"
                self?.navigationController?.pushViewController(setting, animated: true)
            }
            
            // MARK:- 二维码按钮点击事件回调
            headerConfigView.qrCodeButtonClickClosure = { [weak self] in
                let vc = XHRecommendController()
                self?.presentRecommendViewController(controller: vc)
            }
        }else {
            tableView.tableHeaderView = unloginHeaderView
            styleArr = ["earning", "manager", "news", "connect"]
            userEarningModel = XHUserEarningModel()
            NSKeyedArchiver.archiveRootObject(XHUserEarningModel(), toFile: userEarningPath)
            tableView.reloadData()
            unloginHeaderView.loginOrRegisterButtonClickClosure = { [weak self] in
                let loginVc = XHLoginController()
                self?.presentRecommendViewController(controller: loginVc)
                
                loginVc.successLoginClosure = { [weak self] in
                    
                    self?.setHeaderDragableIamge()
                    self?.tableView.reloadData()
                }
            }
        }
    }

    
    // MARK:- ============ 懒加载 ==========
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // 头部可拉伸图片
    fileprivate lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "profile_header_bg"))
        headerImageView.backgroundColor = .white
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    // 头部可拉伸图片 背景视图
    fileprivate lazy var bgView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 150))
    
    // 头部视图
    fileprivate lazy var headerConfigView: XHProfileHeaderView = {
        let headerView: XHProfileHeaderView = Bundle.main.loadNibNamed("XHProfileHeaderView", owner: nil, options: nil)?.first as! XHProfileHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 86)
        return headerView
    }()
    
    fileprivate lazy var unloginHeaderView: XHProfileUnloginHeaderView = {
        let headerView: XHProfileUnloginHeaderView = Bundle.main.loadNibNamed("XHProfileUnloginHeaderView", owner: nil, options: nil)?.first as! XHProfileUnloginHeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 86)
        return headerView
    }()
    
}

extension XHProfileViewController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return styleArr.count
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch styleArr[section] {
        case "manager", "news":
            return 2
        default:
            return 1
        }
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch styleArr[indexPath.section] {
        case "earning":
            let cell: XHProfileFirstSectionCell = tableView.dequeueReusableCell(withIdentifier: section0ReuseIdentifier, for: indexPath) as! XHProfileFirstSectionCell
            
            if userEarningModel != nil {
                cell.earningModel = userEarningModel
            }
            
            /// TODO:- 钱包余额点击回调
            cell.balanceViewTapGestureClosure = { [weak self] in
                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
                if token != nil, userid != nil {
                    let balance = XHMyBalanceController()
                    self?.setChildViewControllerNav()
                    self?.navigationController?.pushViewController(balance, animated: true)
                    return
                }
                let loginVc = XHLoginController()
                self?.presentRecommendViewController(controller: loginVc)
            }
            
            // 钱包明细按钮点击事件回调
            cell.walletDetailButtonClickedClosure = { [weak self] in
                self?.setChildViewControllerNav()
                
                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
                if token != nil, userid != nil {
                    let wallet = XHWalletDetailController()
                    self?.navigationController?.pushViewController(wallet, animated: true)
                }else {
                    let loginVc = XHLoginController()
                    self?.presentRecommendViewController(controller: loginVc)
                }
            }
            
            // 循环宝按钮点击事件回调
            cell.circleDetailButtonClickedClosure = { [weak self] in
                
                self?.setChildViewControllerNav()
                
                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
                if token != nil, userid != nil  {
                    let cycle = XHMyCycleController()
                    self?.navigationController?.pushViewController(cycle, animated: true)
                }else {
                    
                    let loginVc = XHLoginController()
                    self?.presentRecommendViewController(controller: loginVc)
                }
            }
            
            return cell
        case "manager", "news":
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: sectionReuseIdentifier, for: indexPath)
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x333333)
                if indexPath.section == 1 {
                    cell.textLabel?.text = "管理"
                }else if indexPath.section == 2 {
                    cell.textLabel?.text = "资讯中心"
                }
                // 分割线
                let separateLine = UIView()
                separateLine.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
                cell.addSubview(separateLine)
                separateLine.snp.makeConstraints({ (make) in
                    make.left.bottom.right.equalTo(cell)
                    make.height.equalTo(0.5)
                })
                return cell
            }
                // MARK:- !!! 管理
            else if styleArr[indexPath.section] == "manager", indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: section1ReuseIdentifier, for: indexPath) as! XHProlieManageCell
                cell.backgroundColor = .gray
                
                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
                if token != nil, userid != nil  {
                    cell.isLogin = true
                }else {
                    cell.isLogin = false
                }
                
                // 点击回调事件
                cell.cellCollViewItemClickClosure = { [weak self] manageModel in
                    
                    let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                    let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                    
                    if  token != nil, userid != nil {
                        self?.manageCellItemClicked(manageModel, tableView: tableView)
                    }else {
                        let loginVc = XHLoginController()
                        self?.presentRecommendViewController(controller: loginVc)
                    }
                }
                return cell
            }else if styleArr[indexPath.section] == "news", indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: section2ReuseIdentifier, for: indexPath) as! XHProfileNewsCell
                
                // 点击回调事件
                cell.cellCollViewItemClickClosure = { [weak self] manageModel, index in
                    
                    let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
                    let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                    
                    if  token == nil, userid == nil , index == 2 {
                        let loginVc = XHLoginController()
                        self?.presentRecommendViewController(controller: loginVc)
                    }else {
                        self?.newsCenterCellItemClicked(manageModel)
                    }
                }
                return cell
            }
        case "freezed":
            let cell: XHXHB_FreezedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier_freezed, for: indexPath) as! XHXHB_FreezedCell
            cell.earningModel = userEarningModel
            return cell
            
        case "unfreezed":
            let cell: XHXHB_UnfreezedCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier_unfreezed, for: indexPath) as! XHXHB_UnfreezedCell
            cell.unfreezedModel = unfreezed_XhbModel
            return cell
        default:
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x333333)
        cell.textLabel?.text = "服务热线：400-601-2228"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if styleArr[indexPath.section] == "connect" {
            UIApplication.shared.openURL(URL(string: "telprompt://4006012228")!)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch styleArr[section] {
        case "earning":
            return 0.01
        default:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch styleArr[indexPath.section] {
        case "earning":
            return 120
        case "manager":
            if indexPath.row == 0 {
                return 30
            }else {
//                let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
//                let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
                
//                if token != nil, userid != nil  {
                return profile_manage_perRowHeight * 4
//                }else {
//                    return profile_manage_perRowHeight * 3
//                }
            }
            
        case "news":
            if indexPath.row == 0 {
                return 30
            }else {
                return profile_manage_perRowHeight
            }
        default:
            return 44
        }
    }
    
    
    // MARK:- 管理cell 点击事件
    private func manageCellItemClicked(_ manageModel: XHProfileManageModel, tableView: UITableView) {
        if manageModel.mg_targetVc != "" {
            
            self.setChildViewControllerNav()
            
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let targetVC = NSClassFromString(namespace + "." + manageModel.mg_targetVc!) as! UIViewController.Type
            let VC = targetVC.init()
            VC.title = manageModel.mg_title
            if manageModel.mg_title != "荐码" {
                self.navigationController?.pushViewController(VC, animated: true)
            }else {
                let nav = UINavigationController(rootViewController: VC)
                self.present(nav, animated: true, completion: nil)
            }
            
        }else {
            XHAlertController.showAlert(title: "退出登录", message: "退出后将无法获取用户信息，您确定要退出吗？", Style: .alert, confirmTitle: "确定", confirmComplete: { [weak self] in
                self?.showHud(in: (self?.view)!)
                SSKeychain.deletePassword(forService: userTokenName, account: "TOKEN")
                SSKeychain.deletePassword(forService: userTokenName, account: "USERID")
                self?.styleArr = ["earning", "manager", "news", "connect"]
                self?.userEarningModel = XHUserEarningModel()
                NSKeyedArchiver.archiveRootObject(XHUserEarningModel(), toFile: userEarningPath)
                self?.setHeaderDragableIamge()
                tableView.reloadData()
                //延时1秒执行
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    self?.hideHud()
                }
            })
        }
    }
    
    // MARK:- 咨询中心cell点击事件
    private func newsCenterCellItemClicked(_ manageModel: XHProfileManageModel) {
        if manageModel.mg_targetVc != "" {
            
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let targetVC = NSClassFromString(namespace + "." + manageModel.mg_targetVc!) as! UIViewController.Type
            let VC = targetVC.init()
            VC.title = manageModel.mg_title
            
            if manageModel.mg_targetVc == "XHRecommendController" {
                
                self.presentRecommendViewController(controller: VC)
            }else {
                self.setChildViewControllerNav()
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else {
            self.setChildViewControllerNav()
            let webView = XHWebViewController()
            webView.urlStr = "http://wx2.zxhshop.cn/download/wliao.html"
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
}
