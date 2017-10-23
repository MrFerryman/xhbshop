//
//  XHBussinessOrderDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  商家订单详情控制器

import UIKit

class XHBussinessOrderDetailController: UIViewController {
    
    fileprivate let reuseId_basic = "XHBussinessOrderDetailController_reuseId_basic"
    fileprivate let reuseId_customer = "XHBussinessOrderDetailController_reuseId_customer"
    fileprivate let reuseId_shop = "XHBussinessOrderDetailController_reuseId_shop"
    
    var order_id: String? {
        didSet {
            loadData()
        }
    }
    
    fileprivate var orderModel: XHMyShopOrderDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        
        let paraDict = ["dmd_oid": order_id!]
        XHMyShopViewModel.checkShopOrderDetail(paraDict, self) { [weak self] (result) in
            if result is XHMyShopOrderDetailModel {
                self?.orderModel = result as? XHMyShopOrderDetailModel
                self?.setupTableView()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK:- ==== 界面相关 =======
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
        
        tableView.register(UINib(nibName: "XHBussinessOrderDetail_BesicCell", bundle: nil), forCellReuseIdentifier: reuseId_basic)
        tableView.register(UINib(nibName: "XHBussinessOrderDetail_CustomerCell", bundle: nil), forCellReuseIdentifier: reuseId_customer)
        tableView.register(UINib(nibName: "XHBussinessOrderDetail_ShopCell", bundle: nil), forCellReuseIdentifier: reuseId_shop)
    }
    
    private func setupNav() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        title = "订单详情"
    }

    // MARK:- 懒加载
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()
}

extension XHBussinessOrderDetailController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 基本信息
            let cell: XHBussinessOrderDetail_BesicCell = tableView.dequeueReusableCell(withIdentifier: reuseId_basic, for: indexPath) as! XHBussinessOrderDetail_BesicCell
            cell.orderModel = orderModel
            return cell
        }else if indexPath.section == 1 { // 买家信息
            let cell: XHBussinessOrderDetail_CustomerCell = tableView.dequeueReusableCell(withIdentifier: reuseId_customer, for: indexPath) as! XHBussinessOrderDetail_CustomerCell
            cell.orderModel = orderModel
            return cell
        }
        // 店铺信息
        let cell: XHBussinessOrderDetail_ShopCell = tableView.dequeueReusableCell(withIdentifier: reuseId_shop, for: indexPath) as! XHBussinessOrderDetail_ShopCell
        cell.orderModel = orderModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
