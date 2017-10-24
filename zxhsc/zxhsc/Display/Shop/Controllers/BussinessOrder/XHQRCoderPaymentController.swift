//
//  XHQRCoderPaymentController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/12.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHQRCoderPaymentController: UIViewController {

    
    fileprivate let reuseId_img = "XHQRCoderPaymentController_reuseId_img"
    fileprivate let reuseId_order = "XHQRCoderPaymentController_reuseId_order"
    fileprivate let viewName = "选择付款方式_二维码支付页"
    
    fileprivate var saveButton: UIBarButtonItem?
    
    fileprivate var imgStr: String? {
        didSet {
            tableView.reloadSections([0], with: .automatic)
        }
    }
    
    fileprivate var orderModel: XHPaymentOrderDetailModel? {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    
    var comeFrom: ConfirmOrderFrom = .shoppingCart
    
    var orderId: String? {
        didSet {
            
            loadData()
            getOrderDetail()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        setupNav()
        
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 保存图片
    @objc private func saveImage() {
        savePhotoToLibrary()
    }
    
    private func loadData() {
        
        var paraDict: [String: String] = [:]
        if comeFrom == .shopping_pay || comeFrom == .shopping_order {
            paraDict = ["style": "1", "ewm_order_id": "\(orderId!)"]
        }else {
            paraDict["style"] = "2"
            paraDict["ewm_order_id"] = "\(orderId!)"
            if comeFrom == .myOrder {
                paraDict["oid"] = "1"
            }else if comeFrom == .shoppingCart {
                paraDict["oid"] = "2"
            }
        }
        
        XHFukuanStyleViewModel.getPayment_qrcoder(paraDict, self) { [weak self] (result) in
            if XHRegularManager.isValidationURL(str: result) {
                self?.imgStr = result
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 获取订单详情
    private func getOrderDetail() {
        var paraDict: [String: String] = [:]
        if comeFrom == .myOrder {
            paraDict["type"] = "1"
            paraDict["aorder_id"] = orderId!
        }else if comeFrom == .shoppingCart {
            paraDict["type"] = "2"
            paraDict["cart_orderid"] = orderId!
        }else {
            paraDict["type"] = "3"
            paraDict["dmd_oid"] = orderId!
        }
        
        XHFukuanStyleViewModel.getPayment_orderDetail(paraDict, self) { (result) in
            if result is XHPaymentOrderDetailModel {
                self.orderModel = result as? XHPaymentOrderDetailModel
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }

    // 保存图片到相册
    private func savePhotoToLibrary() {
        let image = captureImage(fromView: self.view)
        
        let library = ALAssetsLibrary()
        let data = UIImageJPEGRepresentation(image, 1.0)
        library.writeImage(toSavedPhotosAlbum: UIImage(data: data!)?.cgImage, metadata: nil) { [weak self] (url, error) in
            if error == nil {
                self?.qrcodeImgView.image = image
                UIApplication.shared.keyWindow?.addSubview((self?.qrcodeImgView)!)
                self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth / 4, y: KUIScreenHeight / 4), size: CGSize(width:  0, height: 0))
                UIView.animate(withDuration: 0.3, animations: {
                    self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth / 4, y: KUIScreenHeight / 4), size: CGSize(width:  kUIScreenWidth / 2, height: KUIScreenHeight / 2))
                })
                
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    UIView.animate(withDuration: 1.0, animations: {
                        self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth - 40, y: 32), size: CGSize.zero)
                    }, completion: { (finished) in
                        self?.qrcodeImgView.removeFromSuperview()
                        let alertView: UIAlertView = UIAlertView(title: "截取屏幕成功", message: nil, delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    })
                }
            }else {
                let alertView: UIAlertView = UIAlertView(title: "截取屏幕失败", message: nil, delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
    
    // 截图功能
    private func captureImage(fromView view: UIView) -> UIImage {
        let screenRect = view.bounds
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        view.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        tableView.register(XHQRCoderPaymentImaeCell.self, forCellReuseIdentifier: reuseId_img)
        tableView.register(UINib(nibName: "XHQRCoderPaymentOrderCell", bundle: nil), forCellReuseIdentifier: reuseId_order)
        }

    private func setupNav() {
        title = "二维码支付"
        let saveImgItem = UIBarButtonItem(title: "保存图片", style: .plain, target: self, action: #selector(saveImage))
        saveImgItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0xea2000)], for: .normal)
        self.saveButton = saveImgItem
        navigationItem.rightBarButtonItem = saveImgItem
    }
    // MARK:- ======= 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()

    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var qrcodeImgView: UIImageView = UIImageView()
}

extension XHQRCoderPaymentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_img, for: indexPath) as! XHQRCoderPaymentImaeCell
            cell.imgStr = imgStr
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_order, for: indexPath) as! XHQRCoderPaymentOrderCell
        cell.orderModel = orderModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 280
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

class XHQRCoderPaymentImaeCell: UITableViewCell {
    
    var imgStr: String? {
        didSet {
            if imgStr != nil {
                qrImg.sd_setImage(with: URL(string: imgStr!), placeholderImage: UIImage(named: "loding_icon"), options: .progressiveDownload, completed: { [weak self] (image, error, cacheType, url) in
                    self?.activityView.stopAnimating()
                    self?.activityView.isHidden = true
                })
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(fontL)
        fontL.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(10)
        }
        
        addSubview(styleL)
        styleL.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(fontL.snp.bottom).offset(8)
        }
        
        addSubview(qrImg)
        qrImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(styleL.snp.bottom).offset(15)
            make.width.height.equalTo(200)
        }
        
        qrImg.addSubview(activityView)
        
        activityView.snp.makeConstraints { (make) in
            make.center.equalTo(qrImg)
        }
    }
    
    // MARK:- 懒加载
    private lazy var fontL: UILabel = {
        let label = UILabel()
        label.text = "请扫描二维码支付"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = XHRgbColorFromHex(rgb: 0x757575)
        return label
    }()
    private lazy var styleL: UILabel = {
        let label = UILabel()
        label.text = "支持微信、支付宝、QQ钱包"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = XHRgbColorFromHex(rgb: 0x757575)
        return label
    }()
    
    private lazy var qrImg: UIImageView = UIImageView(image: UIImage(named: "loding_icon"))
    
    private lazy var activityView: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.startAnimating()
        view.activityIndicatorViewStyle = .white
        view.isHidden = false
        return view
    }()
}
