//
//  XHMyBalanceController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyBalanceController: UIViewController {

    fileprivate let reuseId_user = "XHMyBalanceController_reuseId_user"
    fileprivate let reuseId_detail = "XHMyBalanceController_reuseId_detail"
    
    fileprivate var userEarningModel: XHUserEarningModel? {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        
        setupNav()
        
        setupTableView()
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 设置tableView
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyBalance_UserCell", bundle: nil), forCellReuseIdentifier: reuseId_user)
        tableView.register(UINib(nibName: "XHMyBalance_DetailCell", bundle: nil), forCellReuseIdentifier: reuseId_detail)
    }
    
    private func loadData() {
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getUserEarning, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }) { [weak self] (sth) in
            self?.hideHud()
            if sth is XHUserEarningModel {
                let userE = sth as! XHUserEarningModel
                self?.userEarningModel = userE
            }else {
                let str = sth as! String
                self?.showHint(in: (self?.view)!, hint: str)
            }
        }
    }
    
    private func setupNav() {
        title = "钱包余额"
    }
    
    // MARK:- 懒加载
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()

}

extension XHMyBalanceController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: XHMyBalance_UserCell  = tableView.dequeueReusableCell(withIdentifier: reuseId_user, for: indexPath) as! XHMyBalance_UserCell
            return cell
        case 1:
            let cell: XHMyBalance_DetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_detail, for: indexPath) as! XHMyBalance_DetailCell
            cell.earningModel = userEarningModel
            cell.walletDetailButtonClickedClosure = { [weak self] in
                let wallet = XHWalletDetailController()
                wallet.navigationItem.title = "钱包明细"
                self?.navigationController?.pushViewController(wallet, animated: true)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {return 90}
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}
