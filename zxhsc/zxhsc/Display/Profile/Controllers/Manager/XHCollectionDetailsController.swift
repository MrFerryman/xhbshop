//
//  XHCollectionDetailsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCollectionDetailsController: UIViewController {

    var collectionsType: CollectionType = .goods {
        didSet {
            loadData()
        }
    }
    
    /// 是否是编辑状态
    var isTableViewEditing: Bool = false {
        didSet {
            if isTableViewEditing == true {
                tableView.setEditing(true, animated: true)
            }else {
                tableView.setEditing(false, animated: true)
            }
        }
    }
    
    fileprivate var cancelRequest: XHCancelRequest?
    
    fileprivate let reuseId_goods = "XHCollectionDetailsController_reuseId_goods"
    fileprivate let reuseId_shop = "XHCollectionDetailsController_reuseId_shop"
    
    fileprivate let isEmpty: Bool = false
    
    fileprivate var dataArr: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyUI()
       loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelRequest?.cancelRequest()
    }
    
    private func loadData() {
        var requestType: XHNetDataType = .getMyCollectionList_goods
        if collectionsType == .goods {
            requestType = .getMyCollectionList_goods
        }else {
            requestType = .getMyCollectionList_shop
        }
        cancelRequest?.cancelRequest()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: requestType, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }, success: { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHCollection_goodsModel] {
                let goodsArr = sth as! [XHCollection_goodsModel]
                if goodsArr.count > 0 {
                    self?.setupTableView()
                    self?.dataArr.removeAll()
                    self?.dataArr = goodsArr
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }
            }else if sth is [XHCollection_shopModel] {
                let shopsArr = sth as! [XHCollection_shopModel]
                if shopsArr.count > 0 {
                    self?.setupTableView()
                    self?.dataArr.removeAll()
                    self?.dataArr = shopsArr
                    self?.tableView.reloadData()
                }else {
                    self?.setupEmptyUI()
                }

            }
        })
    }
    
    // MARK:- 取消收藏
    fileprivate func cancelCollection(indexPath: IndexPath) {
        
        var requestType: XHNetDataType = .cancelCollection_shop
        
        var paraDict: [String: String]?
        if collectionsType == .goods {
            requestType = .cancelCollection_goods
            let goodsModel = dataArr[indexPath.section] as! XHCollection_goodsModel
            paraDict = ["id": goodsModel.coll_id!]
        }else {
            requestType = .cancelCollection_shop
            let shopM = dataArr[indexPath.section] as! XHCollection_shopModel
            paraDict = ["id": shopM.coll_id!]
        }
       
        showHud(in: view, hint: "删除中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: requestType, parameters: paraDict, failure: { [weak self] (errorType) in
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
            self?.showHint(in: (self?.view)!, hint: sth as! String)
            if (sth as! String) == "操作成功" {
                self?.dataArr.remove(at: indexPath.section)
                // 刷新
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK:- ==== 界面相关 ======
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
        
        if collectionsType == .goods {
            emptyL.text = "亲，您暂时没有收藏商品～"
        }else {
            emptyL.text = "亲，您暂时没有收藏店铺～"
        }
    }
    
    // MARK:- tableView的设置
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHCollectionDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_goods)
        tableView.register(UINib(nibName: "XHCollection_shopCell", bundle: nil), forCellReuseIdentifier: reuseId_shop)
        
        setupNav()
    }

    private func setupNav() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
    
    // MARK:- 懒加载
    // tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()
    
    // 空页面图片
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "order_nothing"))
    
    // 空页面label
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

}
extension XHCollectionDetailsController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if collectionsType == .goods {
            let cell: XHCollectionDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_goods, for: indexPath) as! XHCollectionDetailCell
            cell.goodsModel = dataArr[indexPath.section] as? XHCollection_goodsModel
            return cell
        }
        
        let cell: XHCollection_shopCell = tableView.dequeueReusableCell(withIdentifier: reuseId_shop, for: indexPath) as! XHCollection_shopCell
        cell.shopModel = dataArr[indexPath.section] as? XHCollection_shopModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if collectionsType == .goods {
            let goodsDetail = XHGoodsDetailController()
            goodsDetail.goodsId = (dataArr[indexPath.section] as? XHCollection_goodsModel)?.goods_id
            navigationController?.pushViewController(goodsDetail, animated: true)
        }else {
            let shopVc = XHBussinessShopController()
            shopVc.shopId = (dataArr[indexPath.section] as? XHCollection_shopModel)?.shop_id
            tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(shopVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        self.cancelCollection(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
