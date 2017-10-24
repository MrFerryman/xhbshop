//
//  XHSalesReturnReasonController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/5.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MBProgressHUD

class XHSalesReturnReasonController: UIViewController {

    fileprivate let reasonList = XHMyOrderViewModel().reasonList
    fileprivate let reuseId = "XHSalesReturnReasonController_reuseID"
    
    /// 当前选中的原因
    fileprivate var currentReason: String?
    fileprivate let viewName = "填写退货原因页面"
    
    
    var orderModel: XHMyOrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
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
    
    private func setupTableView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        tableView.register(XHSalesReturnReasonCell.self, forCellReuseIdentifier: reuseId)
        
        footerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 200)
        tableView.tableFooterView = footerView
        footerView.commitButtonClickedClosure = { [weak self] textView in
            let length = NSString(string: textView.text).length
            if self?.currentReason == nil {
                self?.showHint(in: (self?.view)!, hint: "请选择退货理由~")
            }else if length == 0 || length > 150  {
                self?.showHint(in: (self?.view)!, hint: "理由详情输入有误，请重新输入~")
            }else {
                let paraDict = ["threason": (self?.currentReason)!, "orderid": (self?.orderModel?.id)!, "content": (textView.text)!]
                XHMyOrderViewModel.applyForReturnSales(paraDict: paraDict, self!, dataClosure: { [weak self] (sth) in
                    if ((sth as? String) != nil) {
                        self?.showHint(in: (self?.view)!, hint: (sth as! String))
                    }else {
                        self?.showHint(in: (self?.view)!, hint: "\(sth)")
                    }
                    
                    if (sth as? String) == "申请成功" {
                        let time: TimeInterval = 1.0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            }
        }
    }
    
    private func setupNav() {
        title = "选择退货原因"
    }
    
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
    
    private lazy var footerView: XHSalesReturnReasonFooterView = XHSalesReturnReasonFooterView()
}

extension XHSalesReturnReasonController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHSalesReturnReasonCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHSalesReturnReasonCell
        cell.reasonModel = reasonList[indexPath.row]
        cell.selectedButtonClickedCousre = { [weak self] reasonModel in
            self?.currentReason = reasonModel.title
            for model in (self?.reasonList)! {
                if model.id == reasonModel.id {
                    model.isSele = true
                }else {
                    model.isSele = false
                }
            }
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reasonModel = reasonList[indexPath.row]
        currentReason = reasonModel.title
        for model in reasonList {
            if model.id == reasonModel.id {
                model.isSele = true
            }else {
                model.isSele = false
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}

class XHSalesReturnReasonCell: UITableViewCell {
    
    var selectedButtonClickedCousre: ((_ reasonModel: XHSalesReturnModel) -> ())?
    
    var reasonModel: XHSalesReturnModel? {
        didSet {
            selBtn.isSelected = (reasonModel?.isSele)!
            titleL.text = reasonModel?.title
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func selectedButtonClicked(sender: UIButton) {
        selectedButtonClickedCousre?(reasonModel!)
    }
    
    private func setupUI() {
        addSubview(selBtn)
        selBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(8)
            make.width.height.equalTo(40)
        }
        
        addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(selBtn.snp.right).offset(0)
        }
    }
    
    // MARK:- 懒加载
    private lazy var selBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "profile_rules_unselected"), for: .normal)
        btn.setImage(UIImage(named: "profile_rules_selected"), for: .selected)
        btn.addTarget(self, action: #selector(selectedButtonClicked(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}

class XHSalesReturnReasonFooterView: UIView, UITextViewDelegate {
    
    var commitButtonClickedClosure: ((_ textView: ZYPlaceHolderTextView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func commitButtonClicked() {
        commitButtonClickedClosure?(textView)
    }
    
    private func setupUI() {
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(70)
        }
        
        addSubview(countL)
        countL.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(6)
            make.right.equalTo(-16)
        }
        
        addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(countL.snp.bottom).offset(44)
            make.height.equalTo(40)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let length = NSString(string: textView.text).length
        countL.text = "\(length)" + "/150"
        if length > 150 {
            countL.textColor = .red
        }else {
            countL.textColor = .rgbColorFromHex(rgb: 0xcccccc)
        }
    }
    
    // MARK:- 懒加载
    private lazy var textView: ZYPlaceHolderTextView = {
       let view = ZYPlaceHolderTextView()
        view.placeholder = "请输入详情"
        view.font = UIFont.systemFont(ofSize: 14)
        view.delegate = self
        return view
    }()
    
    private lazy var countL: UILabel = {
        let label = UILabel()
        label.text = "0/150"
        label.textColor = XHRgbColorFromHex(rgb: 0xcccccc)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var commitBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("确认", for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(commitButtonClicked), for: .touchUpInside)
        return btn
    }()
}
