//
//  XHCommentCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCommentCollCell: UICollectionViewCell {
    
    fileprivate let reuseId = "XHCommentCollCell_reuseId_cell"
    fileprivate var goodsCommitList: [XHGoods_commentModel] = []
    
    var goodsId: String? {
        didSet {
//            loadCommitList()
        }
    }
    
    var controller: XHGoodsDetailController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmpty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 请求评论列表
    fileprivate func loadCommitList() {
        if goodsId == nil {
            controller?.showHint(in: self, hint: "数据错误~")
            return
        }
        let paraDict = ["goods_id": (goodsId)!]
        XHGoodsDetailViewModel.goodsDetai_commentList(paraDict: paraDict, controller!) { [weak self] (result) in
            if result is [XHGoods_commentModel] {
                let modelList = result as! [XHGoods_commentModel]
                self?.goodsCommitList = modelList
                if modelList.count == 0 {
                    self?.setupEmpty()
                }else {
                    self?.setupTableView()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    /// MARK:- ===== 界面相关 ======
    /// 布局tableVIew
    private func setupTableView() {
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(headerView.snp.bottom)
        }
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "XHCommentTableViewCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    /// 布局空界面
    private func setupEmpty() {
        contentView.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(60)
            make.width.equalTo(117)
            make.height.equalTo(124)
        }
        
        contentView.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(emptyImgView.snp.bottom).offset(20)
        }
        
    }
    
    /// MARK:- ====== 懒加载 =======
    /// 空界面
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "assessment_empty_image"))
    
    private lazy var emptyL: UILabel = {
       let label = UILabel()
        label.text = "商品暂时没有评价～"
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
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
    
    private lazy var headerView: XHCommentTableView_HeaderView = XHCommentTableView_HeaderView()
    
}
extension XHCommentCollCell: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return goodsCommitList.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHCommentTableViewCell
        cell.commentModel = goodsCommitList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
