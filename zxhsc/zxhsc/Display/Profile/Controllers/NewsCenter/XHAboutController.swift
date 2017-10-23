//
//  XHAboutController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAboutController: UIViewController {

    fileprivate let dataArr = ["给个好评", "客服热线", "版本号"]
    fileprivate let reuseId = "XHAboutController_cell_reuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        let footerView = UIView()
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = headerView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
    }

    // MARK:- 懒加载
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var headerView: XHAboutHeaderView = XHAboutHeaderView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 256))
}

extension XHAboutController: UITableViewDelegate, UITableViewDataSource {
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row]
        
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/cn/app/%E5%BE%AA%E7%8E%AF%E5%AE%9D%E5%95%86%E5%9F%8E/id1249619598?mt=8")!)
        case 1:
            UIApplication.shared.openURL(URL(string: "telprompt://4006012228")!)
        default:
            break
        }
    }
    
    private func setupCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x333333)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.accessoryType = .disclosureIndicator
        }else {
            
            let detailL = UILabel()
            detailL.textColor = UIColor(red: 68 / 255, green: 68 / 255, blue: 68 / 255, alpha: 1.0)
            detailL.font = UIFont.systemFont(ofSize: 14)
            
            cell.contentView.addSubview(detailL)
            detailL.snp.makeConstraints({ (make) in
                make.centerY.equalTo(cell.contentView)
                make.right.equalTo(cell).offset(-30)
            })
            
            if indexPath.row == 1 {
                detailL.text = "400-601-2228"
                cell.accessoryType = .disclosureIndicator
            }else {
                // 版本号
                let infoDictionary: Dictionary = Bundle.main.infoDictionary!
                detailL.text = "V " + (infoDictionary["CFBundleShortVersionString"] as? String)!
            }
        }
    }
    
}

class XHAboutHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(appIconView)
        addSubview(nameView)
        
        // 获取APP的icon图标名称
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let bundleIconD = infoDictionary["CFBundleIcons"] as? Dictionary<String, Any>
        let priIconD = bundleIconD?["CFBundlePrimaryIcon"] as? Dictionary<String, Any>
        let iconsArr = priIconD?["CFBundleIconFiles"] as? Array<String>
        //取最后一个icon的名字
        let iconLastName = iconsArr?.last
        appIconView.image = UIImage(named: iconLastName ?? "profile_header_icon")

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        appIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(44)
            make.width.height.equalTo(100)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(appIconView.snp.bottom).offset(16)
            make.width.equalTo(95)
            make.height.equalTo(42)
        }
    }
    
    // MARK:- ==== 懒加载 =======
    // appIcon
    private lazy var appIconView: UIImageView = UIImageView(image: UIImage(named: "profile_header_icon"))
    
    // nameView
    private lazy var nameView: UIImageView = UIImageView(image: UIImage(named: "about_logo"))
}
