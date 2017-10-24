//
//  XHDiscoveryViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHDiscoveryViewController: UIViewController {

    fileprivate let reuseId_lottery = "XHDiscoveryViewController_lottery"
    fileprivate let reuseId_integral = "XHDiscoveryViewController_integral"
    
    fileprivate let viewName = "tab_发现页"
    
    /// 抽奖列表
    fileprivate var lottoryList: Array<XHLottoryModel> = []
    /// 积分商品列表
    fileprivate var integralGoodsList: Array<XHDiscoveryGoodsModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupNav()
        
        setupTableView()
        
//        if NSKeyedUnarchiver.unarchiveObject(withFile:lottoryListPath) != nil {
//
//            lottoryList = NSKeyedUnarchiver.unarchiveObject(withFile: lottoryListPath) as! [XHLottoryModel]
//            tableView.reloadSections([0], with: .automatic)
//        }
//
        if NSKeyedUnarchiver.unarchiveObject(withFile:discoveryGoodsPath) != nil {
            
            integralGoodsList = NSKeyedUnarchiver.unarchiveObject(withFile: discoveryGoodsPath) as! [XHDiscoveryGoodsModel]
            tableView.reloadSections([0], with: .automatic)
        }
        
//        getLottoryList()
        
        getIntegralGoodsList()
        
//        UIApplication.shared.keyWindow?.addSubview(maskView)
//        maskView.snp.makeConstraints { (make) in
//            make.edges.equalTo(UIApplication.shared.keyWindow!)
//        }
        
//        maskView.nowStartButtonClickedClosure = { [weak self] in
//
//            self?.maskView.removeFromSuperview()
//
//            let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
//            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
//            if token != nil, userid != nil {
//                self?.setupChildViewController()
//                let webView = XHWebViewController()
//                var userInfo = Dictionary<String, String>()
//                userInfo["userid"] = userid!
//                userInfo["userkey"] = token!
//
//                let urlStr = "http://lott.zxhshop.cn/turnplate/index.html?user=false" + "&userid=" + "\(userid!)" + "&userkey=" + "\(token!)"
//
//                webView.urlStr = urlStr
//                self?.navigationController?.pushViewController(webView, animated: true)
//                return
//            }
//            let login = XHLoginController()
//            let nav = XHNavigationController(rootViewController: login)
//            self?.present(nav, animated: true, completion: nil)
//        }
//
//        maskView.closeButtonClickedClosure = { [weak self] in
//            self?.maskView.removeFromSuperview()
//        }
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
        TalkingData.trackPageEnd(viewName)
    }
    
