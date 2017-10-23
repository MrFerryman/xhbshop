//
//  XHMyWallletController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
enum WalletType {
    case all      // 所有
    case withdraw // 提现
}

class XHMyWallletController: UIViewController {

    var walletType: WalletType = .all {
        didSet {
            loadData()
        }
    }
    
    fileprivate let reuseId = "XHMyWallletController_reuseId"
    
    fileprivate var dataArr: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        var requestType: XHNetDataType = .getWalletDetailAll
        if walletType == .all {
            requestType = .getWalletDetailAll
        }else {
            requestType = .getWithdrawList
        }
        
        showHud(in: view, hint: "加载中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: requestType, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { (sth) in
            weak var weakSelf = self
            weakSelf?.hideHud()
            weakSelf?.dataArr.removeAll()
            weakSelf?.dataArr = sth as! [Any]
            if (sth as! [Any]).count > 0 {
                weakSelf?.setupTableView()
                weakSelf?.tableView.reloadData()
            }else {
                weakSelf?.setupEmptyUI()
            }
        })
    }
    
    // MARK:- ==== 界面相关 ======
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
        
        hideHud()
        
        if walletType == .all {
            emptyL.text = "亲，您暂时没有钱包明细～"
        }else {
            emptyL.text = "亲，您暂时还没有获得收益～"
        }
    }
    
    // MARK:- tableView的设置
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHWalletDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    
    // MARK:- 懒加载
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "wallet_empty_image"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

extension XHMyWallletController: UITableViewDelegate, UITableViewDataSource {
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
        let cell: XHWalletDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHWalletDetailCell
        
        let model = dataArr[indexPath.section]
        if model is XHWalletModel {
            let walletM = model as! XHWalletModel
            cell.walletModel = walletM
        }else if model is XHWithdrawModel {
            let withdrawM = model as! XHWithdrawModel
            cell.withdrawModel = withdrawM
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
