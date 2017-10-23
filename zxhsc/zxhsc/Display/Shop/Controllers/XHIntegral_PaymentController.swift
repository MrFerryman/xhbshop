//
//  XHIntegral_PaymentController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHIntegral_PaymentController: UIViewController {
    
    fileprivate let reuseId_productInfo = "XHIntegral_PaymentController_productInfo"
    
    fileprivate var orderModel: XHMyOrderModel?
    fileprivate var integralStr: String?

    var comeFrom: ConfirmOrderFrom = .integral_goods
    
    var orderId: String? {
        didSet {
            getOrderDetail()
            getUserIntegral()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupNav()
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取订单详情
    private func getOrderDetail() {
        
        let paraDict = ["orderid": orderId!]
        XHFukuanStyleViewModel.getMyOrderDetail(paraDict, self) { [weak self] (result) in
            if result is XHMyOrderModel {
                self?.orderModel = result as? XHMyOrderModel
                self?.tableView.reloadData()
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }

    private func payment(password: String) {
        let paraDict = ["order_id": orderId!, "idlx": "87", "zhifupass": password]
        XHFukuanStyleViewModel.payment_integral(paraDict, self) { (result) in
            if result is String {
                if (result as! String) == "支付成功" {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "支付成功!", confirmTitle: "确定", confirmComplete: nil)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
                }
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 获取用户当前积分
    private func getUserIntegral() {
        XHFukuanStyleViewModel.getUserCurrentIntegral( self) { [weak self] (result) in
            let integral = NSString(string: result as! String).floatValue
            if integral != 0 {
                self?.integralStr = result as? String
                self?.tableView.reloadData()
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHIntegralPay_ProInfoCell", bundle: nil), forCellReuseIdentifier: reuseId_productInfo)
        
        footerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 200)
        tableView.tableFooterView = footerView
        
        footerView.integralButtonClickedClosure = { [weak self] textFiled in
            if textFiled.text?.isEmpty == true {
                self?.showHint(in: (self?.view)!, hint: "请输入支付密码~")
                return
            }
            self?.payment(password: textFiled.text!)
        }
    }
    
    private func setupNav() {
        title = "积分支付"
    }
    

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()

    private lazy var footerView: XHIntegralPayFooterView = Bundle.main.loadNibNamed("XHIntegralPayFooterView", owner: nil, options: nil)?.first as! XHIntegralPayFooterView
}

extension XHIntegral_PaymentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHIntegralPay_ProInfoCell = tableView.dequeueReusableCell(withIdentifier: reuseId_productInfo, for: indexPath) as! XHIntegralPay_ProInfoCell
        cell.detailModel = orderModel
        cell.integralString = integralStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
