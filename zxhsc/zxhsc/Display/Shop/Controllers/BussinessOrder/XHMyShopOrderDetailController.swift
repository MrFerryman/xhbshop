//
//  XHMyShopOrderDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHMyShopOrderDetailController: UIViewController {

    /// 订单类型
    var orderType: XHMyShopOrderType = .all {
        didSet {
            page = 0
            cancelRequest?.cancelRequest()
            loadData()
        }
    }
    
    fileprivate let reuseId_shop = "XHMyShopOrderDetailController_reuseId_shop"
    fileprivate var cancelRequest: XHCancelRequest?
    fileprivate var page: Int = 0
    fileprivate var orderList: [XHMyShopOrderModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmptyUI()
        loadData()
    }
    
    @objc private func headerRefresh() {
        page = 0
        orderList.removeAll()
        loadData()
    }
    
    @objc private func footerRefresh() {
        if page == 0 {
            orderList.removeAll()
        }
        loadData()
    }
    
    private func loadData() {
        page += 1
        
        var status = "0"
        switch orderType {
        case .all: // 全部
            status = "0"
        case .obligation: // 待付款
            status = "1"
        case .completed: // 已完成
            status = "2"
        case .canceled: // 已取消
            status = "3"
        }
        let paraDict = ["page": "\(page)", "status": status]
        cancelRequest = XHMyShopViewModel.getMyShopOrderList(paraDict, self) { [weak self] (result) in
            
            if result is [XHMyShopOrderModel] {
                self?.orderList.append(contentsOf: result as! [XHMyShopOrderModel])
                if self?.orderList.count == 0 {
                    self?.setupEmptyUI()
                }else {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
            
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            
            if self?.tableView.mj_footer != nil {
                if let modelList = result  as? [XHMyShopOrderModel] {
                    if modelList.count == 0 {
                        self?.showHintInKeywindow(hint: "暂无更多数据~")
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }else {
                    self?.tableView.mj_footer.endRefreshing()
                }
            }
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
        
        tableView.register(UINib(nibName: "XHBussinessOrderCell", bundle: nil), forCellReuseIdentifier: reuseId_shop)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.footerRefresh()
        })
    }

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
    
    // MARK:- 懒加载
    // tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
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

extension XHMyShopOrderDetailController: UITableViewDelegate, UITableViewDataSource {
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
        let cell: XHBussinessOrderCell = tableView.dequeueReusableCell(withIdentifier: reuseId_shop, for: indexPath) as! XHBussinessOrderCell
        cell.orderModel = orderList[indexPath.section]
        
        cell.cancelOrderButtonClickedClosure = { [weak self] orderModel in
            XHAlertController.showAlert(title: "提示", message: "确定要取消订单吗?", Style: .actionSheet, confirmTitle: "确定", confirmComplete: { 
                let paraDict = ["shop_id": (orderModel.order_Id)!]
                XHMyShopViewModel.cancelMyShopOrder(paraDict, self!, dataArrClosure: { (result) in
                    XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
                })
            })
        }
        
        cell.goToPayButtonClickedClosure = { [weak self] orderModel in
            let payment = XHFukuanStyleController()
            payment.comeFrom = .shopping_order
            let shoppingCartM = XHShoppingCartModel()
            shoppingCartM.goods_id = orderModel.order_Id
            shoppingCartM.price = "\(orderModel.totalPrice)"
            shoppingCartM.buyCount = "1"
            payment.shoppingCartList = [shoppingCartM]
            payment.orderId = orderModel.order_Id
            self?.navigationController?.pushViewController(payment, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bussinessV = XHBussinessOrderDetailController()
        bussinessV.order_id = orderList[indexPath.section].order_Id
        navigationController?.pushViewController(bussinessV, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = orderList[indexPath.section]
        return model.status == 1 ? 175 : 129
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
}
