//
//  XHFukuanStyleController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHFukuanStyleController: UIViewController {

    fileprivate let reuseId = "XHFukuanStyleController_reuseId"
    fileprivate let reuseId_explain = "XHFukuanStyleController_reuseId_explain"
    fileprivate let reuseId_secret = "XHFukuanStyleController_reuseId_secret"
    /// 标识支付方式
    fileprivate var currentZhifuStyle: String = "易宝支付"
    
    /// 可用余额
    fileprivate var banlance: CGFloat = 0.0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var totalPrice: CGFloat = 0.0
    fileprivate var styleListArr: [Int] = []
    fileprivate var isBanlancePay: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var orderDetailModel: XHMyOrderModel?
    
    var shoppingCartList: [XHShoppingCartModel] = [] {
        didSet {
            var totalPrice: CGFloat = 0.0
            var totalInte: CGFloat = 0.0
            for model in shoppingCartList {
                let price = NSString(string: (model.price ?? "0")).floatValue
                let count = NSString(string: (model.buyCount)!).floatValue
                
                let totleP = CGFloat(price) * CGFloat(count)
                
                if model.integral != nil {
                    let integral = NSString(string: model.integral!).floatValue
                    let totle_integral = CGFloat(integral) * CGFloat(count)
                    totalInte += totle_integral
                }
                totalPrice += totleP
            }
            
            self.totalPrice = totalPrice
            if totalInte != 0.0 {
                headerView.totalPrice = "需支付: ￥\(totalPrice)" + " " + "+ 积分(循环宝):" + " " + "\(totalInte)"
            }else {
                headerView.totalPrice = "需支付: ￥\(String(format: "%.2f", totalPrice))"
            }
        }
    }
    
    var orderId: String?
    
    /// 从哪个方向进来
    var comeFrom: ConfirmOrderFrom = .shoppingCart
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
        getPaymentList()
        
        getEffectiveBanlance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取支付方式列表
    private func getPaymentList() {
        XHShoppingCartViewModel.getPaymentList(self) { [weak self] (result) in
            if result is Array<Any> {
                let list = result as! Array<Int>
                self?.styleListArr = list
                self?.setPaymentStyleList(list)
            }
        }
    }
    
    // MARK:- 获取可用余额
    private func getEffectiveBanlance() {
        XHShoppingCartViewModel.getEffectiveBanlance(self) { [weak self] (result) in
            if result is CGFloat {
                self?.banlance = result as! CGFloat
                self?.setPaymentStyleList((self?.styleListArr)!)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result as? String, confirmTitle: "确定", confirmComplete: { 
                    if (result as! String) == "请重新登陆！" {
                        let login = XHLoginController()
                        let nav = UINavigationController(rootViewController: login)
                        self?.navigationController?.pushViewController(nav, animated: true)
                    }
                })
            }
        }
    }
    
      
    // MARK:- 
    private func setPaymentStyleList(_ listArr: [Int]) {
        var styleList = Array<XHFukuanStyleModel>()
        for element in listArr {
            let model = XHFukuanStyleModel()
            switch element {
            case 0:
                model.title = "二维码支付"
                model.iconsArr = ["payment_wechat", "payment_zhifubao"]
                model.isSelected = false
                styleList.append(model)
            case 1:
                model.title = "易宝支付"
                model.iconsArr = ["payment_yibao"]
                model.isSelected = true
                styleList.append(model)
//            case 2:
//                model.title = "快钱支付"
//                model.iconsArr = ["payment_kuaiqian"]
//                model.isSelected = false
//                styleList.append(model)
            case 3:
                model.title = "联动优势支付"
                model.iconsArr = ["payment_liandong"]
                model.isSelected = false
                styleList.append(model)
//            case 4:
//                model.title = "支付宝支付"
//                model.iconsArr = ["payment_zhifubao"]
//                model.isSelected = false
            case 5: //
                model.title = "快捷通支付"
                model.iconsArr = ["payment_kuaijidong"]
                model.isSelected = false
                styleList.append(model)
            default:
                break
            }
        }
        
        if banlance > totalPrice {
            let yu_e = XHFukuanStyleModel()
            yu_e.title = "余额支付"
            yu_e.iconsArr = ["payment_yue"]
            yu_e.isSelected = false
            
            styleList.append(yu_e)
        }
       
        listDatas = styleList
        tableView.reloadData()
    }
    
    // MARK:- 支付
    private func payment() {
        switch currentZhifuStyle {
        case "二维码支付":
            let qrcoderPay = XHQRCoderPaymentController()
            qrcoderPay.comeFrom = comeFrom
            qrcoderPay.orderId = orderId
            navigationController?.pushViewController(qrcoderPay, animated: true)
        case "易宝支付":
            let baseURL = "http://appback.zxhshop.cn/"
            let webView = XHWebViewController()
            switch comeFrom {
            case .myOrder, .integral_goods: // 我的订单
                let url = baseURL + "my_order_pay.php?order_id=" + (orderId)!
                webView.urlStr = url
            case .shoppingCart: // 购物车
                let url = baseURL + "cart_pay.php?order_id=" + (orderId)!
                webView.urlStr = url
            case .shopping_order, .shopping_pay:
                let url = baseURL + "shop_fukuan.php?&order_id=" + (orderId)!
                webView.urlStr = url
            }
            navigationController?.pushViewController(webView, animated: true)
        case "联动优势支付":
            let baseURL = "http://wx2.zxhshop.cn/alipay/liandongpay/index.php?id="
            let webView = XHWebViewController()
            var order_ID: String?
            switch comeFrom {
            case .myOrder, .integral_goods: // 我的订单
                order_ID = (orderId)! + "_l"
            case .shoppingCart: // 购物车
                order_ID = (orderId)! + "_cl"
            case .shopping_order, .shopping_pay:
                order_ID = (orderId)! + "_dl"
            }
            
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            let url = baseURL + order_ID! + "&hyid=" + userid! + "&jine=" + "\(String(format: "%.3f", totalPrice))"
            
            webView.urlStr = url
            navigationController?.pushViewController(webView, animated: true)
        case "支付宝支付":
            let baseURL = "http://wx2.zxhshop.cn/alipay/yuepay/index1.php?id="
            let webView = XHWebViewController()
            var order_ID: String?
            switch comeFrom {
            case .myOrder: // 我的订单
                order_ID = (orderId)! + "_l"
            case .shoppingCart: // 购物车
                order_ID = (orderId)! + "_cl"
            case .shopping_order, .shopping_pay:
                order_ID = (orderId)! + "_dl"
            default:
                break
            }
            
            let url = baseURL + order_ID! + "&jine=" + "\(totalPrice)"
            webView.urlStr = url
            
            navigationController?.pushViewController(webView, animated: true)
        case "快钱支付":
            let baseURL = "http://appback.zxhshop.cn/"
            let webView = XHWebViewController()
            switch comeFrom {
            case .myOrder, .shoppingCart: // 我的订单  购物车
                let url = baseURL + "shop_kuaiqian_fukuan_cart.php?&order_id=" + (orderId)! + "&oid=" + (comeFrom == .myOrder ? "1" : "2")
                webView.urlStr = url
            case .shopping_order, .shopping_pay:
                let url = baseURL + "shop_kuaiqian_fukuan_cart.php?&order_id=" + (orderId)!
                webView.urlStr = url
            default:
                let url = baseURL + "shop_kuaiqian_fukuan.php?&order_id=" + (orderId)!
                webView.urlStr = url
            }
            navigationController?.pushViewController(webView, animated: true)
            
        case "余额支付":
            
            if NSString(string: secretTextField.text!).length >= 6 {
                var paraDict: [String : String] = [:]
                switch comeFrom {
                case .myOrder, .integral_goods: // 我的订单
                    paraDict["style"] = "2"
                    paraDict["order_id"] = orderId!
                    paraDict["zhifupass"] = secretTextField.text!
                case .shoppingCart: // 购物车
                    paraDict["style"] = "2"
                    paraDict["order_id"] = orderId!
                    paraDict["zhifupass"] = secretTextField.text!
                    paraDict["idlx"] = "c"
                case .shopping_order, .shopping_pay:
                    paraDict["style"] = "1"
                    paraDict["dmd_type_oid"] = orderId!
                    paraDict["zhifupass"] = secretTextField.text!
                }
                XHFukuanStyleViewModel.payment_Banlance(paraDict, self, dataArrClosure: { [weak self] (result) in
                    XHAlertController.showAlertSigleAction(title: "提示", message:  result as? String, confirmTitle: "确定", confirmComplete: {
                        let myOrder = XHMyOrderController()
                        self?.navigationController?.pushViewController(myOrder, animated: true)
                    })
                })
            }else {
                showHint(in: view, hint: "请输入正确的支付密码")
            }
        case "快捷通支付": // 快捷通支付
            let baseURL = "http://wx2.zxhshop.cn/alipay/kjtpay/index.php?id="
            let webView = XHWebViewController()
            var order_ID: String?
            switch comeFrom {
            case .myOrder, .integral_goods: // 我的订单
                order_ID = (orderId)! + "_l"
            case .shoppingCart: // 购物车
                order_ID = (orderId)! + "_cl"
            case .shopping_order, .shopping_pay:
                order_ID = (orderId)! + "_dl"
            }
            
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            let url = baseURL + order_ID! + "&hyid=" + userid! + "&jine=" + "\(String(format: "%.3f", totalPrice))"
            
            webView.urlStr = url
            navigationController?.pushViewController(webView, animated: true)
        default:
            break
        }
    }

    // MARK:- ====== 界面相关 ======
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_explain)
        tableView.register(UINib(nibName: "XHFukuanStyleCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_secret)
        
        setHeaderDragableIamge()
        
        tableView.tableFooterView = footerView
        /// 支付说明
        footerView.explainButtonClickedClosure = {
            
        }
        
        /// 立即支付
        footerView.zhifuButtonClickedClosure = { [weak self] in
            
            if (self?.comeFrom)! == .shopping_pay {
                let paraDict = ["dmd_type_oid": (self?.orderId)!]
                XHFukuanStyleViewModel.testPerdayLimitMoney(paraDict, self!, dataArrClosure: { (result) in
                    if result is String {
                        if (result as! String) == "可用" {
                            self?.payment()
                        }else {
                            XHAlertController.showAlertSigleAction(title: "提示", message: result as? String, confirmTitle: "确定", confirmComplete: nil)
                        }
                    }
                })
            }else {
                self?.payment()
            }
        }
    }
    
    // MARK:- 设置头部可拉伸图片
    fileprivate func setHeaderDragableIamge() {
        headerImageView.frame = CGRect(x: 0, y: 64, width: kUIScreenWidth, height: 80)
        bgView.addSubview(headerImageView)
        
        tableView.backgroundView = bgView
        tableView.tableHeaderView = headerView
    }
    
    // 使头部图片可拉伸
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame = headerImageView.frame // 头部图片的frame
        if scrollView.contentOffset.y < 0 {
            frame.origin.y = 0
            // 图片的高度加上偏移的值
            frame.size.height = 155 - scrollView.contentOffset.y
        }else {
            frame.origin.y = -scrollView.contentOffset.y
        }
        headerImageView.frame = frame
    }
    
    private func setupNav() {
        title = "选择付款方式"
    }
    
    // MARK:- ======= 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    // 头部可拉伸图片
    fileprivate lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "zhifu_style_bg"))
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    // 头部可拉伸图片 背景视图
    fileprivate lazy var bgView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 80))
    
    fileprivate lazy var headerView: XHFukuanStyleHeaderView = XHFukuanStyleHeaderView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 80))
    
    fileprivate lazy var footerView: XHFukuanStyleFooterView = XHFukuanStyleFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 300))
    
    fileprivate lazy var listDatas: [XHFukuanStyleModel] = []
    
    /// 输入密码cell
    fileprivate lazy var secretImgView: UIImageView = UIImageView(image: UIImage(named: "payment_lock"))
    
    fileprivate lazy var secretTextField: UITextField = {
       let textF = UITextField()
        textF.placeholder = "请输入支付密码"
        textF.font = UIFont.systemFont(ofSize: 12)
        textF.isSecureTextEntry = true
        return textF
    }()
}

