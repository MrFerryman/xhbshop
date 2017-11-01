//
//  XHOrderDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHOrderDetailController: UIViewController {
    
    var orderType: OrderType = .all {
        didSet {
            page = 0
            cancelRequest?.cancelRequest()
            setupEmptyUI()
            loadData()
        }
    }
    
    /// 页
    fileprivate var page: Int = 0
    fileprivate var cancelRequest: XHCancelRequest?
    
    fileprivate let reuseId = "XHOrderDetailController_reuseId"
    
    // 有无订单
    fileprivate let isEmpty: Bool = false
    /// 数据数组
    fileprivate var orderList: [XHMyOrderModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyUI()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHud()
    }
    
    fileprivate func loadData() {
        var type: String = "0" // 0 - 全部 1 - 待发货 2 - 已发货 3 - 待付款 4 - 已完成
        switch orderType {
        case .all, .jiu_xi_goods: // 全部
            type = "0"
        case .obligation: // 待付款
            type = "3"
        case .shipments: // 待发货
            type = "1"
        case .shipped: // 已发货
            type = "2"
        case .finished: // 已完成
            type = "4"
        default:
            break
        }
        page += 1
        var paraDict = ["status": type, "page": "\(page)"]
        
        if orderType == .jiu_xi_goods {
            paraDict["style"] = "1"
        }else {
            paraDict["style"] = "0"
        }
        showHud(in: view)
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .getMyOrderList, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            if self?.tableView.mj_footer != nil {
                self?.tableView.mj_footer.endRefreshing()
            }
            
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            
            self?.setupEmptyUI()
            self?.emptyImgView.image = UIImage(named: "net_error")
            self?.emptyL.text = "您的网络状态不佳，请重新尝试~"
        }, success: { [weak self] (sth) in
            self?.hideHud()
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            if sth is [XHMyOrderModel] {
                if self?.page == 1 {
                    self?.orderList.removeAll()
                }
                let arr = sth as! [XHMyOrderModel]
                self?.orderList.append(contentsOf: arr)
                if self?.orderList.count != 0 {
                    self?.setupTableView()
                }else {
                    self?.setupEmptyUI()
                    self?.emptyImgView.image = UIImage(named: "order_nothing")
                    self?.emptyL.text = "亲，您暂时没有相关订单~"
                }
                
                if self?.tableView.mj_footer != nil {
                    if arr.count == 0 {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
                self?.tableView.reloadData()
            }
        })
    }
    
    @objc private func refresh() {
        loadData()
    }
    
    @objc private func headerRefresh() {
        page = 0
        loadData()
    }
    
    // MARK:- 退货申请
    fileprivate func salesReturn(orderModel: XHMyOrderModel) {
        
        XHAlertController.showAlert(title: "提示", message: "确认您要申请退货吗？", Style: .actionSheet, confirmTitle: "确定") { [weak self] in
            let reasonV = XHSalesReturnReasonController()
            reasonV.orderModel = orderModel
            self?.navigationController?.pushViewController(reasonV, animated: true)
        }
    }
    
    // MARK:- 界面相关
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(60)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }
    
    // MARK:- tableView的设置
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }
    
    // MARK:- 懒加载
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 213
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

extension XHOrderDetailController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderList.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHMyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHMyOrderTableViewCell
        let model = orderList[indexPath.section]
        cell.orderModel = model
        
        /// MARK:- 按钮的点击事件回调
        cell.cellButtonClickedClosure = { [weak self] sender, orderModel in
            let paraDict = ["order_id": (orderModel.id)!]
            switch sender.tag {
            case 1001: // 取消订单
                XHMyOrderViewModel.cancelMyOrder(paraDict: paraDict, self! , dataClosure: { (sth) in
                    self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    if sth is String {
                        if (sth as! String) == "取消成功" {
                            self?.page = 0
                            self?.loadData()
                        }else if (sth as! String).isEmpty == true {
                            self?.showHint(in: (self?.view)!, hint: "订单异常~")
                        }
                    }
                })
            case 1002: // 去付款
                let pay = XHFukuanStyleController()
                pay.comeFrom = .myOrder
                
                let cartModel = XHShoppingCartModel()
                cartModel.id = orderModel.id
                cartModel.goods_id = orderModel.id
                cartModel.icon = orderModel.icon
                cartModel.name = orderModel.title
                cartModel.xhb = orderModel.xhb
                cartModel.price = orderModel.price
                cartModel.buyCount = orderModel.number
                cartModel.property1 = orderModel.property
                cartModel.property2 = orderModel.property2
                cartModel.integral = orderModel.gift

                pay.shoppingCartList = [cartModel]
                pay.orderId = orderModel.id
                pay.comeFrom = .myOrder
                if NSString(string: orderModel.price ?? "0").floatValue == 0.0, NSString(string: orderModel.gift ?? "0").floatValue != 0.0 {
                    let integralPay = XHIntegral_PaymentController()
                    integralPay.comeFrom = .myOrder
                    integralPay.orderId = orderModel.id
                    self?.navigationController?.pushViewController(integralPay, animated: true)
                }else {
                    self?.navigationController?.pushViewController(pay, animated: true)
                }
            case 1003: // 删除订单
                XHMyOrderViewModel.removeMyOrder(paraDict: paraDict, self!, dataClosure: { (sth) in
                    self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    if sth is String {
                        if (sth as! String) == "删除成功" {
                            var index: Int?
                            for i in 0 ..< (self?.orderList.count)! {
                                if self?.orderList[i].id == orderModel.id {
                                    index = i
                                }
                            }
                            if index != nil {
                                self?.orderList.remove(at: index!)
                                tableView.reloadData()
                            }
                        }
                    }
                })
            case 1004: // 查看物流
                let logistics = XHLogisticsDetailController()
                logistics.orderModel = orderModel
                self?.navigationController?.pushViewController(logistics, animated: true)
            case 1005: // 确认收货
                let paraDict = ["order_id": (orderModel.id)!]
                XHMyOrderViewModel.confirmGotSales(paraDict: paraDict, self!, dataClosure: { (sth) in
                    if sth is String {
                        self?.showHint(in: (self?.view)!, hint: (sth as! String))
                        if (sth as! String) == "操作成功" {
                            self?.loadData()
                        }else if (sth as! String) == "请登录" {
                            let login = XHLoginController()
                            let nav = UINavigationController(rootViewController: login)
                            self?.present(nav, animated: true, completion: nil)
                        }
                    }else {
                        self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    }
                })
                
            case 1006: // 申请退货
                self?.salesReturn(orderModel: orderModel)
            default:
                break
            } 
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderStatus = XHOrderStatusController()
        let orderModel = orderList[indexPath.section]
        switch orderModel.status! {
        case "待付款":
            orderStatus.orderStatus = .obligation
        case "待发货":
            orderStatus.orderStatus = .shipments
        case "已发货":
            orderStatus.orderStatus = .shipped
        case "订单完成":
            orderStatus.orderStatus = .finished
        case "订单取消":
            orderStatus.orderStatus = .canceled
        default:
            break
        }
        orderStatus.orderId = orderModel.id
        navigationController?.pushViewController(orderStatus, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
