//
//  XHScaleRankController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHScaleRankController: UIViewController {

    fileprivate let reuseId = "XHScaleRankController_reuseId"
    fileprivate var scaleList: [XHScaleRankModel] = []
    
    fileprivate let viewName = "每日指数排行页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "业绩指数排行"
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
    
    // MARK:- 加载数据
    @objc private func loadData() {
        XHHomePlatformViewModel.sharedInstance.getScaleRankList(self) { [weak self] (scaleRankList) in
            self?.scaleList = scaleRankList
            self?.tableView.reloadData()
            if self?.tableView.mj_header != nil {
                self?.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    // MARK:- 界面布局
    private func setupTableView() {
        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.bottom.right.equalTo(view)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.bottom.right.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHScaleRankCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        header?.stateLabel.textColor = .white
        header?.lastUpdatedTimeLabel.textColor = .white
        tableView.mj_header = header
    }
    

    // MARK:- 懒加载
    // 背景图
    private lazy var bgView: UIImageView = UIImageView(image: UIImage(named: "scaleRank_bg"))
    // tableVIew
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension XHScaleRankController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scaleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHScaleRankCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHScaleRankCell
        cell.scaleModel = scaleList[indexPath.row]
        if indexPath.row % 2 == 0 {
            cell.bgImgView.isHidden = false
        }else {
            cell.bgImgView.isHidden = true
        }
        return cell
    }
}
