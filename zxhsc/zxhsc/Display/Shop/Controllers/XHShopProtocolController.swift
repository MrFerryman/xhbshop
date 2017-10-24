//
//  XHShopProtocolController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopProtocolController: UIViewController {

    fileprivate let reuseId = "XHShopProtocolController_reuseId"
    fileprivate let viewName = "开通店铺_开通协议页"
    
    fileprivate var protocolModel: XHHTMLModel? {
        didSet {
            title = protocolModel?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNav()
        
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
        showHud(in: view)
        let paraDict = ["helpid": "52"]
        _ = XHRequest.shareInstance.requestNetData(dataType: .helpDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            XHAlertController.showAlert(title: nil, message: title, Style: .alert, confirmTitle: "再来一次", confirmComplete: { 
                self?.loadData()
            })
        }, success: { [weak self] (sth) in
            self?.hideHud()
            if sth is XHHTMLModel {
                self?.protocolModel = sth as? XHHTMLModel
                self?.setupTableView()
                self?.tableView.reloadData()
            }
        })
    }
    
    @objc private func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(XHShopProtocolCell.self, forCellReuseIdentifier: reuseId)
        tableView.tableFooterView = footerView
        footerView.agreeButtonClickedClosure = { [weak self] in
            let openShop = XHOpenShopController()
            self?.navigationController?.pushViewController(openShop, animated: true)
        }
    }
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    fileprivate func setChildViewControllerNav() {
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
    }
    
    // MARK:- ======= 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    private lazy var footerView: XHShopProtocolFooterView = XHShopProtocolFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 100))
}

extension XHShopProtocolController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHShopProtocolCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHShopProtocolCell
        if protocolModel?.alternate_fields1 != nil {
            cell.labelStr = protocolModel?.alternate_fields1
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

class XHShopProtocolCell: UITableViewCell {
    var labelStr: String? {
        didSet {
            let attribstr = try! NSAttributedString.init(data:(labelStr?.data(using: String.Encoding.unicode))! , options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            fontL.attributedText = attribstr
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(fontL)
        fontL.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.top.equalTo(8)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var fontL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}

class XHShopProtocolFooterView: UIView {
    /// 立即开通按钮点击事件回调
    var agreeButtonClickedClosure: (() -> ())?
    
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
        agreeButtonClickedClosure?()
    }
    
    private lazy var openButton: UIButton = {
        let  btn = UIButton(type: .custom)
        btn.setTitle("我同意", for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(openButtonClicked), for: .touchUpInside)
        return btn
    }()
}
