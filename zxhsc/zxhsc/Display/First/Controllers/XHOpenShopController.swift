//
//  XHOpenShopController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOpenShopController: UIViewController {

    fileprivate let reuseId = "XHOpenShopController_reuseId"
    fileprivate let reuseId_explain = "XHOpenShopController_reuseId_explain"
    
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
    
    // MARK:- ======== 界面相关 =======
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_explain)
        tableView.register(UINib(nibName: "XHOpenShopAlertCell", bundle: nil), forCellReuseIdentifier: reuseId)
        setHeaderDragableIamge()
    }

    // MARK:- 设置头部可拉伸图片
    fileprivate func setHeaderDragableIamge() {
        headerImageView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 170 * kUIScreenWidth / 375)
        bgView.addSubview(headerImageView)
        
        tableView.tableHeaderView = bgView
        
        tableView.tableFooterView = footerView
        
        footerView.explainLabelTapGestureClosure = { [weak self] in
            let html = XHHTMLViewController()
            html.helpId = "52"
            self?.navigationController?.pushViewController(html, animated: true)
        }
        
        footerView.openButtonClickedClosure = { [weak self] style in
            if style == nil {
                self?.showHint(in: (self?.view)!, hint: "请选择开通店铺类型~")
            }else {
                XHHomePlatformViewModel.sharedInstance.loadPlatformData(self!) { [weak self] (platformList) in
                    if platformList.count > 3 {
                        let amModel = platformList[2]
                        if amModel.status_name == "加入" {
                            let openA = XHOpenAmbassadorController()
                            self?.navigationController?.pushViewController(openA, animated: true)
                        }else {
                            let settingShop = XHShopSettingController()
                            self?.navigationController?.pushViewController(settingShop, animated: true)
                        }
                    }
                }
            }
        }
    }

    private func setupNav() {
        title = "分享店铺系统开通"
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    // MARK:- ======= 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    // 头部可拉伸图片
    fileprivate lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "openShop_banner"))
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    // 头部可拉伸图片 背景视图
    fileprivate lazy var bgView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 170 * kUIScreenWidth / 375))
    
    fileprivate lazy var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 170 * kUIScreenWidth / 375))
    
    fileprivate lazy var footerView: XHOpenShopFooterView = {
       let view = Bundle.main.loadNibNamed("XHOpenShopFooterView", owner: self, options: nil)?.last as! XHOpenShopFooterView
        view.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 250)
        return view
    }()
}

extension XHOpenShopController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_explain, for: indexPath)
            cell.selectionStyle = .none
            let label = UILabel()
            label.text = "开通分享店铺可获得循环奖励，实现跨界经营，整合产品和人脉资源，具体奖励机制请查看帮助中心"
            label.textColor = XHRgbColorFromHex(rgb: 0x333333)
            label.font = UIFont.systemFont(ofSize: 13)
            label.numberOfLines = 0
            cell.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(14)
                make.right.equalTo(-14)
                make.top.equalTo(6)
                make.bottom.equalTo(-6)
            })
            return cell
        }
        
        let cell: XHOpenShopAlertCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHOpenShopAlertCell
        cell.userModel = NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) as? XHUserModel
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 40))
            bgView.backgroundColor = .white
            let iconView = UIImageView(image: UIImage(named: "openShop_alert"))
            let label = UILabel()
            label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
            label.text = "温馨提示"
            label.font = UIFont.systemFont(ofSize: 14)
            bgView.addSubview(iconView)
            iconView.snp.makeConstraints({ (make) in
                make.left.equalTo(14)
                make.centerY.equalTo(bgView)
                make.width.height.equalTo(16)
            })
            
            bgView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerY.equalTo(bgView)
                make.left.equalTo(iconView.snp.right).offset(6)
            })
            
            return bgView
        }
        
        return nil
    }
}