extension XHFukuanStyleController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return isBanlancePay == true ? 3 : 2
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return listDatas.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_explain, for: indexPath)
            cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x666666)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
            cell.selectionStyle = .none
            cell.textLabel?.text = "请在72小时内完成付款，超时订单将自动取消。"
            return cell
        }else if indexPath.section == 1 {
            let cell: XHFukuanStyleCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHFukuanStyleCell
            cell.banlance = banlance
            cell.zhifuModel = listDatas[indexPath.row]
            
            cell.selectedButtonClickedClosure = { [weak self] model in
                self?.currentZhifuStyle = model.title!
                for fuM in (self?.listDatas)! {
                    if fuM.title != model.title {
                        fuM.isSelected = false
                    }else {
                        fuM.isSelected = true
                        if fuM.title == "余额支付" {
                            self?.isBanlancePay = true
                        }else {
                            self?.isBanlancePay = false
                        }
                    }
                }
                
                tableView.reloadData()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_secret, for: indexPath)
        self.setupSecretCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = listDatas[indexPath.row]
            currentZhifuStyle = model.title!
            for fuM in listDatas {
                if fuM.title != model.title {
                    fuM.isSelected = false
                }else {
                    fuM.isSelected = true
                    if fuM.title == "余额支付" {
                        isBanlancePay = true
                    }else {
                        isBanlancePay = false
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }else if section == 2 {
            return 16
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }else if section == 1 {
            let view = UIView()
            view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
            let titleL = UILabel()
            titleL.textColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1.0)
            titleL.font = UIFont.systemFont(ofSize: 12)
            titleL.text = "选择支付方式"
            view.addSubview(titleL)
            titleL.snp.makeConstraints { (make) in
                make.centerY.equalTo(view)
                make.left.equalTo(16)
            }
            return view
        }
       return nil
    }
    
    fileprivate func setupSecretCell(cell: UITableViewCell) {
        cell.selectionStyle = .none
        cell.addSubview(secretImgView)
        secretImgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(cell)
            make.width.height.equalTo(20)
        }
        
        cell.addSubview(secretTextField)
        secretTextField.snp.makeConstraints { (make) in
            make.left.equalTo(secretImgView.snp.right).offset(6)
            make.centerY.equalTo(secretImgView)
            make.right.equalTo(-16)
        }
    }
}

