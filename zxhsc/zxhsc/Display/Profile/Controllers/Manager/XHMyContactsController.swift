//
//  XHMyContactsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyContactsController: UIViewController {

    // tableView的重用标志
    fileprivate let reuseId = "XHMyContactsController_reuseId"
    
    fileprivate let viewName = "我的人脉页面"
    
    fileprivate var dataArr: [XHMyContactsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupNav()
        
        loadData()
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
    
    // MARK:- 获取数据
    private func loadData() {
        
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .myContactList, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            if sth is Array<XHMyContactsModel> {
                let contactList = sth as! Array<XHMyContactsModel>
                self?.dataArr = contactList
                if contactList.count > 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }
        }
    }

    // MARK:- ======= 界面相关 =======
    // MARK:- 设置tableView
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topViw.snp.bottom)
        }
        
        tableView.register(UINib(nibName: "XHMyContactsCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    // MARK:- 布局空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topViw.snp.bottom).offset(60)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }

    
    // MARK:- 设置导航栏
    private func setupNav() {
        title = "一度人脉"
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(topViw)
        topViw.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
    }
    
    // MARK:- 懒加载
    
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // topView
    private lazy var topViw: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "contact_empty_image"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "亲，您暂时还没有人脉～"
        return label
    }()

}

extension XHMyContactsController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHMyContactsCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHMyContactsCell
        cell.contactModel = dataArr[indexPath.section]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
}
