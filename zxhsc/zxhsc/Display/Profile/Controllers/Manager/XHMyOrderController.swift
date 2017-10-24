//
//  XHMyOrderController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh
enum OrderType {
    case all        // 所有
    case obligation // 待付款
    case shipments  // 待发货
    case shipped    // 已发货
    case finished   // 已完成
    case canceled  // 已取消
}


class XHMyOrderController: UIViewController, XHPageViewControllerDelegate {

        /// 子标题
    private lazy var subTitleArr: [String] = ["全部", "待付款", "待发货", "已发货", "已完成"]
    fileprivate let reuseId = "XHMyOrderController_reuseId_OFFLINE"
    fileprivate var page: Int = 0
    fileprivate var offlineDataArr: [XHShopOfflineOrderModel] = []
    
    /// 子控制器
    var controllers: [XHOrderDetailController] = [XHOrderDetailController(), XHOrderDetailController(), XHOrderDetailController(), XHOrderDetailController(), XHOrderDetailController()]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNav()
        
        setupPageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        page += 1
        let paraDict = ["page": "\(page)", "status": "0"]
        XHMyOrderViewModel.getMyOrder_offlineOrdersList(paraDict: paraDict, self, tableView: tableView) { [weak self] (result) in
            self?.tableView.mj_header.endRefreshing()
            if result is [XHShopOfflineOrderModel] {
                let modelsArr = result as! [XHShopOfflineOrderModel]
                self?.offlineDataArr.append(contentsOf: modelsArr)
                if self?.offlineDataArr.count != 0 {
                    self?.setupOfflineView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
                
                if self?.tableView.mj_footer != nil {
                    if modelsArr.count == 0 {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
            }
        } 
    }
    
    // MARK:- segmentControl的切换事件
    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           setupPageView()
            TalkingData.trackPageBegin("线上订单页面")
            TalkingData.trackPageEnd("线下订单页面")
        }else {
            setupOfflineView()
            TalkingData.trackPageBegin("线下订单页面")
            TalkingData.trackPageEnd("线上订单页面")
            loadData()
        }
    }
    
    @objc private func refresh() {
        loadData()
    }
    
    @objc private func headerRefresh() {
        page = 0
        offlineDataArr.removeAll()
        loadData()
    }
        
    // MARK:- ==== 界面相关 ======
    private func setupPageView() {
        pageViewController.tipBtnNormalColor = XHRgbColorFromHex(rgb: 0x666666)
        pageViewController.tipBtnHighlightedColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.sliderColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.tipBtnFontSize = 14
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        pageViewController.delegate?.xh_MenuPageCurrentSubController(index: 0, menuPageController: pageViewController)
    }
    
    // MARK:- 布局线下消费订单视图
    private func setupOfflineView() {
        pageViewController.view.removeFromSuperview()
        setupTableView()
    }
    
    private func setupTableView() {
        emptyL.removeFromSuperview()
        emptyImgView.removeFromSuperview()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        tableView.register(UINib(nibName: "XHMyShop_OfflineCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }
    
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(124)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }
    
    private func setupNav() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.titleView = segmentControl
    }
    
    // MARK:- 懒加载
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // pageView
    private lazy var pageViewController: XHPageViewController = {
        let vc: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        vc.delegate = self
        view.addSubview(vc.view)
        return vc
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let items = ["线上订单", "线下订单"]
        let segmentC = UISegmentedControl(items: items)
        segmentC.selectedSegmentIndex = 0
        segmentC.tintColor = XHRgbColorFromHex(rgb: 0xea2000)
        segmentC.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        segmentC.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return segmentC
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 168
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "order_nothing"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.text = "亲，您暂时没有相关订单~"
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

extension XHMyOrderController {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        
        switch index {
        case 0:
            controller.orderType = .all
        case 1:
            controller.orderType = .obligation
        case 2:
            controller.orderType = .shipments
        case 3:
            controller.orderType = .shipped
        case 4:
            controller.orderType = .finished
        default:
            break
        }
    }
}

extension XHMyOrderController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return offlineDataArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHMyShop_OfflineCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHMyShop_OfflineCell
        cell.orderModel = offlineDataArr[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
