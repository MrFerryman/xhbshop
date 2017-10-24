//
//  XHMyShop_QRCodeController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyShop_QRCodeController: UIViewController {

    fileprivate let reuseId_qrCoder = "XHMyShop_QRCodeController_qrCoder"
    fileprivate let reuseId_detail = "XHMyShop_QRCodeController_detail"
    
    fileprivate let viewName = "店铺二维码页"
    
    fileprivate var shopModel: XHMyShop_settingModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
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
    
    
    private func loadData() {
        XHShopSettingViewModel.getShop_setting_info(self) { [weak self] (result) in
            if result is XHMyShop_settingModel {
                self?.shopModel = result as? XHMyShop_settingModel
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 界面相关
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyShop_QRCoderImageCell", bundle: nil), forCellReuseIdentifier: reuseId_qrCoder)
        tableView.register(UINib(nibName: "XHMyShop_QRCoderDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_detail)
    }
    
    
    private func setupNav() {
        title = "店铺二维码"
    }

    // MARK:- ====== 懒加载 ============
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedRowHeight = 80
        return tableView
    }()
}

extension XHMyShop_QRCodeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHMyShop_QRCoderImageCell = tableView.dequeueReusableCell(withIdentifier: reuseId_qrCoder, for: indexPath) as! XHMyShop_QRCoderImageCell
            cell.shopModel = shopModel
            return cell
        }
        let cell: XHMyShop_QRCoderDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_detail, for: indexPath) as! XHMyShop_QRCoderDetailCell
        cell.shopModel = shopModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
