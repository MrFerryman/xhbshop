//
//  XHLottoryRegularController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class XHLottoryRegularController: UIViewController {

    fileprivate let reuseId = "XHLottoryRegularController_reuseId"
    fileprivate let viewName = "活动规则页"
    fileprivate var regularStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
        getLottoryRegular()
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
    
    
    private func getLottoryRegular() {
        XHDiscoveryViewModel.getIntegralLottoryRegular(self) { [weak self] (result) in
            self?.regularStr = result as? String
            self?.tableView.reloadData()
        }
    }
    
    // MARK:- 界面相关
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHLottoryRegularCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        let footerView = UIView()
        tableView.tableFooterView = footerView

    }
    
    private func setupNav() {
        title = "活动规则"
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
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

extension XHLottoryRegularController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHLottoryRegularCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHLottoryRegularCell
        cell.regularStr = regularStr
        return cell
    }
}
