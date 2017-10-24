//
//  XHFactorJoinController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHFactorJoinController: UIViewController {

    fileprivate let reuseId = "XHFactorJoinController_reuseId"
    
    fileprivate let viewName = "运营商加盟开通页面"
    fileprivate var explainModel: XHHTMLModel? // 体系说明
    fileprivate var flowModel: XHHTMLModel? // 申请流程
    fileprivate var contractModel: XHHTMLModel? // 联系方式
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: explainPath) != nil {
            explainModel = NSKeyedUnarchiver.unarchiveObject(withFile:cl_bannerPath) as? XHHTMLModel
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: flowPath) != nil {
            flowModel = NSKeyedUnarchiver.unarchiveObject(withFile:flowPath) as? XHHTMLModel
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: explainPath) != nil {
            contractModel = NSKeyedUnarchiver.unarchiveObject(withFile:cl_bannerPath) as? XHHTMLModel
        }
        
        setupTableView()
        
        let paraDict = ["helpid": "47"]
        XHFactorJoinViewModel.sharedInstance.getExplainData(paraDict: paraDict, self) { [weak self] (htmlModel) in
            self?.explainModel = htmlModel
            self?.tableView.reloadSections([0], with: .automatic)
            NSKeyedArchiver.archiveRootObject(htmlModel, toFile:explainPath)
        }
        
        let flowDict = ["helpid": "48"]
        XHFactorJoinViewModel.sharedInstance.getExplainData(paraDict: flowDict, self) { [weak self] (htmlModel) in
            self?.flowModel = htmlModel
            self?.tableView.reloadSections([1], with: .automatic)
            NSKeyedArchiver.archiveRootObject(htmlModel, toFile:flowPath)
        }
        
        let conDict = ["helpid": "48"]
        XHFactorJoinViewModel.sharedInstance.getExplainData(paraDict: conDict, self) { [weak self] (htmlModel) in
            self?.contractModel = htmlModel
            self?.tableView.reloadSections([2], with: .automatic)
            NSKeyedArchiver.archiveRootObject(htmlModel, toFile:contractPath)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
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
        
        tableView.register(XHFactorJoinCell.self, forCellReuseIdentifier: reuseId)
        
        headerView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(headerView)
        }
        tableView.tableHeaderView = headerView
        
    }
    
    private func setupNav() {
        title = "代理加盟商"
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
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    // 头部可拉伸图片
    fileprivate lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "factorJoin_banner"))
        headerImageView.clipsToBounds = true
        return headerImageView
    }()
    
    fileprivate lazy var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 170 * kUIScreenWidth / 375))
}

extension XHFactorJoinController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHFactorJoinCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHFactorJoinCell
        
        switch indexPath.section {
        case 0:
            if  explainModel?.alternate_fields1 != nil {
                cell.labelStr = explainModel?.alternate_fields1
            }
        case 1:
            if  flowModel?.alternate_fields1 != nil {
               cell.labelStr = flowModel?.alternate_fields1
            }
        case 2:
            if  contractModel?.alternate_fields1 != nil {
                cell.labelStr = contractModel?.alternate_fields1
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let imgV = UIImageView(image: UIImage(named: "factorJoin_explain"))
        view.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.centerY.equalTo(view)
            make.width.height.equalTo(16)
        }
        
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(imgV)
            make.left.equalTo(imgV.snp.right).offset(8)
        }
        
        switch section {
        case 0:
            label.text = explainModel?.title
        case 1:
            label.text = flowModel?.title
        case 2:
            label.text = contractModel?.title
        default:
            break
        }
        return view
    }
}

class XHFactorJoinCell : UITableViewCell {
    
    var labelStr: String? {
        didSet {
            let attribstr = try! NSAttributedString(data: (labelStr?.data(using: String.Encoding.unicode))! , options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
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