//    // MARK:- 获取抽奖列表
//    private func getLottoryList() {
//        XHDiscoveryViewModel.getLottoryList(self) { [weak self] (result) in
//            if result is [XHLottoryModel] {
//                self?.lottoryList = result as! [XHLottoryModel]
//                self?.tableView.reloadSections([0], with: .automatic)
//            }else {
//                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
//            }
//        }
//    }
    
    // MARK:- 获取积分兑换商品
    private func getIntegralGoodsList() {
        XHDiscoveryViewModel.getIntegralGoodsList(self) { [weak self] (result) in
            if result is [XHDiscoveryGoodsModel] {
                self?.integralGoodsList = result as! [XHDiscoveryGoodsModel]
                self?.tableView.reloadSections([0], with: .automatic)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 活动规则按钮点击事件
    @objc fileprivate func regularButtonClicked() {
        setupChildViewController()
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

    // MARK:- 界面相关 
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(64)
            make.bottom.equalTo(-44)
        }
        
        tableView.register(UINib(nibName: "XHDiscoveryLottoryCell", bundle: nil), forCellReuseIdentifier: reuseId_lottery)
        tableView.register(UINib(nibName: "XHDiscoveryIntegralCell", bundle: nil), forCellReuseIdentifier: reuseId_integral)
        
        tableView.tableHeaderView = headerView
        headerView.cycleImgViewClickedClosure = { [weak self] index in
            switch index {
            case 0:
                self?.setupChildViewController()
                let winning = XHWinningMsgController()
//                winning.type = self?.lottoryList[0].type
                self?.navigationController?.pushViewController(winning, animated: true)
            case 1:
//                self?.setupChildViewController()
//                let integralV = XHIntegralController()
//                self?.navigationController?.pushViewController(integralV, animated: true)
                self?.regularButtonClicked()
            case 2:
                let shake = XHIntegralController()
                self?.setupChildViewController()
                self?.navigationController?.pushViewController(shake, animated: true)
            default:
                break
            }
        }
        
    }
    
    fileprivate func setupChildViewController() {
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNav() {
        title = "发现"
    }
    
    // MARK:- 懒加载
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    private lazy var headerView: XHDiscoveryHeaderView = XHDiscoveryHeaderView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: kUIScreenWidth * 165 / 375))
    
//    fileprivate lazy var lottoryTitle: UILabel = {
//       let label = UILabel()
//        label.text = "汽车抽奖专题"
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
//        return label
//    }()
    
//    fileprivate lazy var lottoryIcon: UIImageView = UIImageView(image: UIImage(named: "discovery_click"))
    
//    fileprivate lazy var regularButton: UIButton = {
//       let btn = UIButton(type: .custom)
//        btn.setTitle("活动规则", for: .normal)
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        btn.backgroundColor = XHRgbColorFromHex(rgb: 0x5AA6FF)
//        btn.layer.cornerRadius = 6
//        btn.layer.masksToBounds = true
//        btn.addTarget(self, action: #selector(regularButtonClicked), for: .touchUpInside)
//        return btn
//    }()
    
    // 积分商品表头
    fileprivate lazy var integralTitle: UILabel = {
        let label = UILabel()
        label.text = "积分商品"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    fileprivate lazy var leftIconView: UIImageView = UIImageView(image: UIImage(named: "discovery_left"))
    
    fileprivate lazy var rightIconView: UIImageView = UIImageView(image: UIImage(named: "discovery_right"))
    
//    fileprivate lazy var maskView: XHDiscoveryMaskView = Bundle.main.loadNibNamed("XHDiscoveryMaskView", owner: nil, options: nil)?.last as! XHDiscoveryMaskView
}
extension XHDiscoveryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return lottoryList.count
//        default:
            return integralGoodsList.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell: XHDiscoveryLottoryCell = tableView.dequeueReusableCell(withIdentifier: reuseId_lottery, for: indexPath) as! XHDiscoveryLottoryCell
//            cell.lottoryModel = lottoryList[indexPath.row]
//            return cell
//        }
        let cell: XHDiscoveryIntegralCell = tableView.dequeueReusableCell(withIdentifier: reuseId_integral, for: indexPath) as! XHDiscoveryIntegralCell
        cell.goodsModel = integralGoodsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
            let goodsDetail = XHGoodsDetailController()
            goodsDetail.isIntegral = true
            goodsDetail.goodsId = integralGoodsList[indexPath.row].id
            
            setupChildViewController()
            navigationController?.pushViewController(goodsDetail, animated: true)
//            return
//        }
        
//        regularButtonClicked()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 80
//        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return 8
//        default:
            return 0.01
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            let headerView = UIView()
//            headerView.backgroundColor = .white
//            headerView.addSubview(lottoryTitle)
//            lottoryTitle.snp.makeConstraints({ (make) in
//                make.left.equalTo(16)
//                make.centerY.equalTo(headerView)
//            })
//
//            headerView.addSubview(lottoryIcon)
//            lottoryIcon.snp.makeConstraints({ (make) in
//                make.left.equalTo(lottoryTitle.snp.right).offset(5)
//                make.centerY.equalTo(headerView)
//            })
//
//            headerView.addSubview(regularButton)
//            regularButton.snp.makeConstraints({ (make) in
//                make.right.equalTo(-16)
//                make.width.equalTo(60)
//                make.centerY.equalTo(headerView)
//            })
//
//            return headerView
//        default:
            let headerView = UIView()
            headerView.backgroundColor = .white
            headerView.addSubview(integralTitle)
            integralTitle.snp.makeConstraints({ (make) in
                make.center.equalTo(headerView)
            })
            
            headerView.addSubview(leftIconView)
            leftIconView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerView)
                make.right.equalTo(integralTitle.snp.left).offset(-5)
                make.width.equalTo(42)
                make.height.equalTo(21)
            })
            
            headerView.addSubview(rightIconView)
            rightIconView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerView)
                make.left.equalTo(integralTitle.snp.right).offset(5)
                make.width.equalTo(35)
                make.height.equalTo(18)
            })
            
            return headerView
//        }
    }
}
