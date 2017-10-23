//
//  XHShopClassController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHShopClassController: UIViewController {

    fileprivate let reuseId = "XHShopClassController_tableView_cell"
    
    private let isEmpty: Bool = false
    
    fileprivate var dataArr: Array<XHBussinessShopModel> = []
    
    private var page: Int = 0
    
    var classId: String? {
        didSet {
            loadData()
        }
    }
    
    
    /// 搜索的key
    var searchKey: String? {
        didSet {
            searchShop()
        }
    }
    
    /// 跳转到第二个页面
    var jumpToNextViewClosure: ((_ shopModel: XHBussinessShopModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 刷新
    @objc private func refresh() {
        loadData()
    }
    
    // MARK:-  网络请求
    private func loadData() {
        
        page += 1
        
        let paraDict = ["page": "\(page)", "cateid": classId!]
        
        if page == 1 {
            showHud(in: view)
        }
        _ = XHRequest.shareInstance.requestNetData(dataType: .getRecommandShopList, parameters: paraDict, failure: { [weak self] (errorType) in
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
            
            if sth is [XHBussinessShopModel] {
                self?.dataArr.append(contentsOf: sth as! [XHBussinessShopModel])
                if self?.tableView.mj_footer != nil {
                    if (sth as! [XHBussinessShopModel]).count == 0 {
                        self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.tableView.mj_footer.endRefreshing()
                    }
                }
               
                if (self?.dataArr.count)! > 0 {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }else {
                if self?.tableView.mj_footer != nil {
                    self?.tableView.mj_footer.endRefreshing()
                }
                self?.setupEmptyUI()
            }
        }
    }
    
    // MARK:- 搜索事件
    private func searchShop() {
        
        let paraDict = ["key": searchKey!]
        XHSearchShopListViewModel.searchShopList(paraDict, self) { [weak self] (result) in
            if result is [XHBussinessShopModel] {
                if (result as! [XHBussinessShopModel]).count > 0 {
                    self?.dataArr = result as! [XHBussinessShopModel]
                    self?.setupTableView()
                    self?.tableView.mj_footer = nil
                }else {
                    self?.setupEmptyUI()
                }
            }
        }
    }
    
    // MARK:- ====== 界面相关 ========
    // MARK:- 布局tableView
    private func setupTableView() {
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
        
        tableView.register(UINib(nibName: "XHRecommendViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
    }
    // MARK:- 布局空界面
    private func setupEmptyUI() {
        
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.removeFromSuperview()
        
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(124)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }

    // MARK:- ========= 懒加载
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 114
        return tableView
    }()
    
    // 空界面 图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "shop_empty_image"))
    
    // 空界面 label
    private lazy var emptyL: UILabel = {
       let label = UILabel()
        label.text = "暂时没有相关店铺，欢迎入驻～"
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

extension XHShopClassController: UITableViewDelegate, UITableViewDataSource {
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHRecommendViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHRecommendViewCell
        cell.shopModel = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        let shopVc = XHBussinessShopController()
        shopVc.shopId = model.shopId
        navigationController?.pushViewController(shopVc, animated: true)
        if searchKey != nil {
            jumpToNextViewClosure?(model)
        }
    }
}
