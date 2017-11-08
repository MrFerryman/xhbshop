//
//  XHMyRPDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

enum RedPacketType {
    case post  // 发出的红包
    case get // 收到的红包
}

class XHMyRPDetailController: UIViewController {

    fileprivate var reuseId = "XHMyRPDetailController_reuseId"
    
    fileprivate var dataArr: [XHRedPacketModel] = []
    fileprivate var page: Int = 0
    fileprivate var cancelRequest: XHCancelRequest?
    
    var red_type: RedPacketType = .post {
        didSet {
            cancelRequest?.cancelRequest()
            page = 0
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadData()
    }
    
    private func loadData() {
        page += 1
        var paraDict = ["page": "\(page)"]
        
        paraDict["state"] = (red_type == RedPacketType.post ? "1" : "2")
        
        cancelRequest = XHRedPacketsViewModel.getMyRedPacketsList(target: self, tableView: tableView, paramter: paraDict, success: { [weak self] (result) in
            self?.hideHud()
            if result is [XHRedPacketModel] {
                let modelsArr = result as! [XHRedPacketModel]
                self?.dataArr.append(contentsOf: modelsArr)
                self?.tableView.reloadData()
                if self?.tableView.mj_footer != nil {
                    if modelsArr.count == 0 {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
            }
        })
        
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyRPDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.rowHeight = 54
        return tableView
    }()
}

extension XHMyRPDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHMyRPDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHMyRPDetailCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

