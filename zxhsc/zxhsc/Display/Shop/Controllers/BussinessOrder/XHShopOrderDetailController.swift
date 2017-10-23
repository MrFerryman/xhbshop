//
//  XHShopOrderDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  订单控制器

/// 个人订单状态
enum PersonalOrderStatus {
    case waitToFukuan // 等待付款
    case waitToSend // 等待发货
    case waitToGet  // 等待收货
    case waitToConfirmGet // 等待确认收货
    case finished      // 订单完成
    case canceled    // 订单取消
    case applyForReturn // 申请退货
    case confirmReturn  // 确认退货
}

import UIKit
import MJRefresh

class XHShopOrderDetailController: UIViewController {
    
    fileprivate let reuseId_customer = "XHShopOrderDetailController_reuseIdcustomer"
    fileprivate let reuseId_shop = "XHShopOrderDetailController_reuseId_shop"
    fileprivate let reuseId_offline = "XHShopOrderDetailController_reuseId_shop_offline"
    
    fileprivate var dataArr: [XHShop_customerOrdersModel] = []
    fileprivate var offlineDataArr: [XHShopOfflineOrderModel] = []
    fileprivate var page: Int = 0
    fileprivate var offlinePage: Int = 0
    fileprivate var currentStatus: String = "0"
    
    /// 是否是退货
    var isReturnSales: Bool = false
    /// 是否是线下订单
    fileprivate var isOfflineOrder: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户订单"
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        
        setupNav()
        
        setupTableView()
        
        if isReturnSales == true {
            currentStatus = "6"
        }
        
