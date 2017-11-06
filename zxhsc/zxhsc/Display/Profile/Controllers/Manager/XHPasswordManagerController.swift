//
//  XHPasswordManagerController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPasswordManagerController: UIViewController {

    fileprivate let dataArr = ["修改登录密码", "修改支付密码", "找回支付密码"]
    fileprivate let reuseId = "XHPasswordManagerController_reuseid"
    fileprivate let viewName = "个人中心_密码管理页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        TalkingData.trackPageBegin(viewName)
    }
    
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            if KUIScreenHeight == 812 {
                make.height.equalTo(90)
            }else {
                make.height.equalTo(64)
            }
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        let footerView = UIView()
        tableView.tableFooterView = footerView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
    }
    
    private func setupNav() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    // MARK:- 懒加载
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
}

extension XHPasswordManagerController: UITableViewDelegate, UITableViewDataSource {
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "profile_mima")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = dataArr[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let modify = XHModifyPasswordController()
        modify.title = dataArr[indexPath.row]
        if indexPath.row == 0 {
            modify.isLoginPassword = true
            navigationController?.pushViewController(modify, animated: true)
            
        }else if indexPath.row == 1 {
            modify.isLoginPassword = false
            navigationController?.pushViewController(modify, animated: true)
        }else {
            let forget = XHForgetPasswordController()
            forget.isPaymentPassword = true
            forget.title = dataArr[indexPath.row]
            navigationController?.pushViewController(forget, animated: true)
        }
    }
    
    
}
