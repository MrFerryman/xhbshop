//
//  XHConfirmOrderController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

enum ConfirmOrderFrom {
    case shopping_order // 商家订单
    case shopping_pay    // 商家付款
    case myOrder           // 我的订单
    case shoppingCart     // 购物车
    case integral_goods   // 积分商品
}

import UIKit

class XHConfirmOrderController: UIViewController {
   
    var ordersArr: [XHShoppingCartModel] = [] {
        didSet {
            var totalPrice: CGFloat = 0.0
            var totalInte: CGFloat = 0.0
            for model in ordersArr {
                let price = NSString(string: model.price ?? "0").floatValue
                let count = NSString(string: (model.buyCount)!).floatValue
               
                let totleP = CGFloat(price) * CGFloat(count)
                
                if model.integral != nil {
                    let integral = NSString(string: model.integral!).floatValue
                    let totle_integral = CGFloat(integral) * CGFloat(count)
                    totalInte += totle_integral
                }
                totalPrice += totleP
            }
            if isIntegralGoods == true {
                if totalPrice == 0.0 {
                    bottomView.totalPriceStr = "积分(循环宝):" + "\(totalInte)"
                }else {
                    bottomView.totalPriceStr = "积分(循环宝):" + "\(totalInte)" + " " + "+￥" + "\(String(format: "%.2f", totalPrice))"
                }
            }else {
                bottomView.totalPriceStr = "￥" + "\(String(format: "%.2f", totalPrice))"
            }
        }
    }
    
    /// 从哪进来的
    var comeFrom: ConfirmOrderFrom = .shoppingCart
    var isIntegralGoods: Bool = false
    
