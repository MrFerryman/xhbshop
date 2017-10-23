//
//  XHMyRPDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyRPDetailController: UIViewController {

    fileprivate var reuseId = "XHMyRPDetailController_reuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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
        return 5
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

