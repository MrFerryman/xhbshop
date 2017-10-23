//
//  XHOrderStatusController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

/// 订单详情界面cell的样式
///
/// - Logistics: ///物流信息
/// - Consignee: ///收货人
/// - SalesDetail: ///商品详情
/// - OrderDetail: ///订单详情
/// - UserPhone: ///用户手机
enum cellStyle {
    case Logistics     /// 物流信息
    case Consignee   /// 收货人
    case salesReturn /// 退货
    case SalesDetail  /// 商品详情
    case OrderDetail  /// 订单详情
    case UserPhone   /// 用户手机
}


class XHOrderStatusController: UIViewController {

    var orderStatus: OrderType = .obligation
    
    var orderId: String? {
        didSet {
            loadData()
        }
    }
    fileprivate var orderModel: XHMyOrderModel? {
        didSet {
            if orderStatus == .obligation || orderStatus == .shipments { /// 待付款 或 待发货
                cellStylesArr = [cellStyle.SalesDetail, cellStyle.OrderDetail, cellStyle.UserPhone ]
            }else {
                cellStylesArr = [cellStyle.Consignee, cellStyle.SalesDetail, cellStyle.OrderDetail, cellStyle.UserPhone ]
            }
            
            if orderModel?.salesReturnStatus == "1" {
                cellStylesArr.insert(cellStyle.salesReturn, at: 0)
            }
            
            if orderModel?.salesReturnStatus == "1" {
                bottomView.removeFromSuperview()
            }
        }
    }
    
    fileprivate let reuseId_Logistics = "XHOrderStatusController_reuseId_Logistics" // 物流信息
    fileprivate let reuseId_Consignee = "XHOrderStatusController_reuseId_Consignee" // 收货人
    fileprivate let reuseId_salesReturn = "XHOrderStatusController_reuseId_SalesReturn" // 退货信息
    fileprivate let reuseId_SalesDetail = "XHOrderStatusController_reuseId_SalesDetail" // 商品详情
    fileprivate let reuseId_OrderDetail = "XHOrderStatusController_reuseId_OrderDetail" // 订单详情
    fileprivate let reuseId_OrderDetail_obligation = "XHOrderStatusController_reuseId_OrderDetail_obligation"  // 待付款
    fileprivate let reuseId_UserPhone = "XHOrderStatusController_reuseId_UserPhone"
    
