//
//  XHConfirmOrderPropertyView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SKTagView
import UITableView_FDTemplateLayoutCell

class XHConfirmOrderPropertyView: UIView {

    fileprivate let reuseId = "XHGoodsDetail_goodsPropertyView_propertyCell"
    
    /// 加入购物车按钮点击事件回调
    var addToBuyCarButtonClickedClosure: (() -> ())?
    
    /// 立即购买按钮点击事件回调
    var nowBuyButtonClickedClosure: (() -> ())?
    
    /// 关闭按钮点击事件回调
    var closeButtonClosure: (() -> ())?
    
    fileprivate var dataSource: [XHGoodsPropertyModel] = []
    
    /// 用户选择的数量
    fileprivate var selectedNumber: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ======= 事件相关 ========
    // MARK:- 加入购物车按钮点击事件
    @objc private func addToBuyCarButtonClicked() {
        addToBuyCarButtonClickedClosure?()
    }
    
    /// MARK:- 立即购买按钮点击事件
    @objc private func nowBuyButtonClicked() {
        nowBuyButtonClickedClosure?()
    }
    
    // MARK:- 关闭按钮点击事件
    @objc private func closeButtonClicked() {
        closeButtonClosure?()
    }
    
    // MARK:- ====== 界面相关 ========
    private func setupUI() {
        addSubview(imgView)
        addSubview(priceFontL)
        addSubview(priceNumL)
        addSubview(leftL)
        addSubview(selectNumL)
        addSubview(line)
        addSubview(addToBuyCarBtn)
        addSubview(disappearBtn)
    }
    
    private func setupTableView() {
        addSubview(tableView)
       
        tableView.register(UINib(nibName: "XHGoodsDetail_showPropertyCell", bundle: nil), forCellReuseIdentifier: reuseId)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        disappearBtn.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalTo(-12)
            make.width.height.equalTo(20)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(90)
            make.left.equalTo(20)
            make.top.equalTo(-26)
        }
        
        priceFontL.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(16)
            make.top.equalTo(14)
        }
        
        priceNumL.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceFontL)
            make.left.equalTo(priceFontL.snp.right)
        }
        
        leftL.snp.makeConstraints { (make) in
            make.left.equalTo(priceFontL)
            make.top.equalTo(priceFontL.snp.bottom).offset(2)
        }
        
        selectNumL.snp.makeConstraints { (make) in
            make.left.equalTo(leftL)
            make.top.equalTo(leftL.snp.bottom).offset(2)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(imgView.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        addToBuyCarBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.height.equalTo(45)
            make.width.equalTo(kUIScreenWidth / 2)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(addToBuyCarBtn.snp.top)
        }
    }

    // MARK:- ====== 懒加载 ========
    /// X 按钮
    private lazy var disappearBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "shop_close"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.adjustsImageWhenHighlighted = false
        btn.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 图片
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "loding_icon"))
        imgView.layer.cornerRadius = 6
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    /// 价格
    private lazy var priceFontL: UILabel = {
        let label = UILabel()
        label.text = "价格："
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // 价格数据
    private lazy var priceNumL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "￥300"
        return label
    }()
    
    // 库存
    private lazy var leftL: UILabel = {
        let label = UILabel()
        label.text = "库存：100"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        return label
    }()
    
    // 选择数量规格
    private lazy var selectNumL: UILabel = {
        let label = UILabel()
        label.text = "选择数量规格"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    // 分割线
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return view
    }()
    
    /// 加入购物车按钮
    private lazy var addToBuyCarBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .normal)
        btn.setTitle("加入购物车", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(UIImage(named: "shop_addToBuyCar"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(addToBuyCarButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    /// tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 120
        return tableView
    }()
}

extension XHConfirmOrderPropertyView: UITableViewDelegate, UITableViewDataSource {
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHGoodsDetail_showPropertyCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHGoodsDetail_showPropertyCell
        //        cell.indexPath = indexPath
        cell.tagStrings = dataSource
        
        cell.tagListView.didTapTagAtIndex = { [weak self] idx, tagView in
            
            for i in 0 ..< Int((tagView?.subviews.count)!) {
                let tag: SKTagButton = tagView?.subviews[i] as! SKTagButton
                if tag.titleLabel?.text == self?.dataSource[Int(idx)].value {
                    tag.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
                    tag.setTitleColor(.white, for: .normal)
                }else {
                    tag.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
                    tag.setTitleColor(XHRgbColorFromHex(rgb: 0x333333), for: .normal)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: reuseId, cacheBy: indexPath, configuration: { (cell) in
            let tableCell: XHGoodsDetail_showPropertyCell = cell as! XHGoodsDetail_showPropertyCell
            
            tableCell.tagStrings = self.dataSource
        })
    }
}