class XHFukuanStyleFooterView: UIView {
    
    /// 支付说明按钮点击事件回调
    var explainButtonClickedClosure: (() -> ())?
    /// 立即支付按钮点击事件
    var zhifuButtonClickedClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ====== 事件相关 ========
    // MARK:- 说明按钮点击事件
    @objc private func explainButtonClicked() {
        explainButtonClickedClosure?()
    }
    
    // MARK:- 立即支付按钮点击事件
    @objc private func zhifuButtonClicked() {
        zhifuButtonClickedClosure?()
    }
    
    // MARK:- ======= 界面相关 =======
    private func setupUI() {
        addSubview(titleL)
//        addSubview(explainBtn)
        addSubview(zhifuBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.centerX.equalTo(self)
        }
        
//        explainBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(titleL)
//            make.left.equalTo(titleL.snp.right).offset(-5)
//            make.width.height.equalTo(20)
//        }
        
        zhifuBtn.layer.cornerRadius = 8
        zhifuBtn.layer.masksToBounds = true
        zhifuBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleL.snp.bottom).offset(40)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }
    }
    
    // 文字
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.text = "如您的在线支付额度受到限制，建议使用汇款方式"
        label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    // 说明按钮
    private lazy var explainBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "zhifu_style_explain"), for: .normal)
        btn.addTarget(self, action: #selector(explainButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    // 支付按钮
    private lazy var zhifuBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.setTitle("立即支付", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(zhifuButtonClicked), for: .touchUpInside)
        return btn
    }()
}
