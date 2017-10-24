//
//  XHWinningMsgController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWinningMsgController: UIViewController {

    var type: String? {
        didSet {
            loadMyWinningData()
        }
    }
    
    fileprivate let reuseID_mine = "XHWinningMsgController_reuseID_mine"
    fileprivate let reuseID_announce = "XHWinningMsgController_reuseID_announce"
    fileprivate var haveMyLucky: Bool = false
    
    fileprivate var myWinningArr: Array<XHMyWinningModel> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate var luckyArr: Array<XHLuckyModel> = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNav()
        
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取数据
    private func loadMyWinningData() {
        let paraDict = ["prize_type": type!]
        XHDiscoveryViewModel.getMyWinningRecord(paraDict, self) { [weak self] (result) in
            if result is [XHMyWinningModel] {
                self?.myWinningArr = result as! [XHMyWinningModel]
                if self?.myWinningArr.count != 0 {
                    self?.haveMyLucky = true
                }else {
                    self?.haveMyLucky = false
                }
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
        
        XHDiscoveryViewModel.getAll_WinningRecordall(paraDict, self) { [weak self] (result) in
            if result is [XHLuckyModel] {
                self?.luckyArr = result as! [XHLuckyModel]
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
        
        tableView.register(UINib(nibName: "XHWinning_mineCell", bundle: nil), forCellReuseIdentifier: reuseID_mine)
        tableView.register(UINib(nibName: "XHWinning_luckyCell", bundle: nil), forCellReuseIdentifier: reuseID_announce)
    }
    
    private func setupNav() {
        title = "中奖公告"
    }
    
    // MARK:- 懒加载
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xFFE27C)
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension XHWinningMsgController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return haveMyLucky == true ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if haveMyLucky == true, indexPath.section == 0 {
            let cell: XHWinning_mineCell = tableView.dequeueReusableCell(withIdentifier: reuseID_mine, for: indexPath) as! XHWinning_mineCell
            cell.modelArr = myWinningArr
            return cell
        }
        let cell: XHWinning_luckyCell = tableView.dequeueReusableCell(withIdentifier: reuseID_announce, for: indexPath) as! XHWinning_luckyCell
        cell.modelArr = luckyArr
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.section == 0 {
            let count = myWinningArr.count
            let result = 100 + count * 30 + (count - 2) * 2
            return CGFloat(result)
        }
        let count = luckyArr.count
        let result = 100 + count * 30 + (count - 2) * 2
        return CGFloat(result)
    }
}
