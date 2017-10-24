//
//  XHPersonalOrderDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrderDetailController: UIViewController {

    /// 订单状态
    var orderStatus: PersonalOrderStatus = .waitToFukuan
    var orderId: String? {
        didSet {
            loadData()
        }
    }
    /// 列表数据数组
    fileprivate var listDataArr: [String] = []
    
    /// 数据模型
    fileprivate var orderModel: XHMyOrderModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let reuseId = "XHPersonalOrderDetailController_reuseId"
    fileprivate let reuseId_address = "XHPersonalOrderDetailController_reuseId_address"
    fileprivate let reuseId_product = "XHPersonalOrderDetailController_reuseId_product"
    fileprivate let reuseId_salesReturn = "XHPersonalOrderDetailController_reuseId_salesReturn"
    fileprivate let reuseId_orderStatus = "XHPersonalOrderDetailController_reuseId_orderStatus"
    fileprivate let reuseId_account = "XHPersonalOrderDetailController_reuseId_account"
    fileprivate let reuseId_logisticsNum = "XHPersonalOrderDetailController_reuseId_logisticsNum"
    fileprivate let reuseId_logistics = "XHPersonalOrderDetailController_reuseId_logistics"
    
    fileprivate let viewName = "店铺_用户订单_订单详情页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
        setupBesicView()
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    
    private func loadData() {
        let paraDict = ["orderid": orderId!]
        XHShop_customerOrder_ViewModel.getShop_customer_OrdersDetail(paraDict, self) { [weak self] (result) in
            if result is XHMyOrderModel {
                self?.orderModel = result as? XHMyOrderModel
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 确认发货 / 确认退货
    fileprivate func postOrConfirm(paraDict: [String: String]) {
        XHShop_customerOrder_ViewModel.myShop_postGoods_confirmReturnSales(paraDict, self) { (result) in
            XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确认", confirmComplete: nil)
            if (result as! String) == "操作成功" {
                let time: TimeInterval = 0.4
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK:- ======== 界面相关 ========
    private func setupTableView() {
        view.addSubview(tableView)
        
        footerView.removeFromSuperview()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        if orderStatus == .applyForReturn {
            tableView.snp.remakeConstraints({ (make) in
                make.left.top.right.equalTo(view)
                make.bottom.equalTo(-45)
            })
            
            view.addSubview(footerView)
            footerView.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(view)
                make.top.equalTo(tableView.snp.bottom)
            })
            
            ///   查看物流
            footerView.confirmReturnButtonClickedClosure = { [weak self] in
                let logistics = XHLogisticsDetailController()
                logistics.orderModel = self?.orderModel
                self?.navigationController?.pushViewController(logistics, animated: true)
            }
            
            /// 联系买家
            footerView.connectUserButtonClickedClosure = { [weak self] in
                self?.showHint(in: (self?.view)!, hint: "联系用户")
            }
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "XHOrderStatusConsCell", bundle: nil), forCellReuseIdentifier: reuseId_address)
        tableView.register(UINib(nibName: "XHOrderStatusSalesReturnCell", bundle: nil), forCellReuseIdentifier: reuseId_salesReturn)
        tableView.register(UINib(nibName: "XHPersonalOrder_ProductCell", bundle: nil), forCellReuseIdentifier: reuseId_product)
         tableView.register(UINib(nibName: "XHOrderStatusLogiCell", bundle: nil), forCellReuseIdentifier: reuseId_logistics)
        tableView.register(UINib(nibName: "XHPersonalOrder_orderDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_orderStatus)
        tableView.register(UINib(nibName: "XHPersonalOrder_accountCell", bundle: nil), forCellReuseIdentifier: reuseId_account)
        tableView.register(UINib(nibName: "XHPersonalOrder_logisticsNumCell", bundle: nil), forCellReuseIdentifier: reuseId_logisticsNum)
        
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 64)
        headerView.orderStatus = orderStatus
        tableView.tableHeaderView = headerView
    }
    
    private func setupBesicView() {
        switch orderStatus {
        case .waitToFukuan, .canceled, .confirmReturn: // 待付款 订单取消
            listDataArr = ["address", "product", "orderDetail", "account"]
        case .waitToSend: // 待发货
            listDataArr = ["address","logisticsNum", "product", "orderDetail", "account"]
        case .applyForReturn: // 申请退货
            listDataArr = ["address", "returnReason", "logisticsNum", "product", "orderDetail", "account"]
        case .waitToGet: // 已发货
            listDataArr = ["address", "product", "orderDetail", "account"]
        case .finished: // 已完成
            listDataArr = ["address", "product", "orderDetail", "account"]
        default:
            listDataArr = ["address","logisticsNum", "product", "orderDetail", "account"]
        }
        tableView.reloadData()
    }

    private func setupNav() {
        title = "订单详情"
    }
    
    // MARK:- 懒加载
    // tableView
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
    
    private lazy var headerView: XHPersonalOrder_headerView = XHPersonalOrder_headerView()
    
    private lazy var footerView: XHXHPersonalOrder_footerView = XHXHPersonalOrder_footerView()
}
extension XHPersonalOrderDetailController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return listDataArr.count
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idString = listDataArr[indexPath.section]
        if idString == "address" { // 地址
            let cell: XHOrderStatusConsCell = tableView.dequeueReusableCell(withIdentifier: reuseId_address, for: indexPath) as! XHOrderStatusConsCell
            cell.orderModel = orderModel
            return cell
        }else if idString == "product" { // 商品
            let cell: XHPersonalOrder_ProductCell = tableView.dequeueReusableCell(withIdentifier: reuseId_product, for: indexPath) as! XHPersonalOrder_ProductCell
            cell.orderModel = orderModel
            return cell
        }else if idString == "logistics" { // 物流信息
            let cell: XHOrderStatusLogiCell = tableView.dequeueReusableCell(withIdentifier: reuseId_logistics, for: indexPath) as! XHOrderStatusLogiCell
            cell.orderModel = orderModel
            return cell
        }else if idString == "returnReason" {
            let cell: XHOrderStatusSalesReturnCell = tableView.dequeueReusableCell(withIdentifier: reuseId_salesReturn, for: indexPath) as! XHOrderStatusSalesReturnCell
            cell.orderModel = orderModel
            cell.isShopOrder = true
            
            cell.confirmReturnButtonClickedClosure = { [weak self] in
                let paraDict = ["flag": "2", "orderid": (self?.orderModel?.id)!]
                self?.postOrConfirm(paraDict: paraDict)
            }
            return cell
        }else if idString == "orderDetail" {
            let cell: XHPersonalOrder_orderDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_orderStatus, for: indexPath) as! XHPersonalOrder_orderDetailCell
            cell.orderModel = orderModel
            return cell
        }else if idString == "account" {
            let cell: XHPersonalOrder_accountCell = tableView.dequeueReusableCell(withIdentifier: reuseId_account, for: indexPath) as! XHPersonalOrder_accountCell
            cell.orderModel = orderModel
            return cell
        }else if idString == "logisticsNum" {
            let cell: XHPersonalOrder_logisticsNumCell = tableView.dequeueReusableCell(withIdentifier: reuseId_logisticsNum, for: indexPath) as! XHPersonalOrder_logisticsNumCell
            
            /// 确认发货按钮点击事件
            cell.confirmSendButtonClickedClosure = { [weak self] textField in
                if textField.text?.isEmpty == true {
                    self?.showHint(in: (self?.view)!, hint: "请输入快递单号~")
                }else {
                    let paraDict = ["flag": "1", "orderid": (self?.orderModel?.id)!, "ydh": textField.text!]
                    self?.postOrConfirm(paraDict: paraDict)
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
