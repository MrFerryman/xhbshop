//
//  XHLogisticsDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHLogisticsDetailController: UIViewController {

    fileprivate var listArr: [XHLogisticsModel] = []
    fileprivate let reuseId_header = "XHLogisticsDetailController_header"
    fileprivate let reuseId_detail = "XHLogisticsDetailController_detail"
    
    fileprivate let viewName = "物流详情页面"
    var orderModel: XHMyOrderModel? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let paraDict = ["look_wl_id": (orderModel?.id)!]
        XHMyOrderViewModel.checkLogisticsDetail(paraDict: paraDict, self) { [weak self] (sth) in
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            
            if sth is [XHLogisticsModel] {
                self?.listArr = sth as! [XHLogisticsModel]
                if self?.listArr.count == 0 {
                    self?.footerFontL.text = "暂无更多物流信息~"
                }else {
                    self?.footerFontL.text = ""
                }
                self?.tableView.reloadData()
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: sth as? String, confirmTitle: "确定", confirmComplete: nil)
                self?.footerFontL.text = "暂无更多物流信息~"
            }
        }
    }
    
    @objc private func refresh() {
        loadData()
    }

    private func setupNav() {
        title = "物流详情"
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        tableView.register(UINib(nibName: "XHLogisticsDetailHeaderCell", bundle: nil), forCellReuseIdentifier: reuseId_header)
        tableView.register(UINib(nibName: "XHLogisticsDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_detail)
        
        tableView.tableFooterView = footerView
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
    }

    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var footerFontL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private lazy var footerView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(self.footerFontL)
        self.footerFontL.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 30)
        return view
    }()
}

extension XHLogisticsDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return listArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHLogisticsDetailHeaderCell = tableView.dequeueReusableCell(withIdentifier: reuseId_header, for: indexPath) as! XHLogisticsDetailHeaderCell
            cell.orderModel = orderModel
            return cell
        }
        let cell: XHLogisticsDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_detail, for: indexPath) as! XHLogisticsDetailCell
        cell.index = indexPath.row
        cell.model = listArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