        if isReturnSales == false {
            UIApplication.shared.keyWindow?.addSubview(filterButton)
            filterButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(UIApplication.shared.keyWindow!)
                make.bottom.equalTo(UIApplication.shared.keyWindow!).offset(-15)
                make.width.height.equalTo(46)
            })
        }
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterButton.removeFromSuperview()
    }
    
    private func loadData() {
        page += 1
        let paraDict = ["status": currentStatus, "page": "\(page)"]
        
        XHShop_customerOrder_ViewModel.getShop_customerOrdersList(paraDict, self) { [weak self] (result) in
            if result is [XHShop_customerOrdersModel] {
                if (result as! [XHShop_customerOrdersModel]).count == 0 {
                    if self?.tableView.mj_footer != nil {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
                
                self?.dataArr.append(contentsOf: result as! [XHShop_customerOrdersModel])
                if self?.dataArr.count == 0 {
                    self?.setupEmptyUI()
                }else {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                    if self?.tableView.mj_footer != nil {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
            }else {
                self?.showHint(in: (self?.view)!, hint: "\(result as! String)")
                if self?.tableView.mj_footer != nil {
                    self?.tableView.mj_footer.endRefreshing()
                }
            }
        }
    }
    
    // MARK:- 获取店铺线下消费订单列表
    private func getOfflineOrdersList() {
        offlinePage += 1
        let paraDict = ["page": "\(offlinePage)", "status": "0"]
        XHShop_customerOrder_ViewModel.getMyShop_offlineOrdersList(paraDict, self, tableView: tableView) { [weak self] (result) in
            if result is [XHShopOfflineOrderModel] {
                self?.offlineDataArr.append(contentsOf: result as! [XHShopOfflineOrderModel])
                if (result as! [XHShopOfflineOrderModel]).count == 0 {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self?.tableView.mj_footer.endRefreshing()
                }
                if self?.offlineDataArr.count != 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }
        }
    }
    
    // MARK:- ======= 事件相关 ========
    // MARK:- 筛选按钮点击事件
    @objc private func filterButtonClicked(_ sender: UIButton) {
        
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints({ (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-15)
            make.width.height.equalTo(46)
        })
        
        let composeView = WQComposeView()
         composeView.show(self)
        composeView.composeButtonsClickClosure = { [weak self] sender in
            
            self?.page = 0
            self?.dataArr.removeAll()
            switch sender.tag {
            case 0: // 已取消
                self?.currentStatus = "5"
            case 1: // 待付款
                self?.currentStatus = "1"
            case 2: // 待发货
                self?.currentStatus = "2"
            case 3: // 已发货
                self?.currentStatus = "3"
            case 4: // 已完成
                self?.currentStatus = "4"
            default:
                break
            }
            
            if self?.isReturnSales == false {
                UIApplication.shared.keyWindow?.addSubview((self?.filterButton)!)
                self?.filterButton.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(UIApplication.shared.keyWindow!)
                    make.bottom.equalTo(UIApplication.shared.keyWindow!).offset(-15)
                    make.width.height.equalTo(46)
                })
            }

            self?.loadData()
        }
    }
    
    // MARK:- 上拉更多
    @objc private func upDragMoreData() {
        loadData()
    }
    
    // MARK:- segmentControl的切换事件
    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isOfflineOrder = false
            filterButton.isHidden = false
            dataArr.removeAll()
            UIApplication.shared.keyWindow?.addSubview(filterButton)
            filterButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(UIApplication.shared.keyWindow!)
                make.bottom.equalTo(UIApplication.shared.keyWindow!).offset(-15)
                make.width.height.equalTo(46)
            })
            page = 0
            loadData()
        }else {
            filterButton.isHidden = true
            filterButton.removeFromSuperview()
            offlineDataArr.removeAll()
            isOfflineOrder = true
            offlinePage = 0
            getOfflineOrdersList()
        }
    }
    
    // MARK:- ======= 界面相关 =======
    private func setupTableView() {
        emptyL.removeFromSuperview()
        emptyImgView.removeFromSuperview()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.rowHeight = 168
        
        tableView.register(UINib(nibName: "XHCustomerOrderCell", bundle: nil), forCellReuseIdentifier: reuseId_customer)
        tableView.register(UINib(nibName: "XHMyShop_OfflineCell", bundle: nil), forCellReuseIdentifier: reuseId_offline)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(upDragMoreData))
    }
    
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        filterButton.removeFromSuperview()
        
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
        
        if isReturnSales == false {
            UIApplication.shared.keyWindow?.addSubview(filterButton)
            filterButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(UIApplication.shared.keyWindow!)
                make.bottom.equalTo(UIApplication.shared.keyWindow!).offset(-15)
                make.width.height.equalTo(46)
            })
        }
    }
    
    private func setupNav() {
        if isReturnSales == false {
            navigationItem.titleView = segmentControl
        }
    }
    
    // MARK:- 懒加载
    // tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    /// 筛选按钮
    private lazy var filterButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setBackgroundImage(UIImage(named: "Oval 10"), for: .normal)
        btn.setImage(UIImage(named: "shop_order_Filter"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(filterButtonClicked(_:)), for: .touchUpInside)
        return btn
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
    
}
extension XHShopOrderDetailController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return isOfflineOrder == false ? dataArr.count : offlineDataArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isOfflineOrder == false {
            let cell: XHCustomerOrderCell = tableView.dequeueReusableCell(withIdentifier: reuseId_customer, for: indexPath) as! XHCustomerOrderCell
            cell.model = dataArr[indexPath.section]
            return cell
        }
        
        let cell: XHMyShop_OfflineCell = tableView.dequeueReusableCell(withIdentifier: reuseId_offline, for: indexPath) as! XHMyShop_OfflineCell
        cell.orderModel = offlineDataArr[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isOfflineOrder == false {
            let model = dataArr[indexPath.section]
            let personal = XHPersonalOrderDetailController()
            switch (model.status)! {
            case "订单取消":
                personal.orderStatus = .canceled
            case "待发货":
                personal.orderStatus = .waitToSend
            case "待付款":
                personal.orderStatus = .waitToFukuan
            case "已发货":
                personal.orderStatus = .waitToGet
            case "订单完成":
                personal.orderStatus = .finished
            default:
                personal.orderStatus = .canceled
            }
            
            if model.status_id == "1" {
                personal.orderStatus = .applyForReturn
            }
            
            personal.orderId = model.id
            navigationController?.pushViewController(personal, animated: true)
        }else {
            let bussOrder = XHBussinessOrderDetailController()
            bussOrder.order_id = offlineDataArr[indexPath.section].id
            navigationController?.pushViewController(bussOrder, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
}
