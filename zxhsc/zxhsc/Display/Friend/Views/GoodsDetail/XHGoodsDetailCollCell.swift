//
//  XHGoodsDetailCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetailCollCell: UICollectionViewCell {
    
    fileprivate let reuseId = "XHGoodsDetailCollCell_tableView_cell"
    fileprivate let reuseId_firstSection = "XHGoodsDetailCollCell_tableView_firstSection" // 产品基本信息
    fileprivate let reuseId_type = "XHGoodsDetailCollCell_tableView_cell_type" // 选择规格数量
    fileprivate let reuseId_shop = "XHGoodsDetailCollCell_tableView_cell_shop" // 店铺
    fileprivate let reuseId_content = "XHGoodsDetailCollCell_tableView_cell_content" // 店铺
    
    fileprivate var webViewHeight: CGFloat = 100.0
    
    /// tableViewCell的点击事件回调
    var goodsTableViewCellClickedClosure: ((_ indexPath: IndexPath) -> ())?
    
    /// 选择的规格
    var selectProperty: String = "" {
        didSet {
            tableView.reloadSections([1], with: .automatic)
        }
    }
    
    /// 是否是循环宝商城产品
    var isIntegralGoods: Bool = false
    
    var goodsDetailModel: XHGoodsDetailModel? {
        didSet {
            setupTableView()
        }
    }
    
    var isBranch: Bool = false {
        didSet {
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.bottom.equalTo(-44)
        }
        
        tableView.register(UINib(nibName: "XHGoodsDetail_TableView_firstCell", bundle: nil), forCellReuseIdentifier: reuseId_firstSection)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId_type)
        tableView.register(UINib(nibName: "XHGoodsDetail_TableView_shopCell", bundle: nil), forCellReuseIdentifier: reuseId_shop)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.register(XHGoodsDetail_TableView_ContentCell.self, forCellReuseIdentifier: reuseId_content)
        
        tableView.tableHeaderView = headerView
        headerView.dataImgArr = (goodsDetailModel?.iconArr)!
        
        tableView.tableFooterView = footerView
        footerView.title = "我也是有底线的~"
    }
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    private lazy var headerView: XHGoodsDetail_tableView_HeaderView = {
       let headerView = XHGoodsDetail_tableView_HeaderView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: kUIScreenWidth * 6 / 7))
        return headerView
    }()
    
    private lazy var footerView: XHTableFooterView = XHTableFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 20))
}

extension XHGoodsDetailCollCell: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: XHGoodsDetail_TableView_firstCell = tableView.dequeueReusableCell(withIdentifier: reuseId_firstSection, for: indexPath) as! XHGoodsDetail_TableView_firstCell
            cell.isIntegralGoods = isIntegralGoods
            cell.detailModel = goodsDetailModel?.detailData
            cell.bussinessShop = goodsDetailModel?.supplier
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId_type, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = "请选择数量规格"
            if selectProperty != "  " {
                cell.textLabel?.text = "已选：" + selectProperty
            }
            cell.textLabel?.textColor = XHRgbColorFromHex(rgb: 0x333333)
            return cell
        case 2:
            let cell: XHGoodsDetail_TableView_shopCell = tableView.dequeueReusableCell(withIdentifier: reuseId_shop, for: indexPath) as! XHGoodsDetail_TableView_shopCell
            cell.shopModel = goodsDetailModel?.supplier
            return cell
        default:
            let cell: XHGoodsDetail_TableView_ContentCell = tableView.dequeueReusableCell(withIdentifier: reuseId_content, for: indexPath) as! XHGoodsDetail_TableView_ContentCell
            
            if goodsDetailModel?.detailData?.content?.contains("cn/Public") == false {
                let str = String.kStringByReplaceString(string: (goodsDetailModel?.detailData?.content)!, replaceStr: "/Public", willReplaceStr: "http://appback.zxhshop.cn/Public")
                
                let resultStr =  String.kStringByReplaceString(string: str, replaceStr: "src=", willReplaceStr: "width='100%' src=")
                cell.htmlStr = resultStr
            }else {
                let resultStr =  String.kStringByReplaceString(string: (goodsDetailModel?.detailData?.content)!, replaceStr: "src=", willReplaceStr: "width='100%' src=")
                cell.htmlStr = resultStr
            }
            
            cell.webViewScrollHeightClosure = { [weak self] height in
                self?.webViewHeight = height
                tableView.reloadSections([3], with: .automatic)
            }
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        goodsTableViewCellClickedClosure?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return tableView.fd_heightForCell(withIdentifier: reuseId_firstSection, cacheBy: indexPath, configuration: { [weak self] (cell) in
                let firstCell = cell as! XHGoodsDetail_TableView_firstCell
                firstCell.detailModel = self?.goodsDetailModel?.detailData
            })
        case 1:
            return tableView.fd_heightForCell(withIdentifier: reuseId_type, cacheBy: indexPath, configuration: { (cell) in })
        case 2:
             return tableView.fd_heightForCell(withIdentifier: reuseId_shop, cacheBy: indexPath, configuration: { (cell) in })
        case 3:
            return webViewHeight
        default:
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 44)
            headerView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
            headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 44)
            let titleView = UIView()
            titleView.backgroundColor = .white
            headerView.addSubview(titleView)
            titleView.snp.makeConstraints({ (make) in
                make.top.equalTo(4)
                make.left.bottom.right.equalTo(headerView)
            })
            
            let titleL = UILabel()
            titleL.text = "商品详情"
            titleL.textColor = XHRgbColorFromHex(rgb: 0x333333)
            titleL.font = UIFont.systemFont(ofSize: 14)
            titleView.addSubview(titleL)
            titleL.snp.makeConstraints({ (make) in
                make.centerY.equalTo(titleView)
                make.left.equalTo(16)
            })
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 44
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
