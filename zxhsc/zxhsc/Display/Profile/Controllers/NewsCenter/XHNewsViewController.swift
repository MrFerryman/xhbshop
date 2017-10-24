//
//  XHNewsViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHNewsViewController: UIViewController {

    fileprivate var dataArr: [XHNewsModel] = []
    fileprivate var reuseId = "XHNewsViewController_cell_reuseId"
    fileprivate let viewName = "新闻中心页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        setupNav()
        setupTableView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
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
    
    // MARK:- 获取数据
    private func loadData() {
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getNewsList, failure: { [weak self] (errorType) in
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
                if sth is [XHNewsModel] {
                    self?.dataArr = sth as! [XHNewsModel]
                    self?.tableView.reloadData()
                }else {
                    self?.showHint(in: (self?.view)!, hint: "未知错误~")
                }
        })
    }

    
    // MARK:- 设置tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        tableView.register(UINib(nibName: "XHNewsTableCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    // MARK:- 设置导航栏
    private func setupNav() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        UIApplication.shared.statusBarStyle = .default
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    // MARK:- 懒加载
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 顶部视图
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
}

extension XHNewsViewController: UITableViewDelegate, UITableViewDataSource {
    // 几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHNewsTableCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHNewsTableCell
        cell.newsModel = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let html = XHHTMLViewController()
        
        html.title = dataArr[indexPath.section].title
        html.helpId = dataArr[indexPath.section].news_id
        navigationController?.pushViewController(html, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
