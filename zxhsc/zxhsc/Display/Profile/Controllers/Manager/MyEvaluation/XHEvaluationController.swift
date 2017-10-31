//
//  XHEvaluationController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  我的评价 详细页面

import UIKit
import MJRefresh

class XHEvaluationController: UIViewController {

    var evaType: MyEvaluationType = .willBeEvaluated {
        didSet {
            page = 0
            willBeEvaluatedArr.removeAll()
            checkPendingArr.removeAll()
            setupEmptyUI()
            loadData()
            tableView.reloadData()
        }
    }
    
    // cell的重用标识
    fileprivate let reuseId_willBeEva = "XHEvaluationController_wiiBeEvaluation"
    fileprivate let reuseId_checkPending = "XHEvaluationController_checkPending"
    fileprivate var page: Int = 0
    fileprivate var willBeEvaluatedArr: Array<XHMyValuationModel> = []
    fileprivate var checkPendingArr: Array<XHMyElavation_CheckPendingModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
       loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- 获取我的订单列表
    private func loadData() {
        page += 1
        var paraDict = ["page": "\(page)"]
        switch evaType {
        case .willBeEvaluated: // 待评价
            paraDict["state"] = "1"
        case .checkPending: // 待审核
            paraDict["state"] = "2"
        case .beEvaluation:  // 已评价
            paraDict["state"] = "3"
        }
        
        XHMyOrderViewModel.getMyValuationList(paraDict: paraDict, self, tableView: tableView) { [weak self] (result) in
            if self?.evaType == .willBeEvaluated {
                let modelArr = result as! [XHMyValuationModel]
                switch (self?.evaType)! {
                case .willBeEvaluated: // 待评价
                    self?.willBeEvaluatedArr.append(contentsOf: modelArr)
                default: // 待审核 // 已评价
                    break
                }
                if self?.willBeEvaluatedArr.count == 0 {
                    self?.setupEmptyUI()
                }else {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }
                if self?.tableView.mj_footer != nil {
                    if modelArr.count == 0 {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
            } else if self?.evaType == .checkPending || self?.evaType == .beEvaluation{
                if self?.tableView.mj_footer != nil {
                    self?.tableView.mj_footer.endRefreshing()
                }
                if result is [XHMyElavation_CheckPendingModel] {
                    let modelArr = result as! [XHMyElavation_CheckPendingModel]
                    self?.checkPendingArr.append(contentsOf: modelArr)
                    if self?.checkPendingArr.count == 0 {
                        self?.setupEmptyUI()
                    }else {
                        self?.setupTableView()
                        self?.tableView.reloadData()
                    }
                    if self?.tableView.mj_footer != nil {
                        if modelArr.count == 0 {
                            self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }else {
                            self?.tableView.mj_footer.endRefreshing()
                        }
                    }
                }
                
                
            }
            else {
                self?.hideHud()
                self?.tableView.mj_footer.endRefreshing()
                XHAlertController.showAlert(title: "提示", message: "\(result as? String)", Style: .alert, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    @objc private func refresh() {
        loadData()
    }
    
    // MARK:- ======= 界面相关 ==========
    // MARK:- 布局tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHWillBeEvaluatedCell", bundle: nil), forCellReuseIdentifier: reuseId_willBeEva)
        
        tableView.register(UINib(nibName: "XHCheckPendingCell", bundle: nil), forCellReuseIdentifier: reuseId_checkPending)
        
//        if evaType == .willBeEvaluated {
//            tableView.rowHeight = 112
//        }else {
//            tableView.estimatedRowHeight = 112
//        }
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
    }
    
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(60)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }
    
    private func setupNav() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    // MARK:- ======== 懒加载 ===========
    
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 112
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "assessment_empty_image"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "亲，您暂时没有填写商品评价～"
        return label
    }()
}

extension XHEvaluationController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        switch evaType {
        case .willBeEvaluated:
            return willBeEvaluatedArr.count
        case .checkPending, .beEvaluation:
            return checkPendingArr.count
        }
    }
    
    // 有几个
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if evaType == .willBeEvaluated { // 待评价
            let cell: XHWillBeEvaluatedCell = tableView.dequeueReusableCell(withIdentifier: reuseId_willBeEva, for: indexPath) as! XHWillBeEvaluatedCell
            cell.evaluationModel = willBeEvaluatedArr[indexPath.section]
            cell.evaluationButtonClickedClosure = { [weak self] in
                let doComment = XHDoCommentController()
                doComment.model = self?.willBeEvaluatedArr[indexPath.section]
                self?.navigationController?.pushViewController(doComment, animated: true)
            }
            return cell
        }else { // 待审核 已评价
            let cell: XHCheckPendingCell = tableView.dequeueReusableCell(withIdentifier: reuseId_checkPending, for: indexPath) as! XHCheckPendingCell
            if evaType == .checkPending {
                cell.isComplete = false
                cell.checkModel = checkPendingArr[indexPath.section]
            }else {
                cell.isComplete = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
