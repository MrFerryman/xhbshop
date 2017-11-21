//
//  XHCycleDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHCycleDetailController: UIViewController {
    
    fileprivate let reuseId = "XHCycleDetailController_cell_reuseid"
    fileprivate let reuseId_unfreezed = "XHCycleDetailController_cell_reuseid_unfreezed"
    fileprivate let viewName = "循环宝明细页面"
    
    fileprivate let isEmpty: Bool = false
    
    var cycleType: CycleType = .all {
        didSet {
            cancelRequest?.cancelRequest()
            if cycleType == .unfreezed {
                loadUnfreezedList()
            }else {
                loadData()
            }
        }
    }
    
    fileprivate var dataArr: [XHCycleModel] = []
    fileprivate var unfreezedList: [XHUnfreezedDetailModel] = []
    
    fileprivate var cancelRequest: XHCancelRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaV()
        setupEmptyUI()
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
        var requestType: XHNetDataType = .cycle_all
        if cycleType == .all {
            requestType = .cycle_all
        }else {
            requestType = .cycle_agent
        }
        
        hideHud()
        
        showHud(in: view)
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: requestType, failure: { [weak self] (errorType) in
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
            }, success: { [weak self] (sth) in
                self?.hideHud()
                if self?.tableView.mj_header != nil {
                    self?.tableView.mj_header.endRefreshing()
                }
                self?.dataArr.removeAll()
                self?.dataArr = sth as! [XHCycleModel]
                if (sth as! [Any]).count > 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
        })
    }
    
    @objc private func refresh() {
        if cycleType == .unfreezed {
            loadUnfreezedList()
        }else {
            loadData()
        }
    }
    
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
    }
    
    
    private func loadUnfreezedList() {
        cancelRequest = XHProfileViewModel.getUnfreezedXHB_detailList(target: self) { [weak self] (result) in
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
            if result is [XHUnfreezedDetailModel] {
                let unfreezedList = result as! [XHUnfreezedDetailModel]
                self?.unfreezedList = unfreezedList
                if unfreezedList.count > 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }
        }
    }
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHCycleDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "XHCycle_UnfreezedCell", bundle: nil), forCellReuseIdentifier: reuseId_unfreezed)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
    }
    
    private func setupNaV() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
    }
    
    // MARK:- ===== 懒加载 =====
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 88
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
        label.text = "亲，您暂时没有获得循环宝~"
        return label
    }()
}

extension XHCycleDetailController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return cycleType == .unfreezed ? unfreezedList.count : dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cycleType == .unfreezed {
            let cell: XHCycle_UnfreezedCell = tableView.dequeueReusableCell(withIdentifier: reuseId_unfreezed, for: indexPath) as! XHCycle_UnfreezedCell
            cell.unfreezedModel = unfreezedList[indexPath.section]
            return cell
        }
        
        let cell: XHCycleDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHCycleDetailCell
        cell.cycleModel = dataArr[indexPath.section]
        return cell
    }
    
    // 头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    // 底部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