    fileprivate let reuseId = "XHConfirmOrderController_reuseId"
    fileprivate var addresseeModel: XHMyAdressModel? {
        didSet {
            headerView.addressModel = addresseeModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
        getDefaultAddresseeInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取默认收件人信息
    private func getDefaultAddresseeInfo() {
        XHShoppingCartViewModel.getDefaultAddressInfo(self) { [weak self] (result) in
            if result is XHMyAdressModel {
                self?.addresseeModel = result as? XHMyAdressModel
                self?.tableView.reloadData()
            }else {
                self?.showHint(in: (self?.view)!, hint: "\(result as! String)")
                if (result as! String) == "请重新登陆！" {
                    let login = XHLoginController()
                    let nav = UINavigationController(rootViewController: login)
                    self?.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK:- 提交订单
    fileprivate func commitOrder() {
        
        var para = Array<Any>()
        for model in ordersArr {
            var innerArr = Array<String>()
            innerArr.append(model.id!)
            innerArr.append(model.buyCount!)
            innerArr.append(model.goods_id!)
            innerArr.append(model.tab_Id!)
            innerArr.append(model.property1 ?? "")
            para.append(innerArr)
        }
        
        if isIntegralGoods == true {
            let paraDict = ["num": "\((ordersArr[0].buyCount)!)","spid": (ordersArr[0].goods_id)!, "aid": (self.addresseeModel?.address_id)!, "bqid": (ordersArr[0].tab_Id)!]
            XHShoppingCartViewModel.commitOrder_integral(paraDict, self, dataArrClosure: { [weak self] (result) in
                let orderId = NSString(string: result).integerValue
                if orderId != 0 {
                    let pay = XHFukuanStyleController()
                    pay.shoppingCartList = (self?.ordersArr)!
                    pay.comeFrom = (self?.comeFrom)!
                    pay.orderId = result
                    if NSString(string: (self?.ordersArr[0].price)!).floatValue == 0.0, NSString(string: (self?.ordersArr[0].integral)!).floatValue != 0.0 {
                        let integralPay = XHIntegral_PaymentController()
                        integralPay.comeFrom = (self?.comeFrom)!
                        integralPay.orderId = result
                        self?.navigationController?.pushViewController(integralPay, animated: true)
                    }else {
                        self?.navigationController?.pushViewController(pay, animated: true)
                    }
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
                }
            })
        }else {
            let paraDict = ["cart": "\(para)", "aid": (self.addresseeModel?.address_id)!]
            XHShoppingCartViewModel.commitOrder_common(paraDict, self, dataArrClosure: { [weak self] (result) in
                let orderId = NSString(string: result).integerValue
                if orderId != 0 {
                    let pay = XHFukuanStyleController()
                    pay.shoppingCartList = (self?.ordersArr)!
                    pay.comeFrom = (self?.comeFrom)!
                    pay.orderId = result
                    self?.navigationController?.pushViewController(pay, animated: true)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
                }
            })
        }
    }
    
    // MARK:- ======== 事件相关 ========
    // MARK:- headerView的点击手势事件
    @objc private func headerViewClickedGesture() {
        let myAddress = XHMyAddressController()
        myAddress.isFromShoppingCart = true
        navigationController?.pushViewController(myAddress, animated: true)
        
        myAddress.cellClickClosure = { [weak self] addrModel in
            self?.addresseeModel = addrModel
        }
    }
  
    // MARK:- ====== 界面相关 =======
    // MARK:- 布局tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(-44)
        }
        tableView.register(UINib(nibName: "XHConfirmOrderCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        tableView.tableHeaderView = headerView
        // 给headerView添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerViewClickedGesture))
        headerView.addGestureRecognizer(tap)
        
        if isIntegralGoods == false {
            tableView.tableFooterView = footerView
        }
        
        var count: Int = 0
        for model in ordersArr {
            count += NSString(string: model.buyCount!).integerValue
        }
        footerView.goodsArr = ordersArr
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
        }
        
        // 提交订单按钮点击事件
        bottomView.confirmButtonClickedClosure = { [weak self] in
           
            self?.commitOrder()
        }
    }
    private func setupNav() {
        title = "确认订单"
    }
    
    // MARK:- ======= 懒加载 ======
    // tableView 
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 86
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()

    // 底部视图
    private lazy var bottomView: XHCondirmOrderBottomView = XHCondirmOrderBottomView()
    
    // headerView
    private lazy var headerView: XHConfirmOrderHeaderView = Bundle.main.loadNibNamed("XHConfirmOrderHeaderView", owner: self, options: nil)?.last as! XHConfirmOrderHeaderView
    /// footerView
    private lazy var footerView: XHConfirmOrderFooterView = Bundle.main.loadNibNamed("XHConfirmOrderFooterView", owner: self, options: nil)?.last as! XHConfirmOrderFooterView
}

extension XHConfirmOrderController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersArr.count
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHConfirmOrderCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHConfirmOrderCell
        cell.isIntegralGoods = isIntegralGoods
        cell.shoppingCartModel = ordersArr[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
}

// MARK:- ============= 提交订单页 底部视图 ==============
class XHCondirmOrderBottomView: UIView {
    
    /// 提交订单按钮点击事件回调
    var confirmButtonClickedClosure: (() -> ())?
    
    /// 总价
    var totalPriceStr: String? {
        didSet {
            if totalPriceStr != nil {
                totalPriceL.text = totalPriceStr!
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ====== 界面相关 ======
    private func setupUI() {
        addSubview(confirmButton)
        addSubview(totalPriceL)
        addSubview(fontL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        confirmButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(100)
        }
        
        totalPriceL.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(confirmButton.snp.left).offset(-8)
        }
        
        fontL.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(totalPriceL.snp.left)
        }
    }
    
    // MARK:- ====== 事件相关 =====
    // MARK:- 提交订单按钮点击事件
    @objc private func confirmButtonClicked() {
        confirmButtonClickedClosure?()
    }
    
    // MARK:- ===== 懒加载 ======
    // 提交按钮
    private lazy var confirmButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("提交订单", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setBackgroundImage(UIImage(named: "shop_order_confirm"), for: .normal)
        btn.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    // 总价
    private lazy var totalPriceL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "￥0"
        return label
    }()
    
    // 合计
    private lazy var fontL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x999999)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "合计："
        return label
    }()
    
}
