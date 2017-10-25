//
//  XHRegisterProtocolController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHRegisterProtocolController: UIViewController {

    fileprivate let reuseId = "XHRegisterProtocolController_reuseid"
    fileprivate let viewName = "注册协议页面"
    
    /// 用户协议 
    fileprivate var userProtocol: XHHTMLModel?
    /// 风控协议
    fileprivate var controlProtocol: XHHTMLModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        
        title = "协议"
        
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
    
    private func loadData() {
        let userDict = ["helpid": "44"]
        _ = XHGetProtocolViewModel.getProtocol(paraDict: userDict, self) { [weak self] (htmlModel) in
            self?.userProtocol = htmlModel
            self?.tableView.reloadSections([0], with: .automatic)
        }
        
        let controlDict = ["helpid": "46"]
        _ = XHGetProtocolViewModel.getProtocol(paraDict: controlDict, self) { [weak self] (htmlModel) in
            self?.controlProtocol = htmlModel
            self?.tableView.reloadSections([1], with: .automatic)
        }
    }
    
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom).offset(1)
        }
        
        tableView.register(XHRegisterProtocolCell.self, forCellReuseIdentifier: reuseId)
        
        view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-10)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(60)
        }
        view.bringSubview(toFront: footerView)
        footerView.agreeButtonClickedClosure = { [weak self] in
            let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self?.navigationItem.backBarButtonItem = item
            
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            
            let register = XHRegisterViewController()
            self?.navigationController?.pushViewController(register, animated: true)
        }
    }
    
    // MARK:- ======= 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var footerView: XHRegisterProtocolFooterView = XHRegisterProtocolFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 100))

}
extension XHRegisterProtocolController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHRegisterProtocolCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHRegisterProtocolCell
        if indexPath.section == 0 {
            if userProtocol?.alternate_fields1 != nil {
                cell.labelStr = userProtocol?.alternate_fields1
            }
        }else {
            if controlProtocol?.alternate_fields1 != nil {
                cell.labelStr = controlProtocol?.alternate_fields1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        if section == 0 {
            label.text = userProtocol?.title
        }else {
            label.text = controlProtocol?.title
        }
        
        return view
    }
}

class XHRegisterProtocolCell: UITableViewCell {
    
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

class XHRegisterProtocolFooterView: UIView {
    
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


