//
//  XHOpenAmbassadorController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOpenAmbassadorController: UIViewController {

    fileprivate let reuseId = "XHOpenAmbassadorController_reuseID"
    fileprivate let reuseId_explain = "XHOpenAmbassadorController_reuseID_reuseId_explain"
    
    
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
    
    // MARK:- 数据请求
    private func postData() {
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .openAmbassador, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (sth) in
            self?.hideHud()
            
        })
    }
    
    // MARK:- ======== 界面相关 =======
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_explain)
        tableView.register(UINib(nibName: "XHOpenAmbassadorCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        headerView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(headerView)
        }
        tableView.tableHeaderView = headerView
        
        tableView.tableFooterView = footerView
        footerView.openButtonClickedClosure = { [weak self] in
            self?.postData()
        }
    }
    
    private func setupNav() {
        title = "循环大使开通"
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
        let headerImageView = UIImageView(image: UIImage(named: "ambassador_banner"))
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    fileprivate lazy var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 170 * kUIScreenWidth / 375))
    
    fileprivate lazy var footerView: XHOpenAmbassadorFooterView = XHOpenAmbassadorFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 100))
}

extension XHOpenAmbassadorController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_explain, for: indexPath)
            cell.selectionStyle = .none
            let label = UILabel()
            label.text = "交纳365元年费的循环使者即成为循环大使，享有推荐商家和推荐顾客消费奖励"
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

        
        let cell: XHOpenAmbassadorCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHOpenAmbassadorCell
        cell.userModel = NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) as? XHUserModel
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 52
        }
        return 175
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}

class XHOpenAmbassadorFooterView: UIView {
    
    /// 立即开通按钮点击事件回调
    var openButtonClickedClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(openButton)
        openButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(40)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
    }
    
    
    @objc private func openButtonClicked() {
        openButtonClickedClosure?()
    }
    
    private lazy var openButton: UIButton = {
        let  btn = UIButton(type: .custom)
        btn.setTitle("立即开通", for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(openButtonClicked), for: .touchUpInside)
        return btn
    }()
}