    /// 用来控制cell的样式
    fileprivate var cellStylesArr: [cellStyle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        
        setupNav()
        
        if orderStatus == .obligation || orderStatus == .shipments { /// 代付款 或 待发货
            cellStylesArr = [cellStyle.Consignee, cellStyle.SalesDetail, cellStyle.OrderDetail, cellStyle.UserPhone ]
        }else {
            cellStylesArr = [cellStyle.Logistics, cellStyle.Consignee, cellStyle.SalesDetail, cellStyle.OrderDetail, cellStyle.UserPhone ]
        }
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func loadData() {
        let paraDict = ["orderid": (orderId)!]
        XHMyOrderViewModel.getMyOrderDetail(paraDict: paraDict, self) { [weak self] (result) in
            if result is XHMyOrderModel {
                self?.orderModel = result as? XHMyOrderModel
                self?.tableView.reloadData()
            }else {
                if result is String {
                    if (result as! String) == "请重新登陆！" {
                        let login = XHLoginController()
                        let nav = UINavigationController(rootViewController: login)
                        self?.present(nav, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(-46)
        }
        
        tableView.separatorColor = XHRgbColorFromHex(rgb: 0xeeeeee)
        tableView.register(UINib(nibName: "XHOrderStatusLogiCell", bundle: nil), forCellReuseIdentifier: reuseId_Logistics)
        tableView.register(UINib(nibName: "XHOrderStatusConsCell", bundle: nil), forCellReuseIdentifier: reuseId_Consignee)
        tableView.register(UINib(nibName: "XHOrderStatusSalesReturnCell", bundle: nil), forCellReuseIdentifier: reuseId_salesReturn)
        tableView.register(UINib(nibName: "XHOrderStatusSalesCell", bundle: nil), forCellReuseIdentifier: reuseId_SalesDetail)
        tableView.register(UINib(nibName: "XHOrderStatusOrderDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_OrderDetail)
        tableView.register(UINib(nibName: "XHOrderStatusOrderDetail_obligationCell", bundle: nil), forCellReuseIdentifier: reuseId_OrderDetail_obligation)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_UserPhone)
        
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 64)
        headerView.orderStatus = orderStatus
        tableView.tableHeaderView = headerView
        
        /// 底部按钮视图
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(46)
        }
        
        bottomView.cellType = orderStatus
        bottomView.backgroundColor = .white
        bottomView.buttonClickedClosure = { [weak self] sender in
            let paraDict = ["order_id": (self?.orderModel?.id)!]
            switch sender.tag {
            case 1001: // 取消订单
                XHMyOrderViewModel.cancelMyOrder(paraDict: paraDict, self! , dataClosure: { (sth) in
                    self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    if sth is String {
                        if (sth as! String) == "取消成功" {
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
                cartModel.id = self?.orderModel?.id
                cartModel.goods_id = self?.orderModel?.id
                cartModel.icon = self?.orderModel?.icon
                cartModel.name = self?.orderModel?.title
                cartModel.xhb = (self?.orderModel?.xhb)!
                cartModel.price = self?.orderModel?.price
                cartModel.buyCount = self?.orderModel?.number
                cartModel.property1 = self?.orderModel?.property
                cartModel.property2 = self?.orderModel?.property2
                cartModel.integral = self?.orderModel?.gift
                
                pay.shoppingCartList = [cartModel]
                pay.orderId = self?.orderModel?.id
                pay.comeFrom = .myOrder
                self?.navigationController?.pushViewController(pay, animated: true)
            case 1003: // 删除订单
                XHMyOrderViewModel.removeMyOrder(paraDict: paraDict, self!, dataClosure: { (sth) in
                    self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    if sth is String {
                        if (sth as! String) == "删除成功" {
                            let time: TimeInterval = 0.5
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                })
            case 1004: // 查看物流
                let logistics = XHLogisticsDetailController()
                logistics.orderModel = self?.orderModel
                self?.navigationController?.pushViewController(logistics, animated: true)
            case 1005: // 确认收货
                let paraDict = ["order_id": (self?.orderModel?.id)!]
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
                XHAlertController.showAlert(title: "提示", message: "确认您要申请退货吗？", Style: .actionSheet, confirmTitle: "确定") { [weak self] in
                    let reasonV = XHSalesReturnReasonController()
                    reasonV.orderModel = self?.orderModel
                    self?.navigationController?.pushViewController(reasonV, animated: true)
                }
            default:
                break
            }
        }
    }
    
    private func setupNav() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        title = "订单详情"
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK:- ===== 懒加载 ========
    /// tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var headerView: XHOrderStatusHeaderView = XHOrderStatusHeaderView()
    
    private lazy var bottomView: XHMyOrderButtonView = XHMyOrderButtonView()
}

extension XHOrderStatusController: UITableViewDelegate,UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
       return cellStylesArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type: cellStyle = cellStylesArr[indexPath.section]
        switch type {
        case .Logistics: // 物流信息
            let cell: XHOrderStatusLogiCell = tableView.dequeueReusableCell(withIdentifier: reuseId_Logistics, for: indexPath) as! XHOrderStatusLogiCell
            cell.orderModel = orderModel
            return cell
            
        case .salesReturn: // 退货信息
            let cell: XHOrderStatusSalesReturnCell = tableView.dequeueReusableCell(withIdentifier: reuseId_salesReturn, for: indexPath) as! XHOrderStatusSalesReturnCell
            cell.orderModel = orderModel
            return cell
        case .Consignee: // 收货人信息
            let cell: XHOrderStatusConsCell = tableView.dequeueReusableCell(withIdentifier: reuseId_Consignee, for: indexPath) as! XHOrderStatusConsCell
            cell.orderModel = orderModel
            return cell
        case .SalesDetail: // 商品信息
            let cell: XHOrderStatusSalesCell = tableView.dequeueReusableCell(withIdentifier: reuseId_SalesDetail, for: indexPath) as! XHOrderStatusSalesCell
            cell.orderModel = orderModel
            // 电话拨打
            cell.phoneNumberCallClicked = { [weak self] in
                UIApplication.shared.openURL(URL(string: "telprompt://\((self?.orderModel?.shop_phone)!)")!)
            }
            
            /// 商品视图点击
            cell.goodsViewClickedClosure = { [weak self] orderModel in
//                let goodsV = XHGoodsDetailController()
//                goodsV.goodsId = orderModel.id
//                self?.navigationController?.pushViewController(goodsV, animated: true)
            }
            
            return cell
            
        case .OrderDetail: // 订单详情
            if orderStatus == .obligation {
                let cell: XHOrderStatusOrderDetail_obligationCell = tableView.dequeueReusableCell(withIdentifier: reuseId_OrderDetail_obligation, for: indexPath) as! XHOrderStatusOrderDetail_obligationCell
                cell.orderModel = orderModel
                return cell
            }
            let cell: XHOrderStatusOrderDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_OrderDetail, for: indexPath) as! XHOrderStatusOrderDetailCell
            cell.orderModel = orderModel
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_UserPhone, for: indexPath)
            let fontL = UILabel()
            fontL.text = "用户账号"
            fontL.textColor = XHRgbColorFromHex(rgb: 0x666666)
            fontL.font = UIFont.systemFont(ofSize: 12)
            cell.addSubview(fontL)
            fontL.snp.makeConstraints({ (make) in
                make.left.equalTo(16)
                make.centerY.equalTo(cell)
            })
            let numberL = UILabel()
            numberL.textColor = XHRgbColorFromHex(rgb: 0x666666)
            numberL.font = UIFont.systemFont(ofSize: 12)
            cell.addSubview(numberL)
            numberL.snp.makeConstraints({ (make) in
                make.centerY.equalTo(cell)
                make.left.equalTo(fontL.snp.right).offset(15)
            })
            
            numberL.text = orderModel?.shop_phone
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
