//
//  XHMyAddressController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyAddressController: UIViewController {

    var isFromShoppingCart: Bool = false
    
    /// cell的点击事件回调
    var cellClickClosure: ((_ addressModel: XHMyAdressModel) -> ())?
    
    /// tableView cell 的复用标志
    fileprivate let reuseId = "XHMyAddressController_cell_reuseId"
    fileprivate let viewName = "地址管理页面"
    
    fileprivate var dataArr: [XHMyAdressModel] = []
    
    fileprivate var defaultAddress: XHMyAdressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupUI()
        setupEmptyUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }

  
    // MARK:- 添加收货地址
    @objc private func addAddress() {
        let editVc = XHEditMyAddressController()
        
        self.navigationController?.pushViewController(editVc, animated: true)
    }
    
    private func loadData() {
        
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyAdressList, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            if sth is [XHMyAdressModel] {
                let addressArr = sth as! [XHMyAdressModel]
                self?.dataArr = addressArr
                if addressArr.count > 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }
        }
    }
    
    // MARK:- 设置默认地址
    fileprivate func setDefaultAddress(addressModel: XHMyAdressModel) {
        
        let paraDict = ["address_id": addressModel.address_id!, "moren": addressModel.isDefault]
        showHud(in: view, hint: "设置中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .setAddress_default, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (sth) in
            self?.hideHud()
            let str = sth as! String
            if str == "默认地址修改成功！" {
                self?.loadData()
            }else {
                self?.showHint(in: (self?.view)!, hint: str)
            }
        })
        
    }
    
    // MARK:- 删除地址
    fileprivate func deleteAddress(addressModel: XHMyAdressModel) {
        
        let paraDict = ["address_id": addressModel.address_id!]
        showHud(in: view, hint: "删除中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .deleteAddress, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            self?.showHint(in: (self?.view)!, hint: sth as! String)
            if (sth as! String) == "删除成功！" {
                self?.loadData()
            }
        }
    }
    
    // MARK:- ===== 界面相关 =======
    // MARK:- 界面布局
    private func setupUI() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "address_add_image")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addAddress))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topView.snp.bottom).offset(60)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }

    
    // MARK:- 布局tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyAddressCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    // MARK:- ====== 懒加载 =======
    // 头部视图
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "address_empty"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "亲，您暂时没有添加收货地址～"
        return label
    }()
}

extension XHMyAddressController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHMyAddressCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHMyAddressCell
        
        cell.addressModel = dataArr[indexPath.section]
        
        /// 默认按钮点击事件回调
        cell.defaultAddressButtonClosure = { [weak self] addressM in
            self?.defaultAddress = addressM
            self?.setDefaultAddress(addressModel: addressM)
        }
        
        /// 编辑按钮点击事件回调
        cell.editButtonClickedClosure = { [weak self] addressM in
            let editVc = XHEditMyAddressController()
            editVc.myAddressModel = addressM
            self?.navigationController?.pushViewController(editVc, animated: true)
        }
        
        /// 删除按钮点击事件回调
        cell.deleteButtonClickedClosure = { [weak self] addressM in
            XHAlertController.showAlert(title: nil, message: "确定要删除吗？", Style: .alert, confirmTitle: "确定", confirmComplete: {
                self?.deleteAddress(addressModel: addressM)
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromShoppingCart == true {
            let model = dataArr[indexPath.section]
            cellClickClosure?(model)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
}
