//
//  XHGoodsDetail_goodsPropertyView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/5.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import SKTagView

class XHGoodsDetail_goodsPropertyView: UIView {

    fileprivate let reuseId = "XHGoodsDetail_goodsPropertyView_propertyCell"
    
    /// 加入购物车按钮点击事件回调
    var addToBuyCarButtonClickedClosure: (() -> ())?
    
    /// 立即购买按钮点击事件回调
    var nowBuyButtonClickedClosure: (() -> ())?
    
    /// 关闭按钮点击事件回调
    var closeButtonClosure: (() -> ())?
    
    /// 属性选择之后的回调
    var propertySelectedClosure: ((_ property1: XHGoodsPropertyModel?, _ property2: XHGoodsPropertyModel?, _ count: Int) -> ())?
    
    /// 是否是循环宝商城产品
    var isIntegralGoods: Bool = false {
        didSet {
            integralPriceL.isHidden = !isIntegralGoods
        }
    }
    
    var goodsModel: XHGoodsDetailModel? {
        didSet {
            
            priceNumL.text = goodsModel?.detailData?.price
            
            if goodsModel?.detailData?.stock != nil {
                leftL.text = "库存：" + (goodsModel?.detailData?.stock)!
            }
            
            dataSource = (goodsModel?.propertyArr)!
            
            if goodsModel?.propertyArr.count != 0  {
                if goodsModel?.propertyArr[0].value != nil {
                    loadPropertyData((goodsModel?.propertyArr[0].value)!)
                    selectedPro1 = goodsModel?.propertyArr[0]
                }
            }
            
            if goodsModel?.detailData?.icon != nil {
                 imgView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.detailData?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage))
            }
            
            if isIntegralGoods == true {
                integralPriceL.isHidden = false
                if goodsModel?.detailData?.integral != nil {
                    priceFontL.text = "积分(循环宝):"
                    priceNumL.text = "\(String(describing: (goodsModel?.detailData?.integral)!))"
                }
                
                if goodsModel?.detailData?.price != nil {
                    let price = NSString(string: (goodsModel?.detailData?.price)!).floatValue
                    if price == 0.0 {
                        integralPriceL.text = ""
                    }else {
                        integralPriceL.text = "+￥" + "\(price)"
                    }
                }
            }
        }
    }
    
    fileprivate var dataSource: Array<XHGoodsPropertyModel> = [] // 第一属性数组
    fileprivate var secondProArr:  Array<XHGoodsPropertyModel> = [] { // 第二属性数组
        didSet {
            if secondProArr.count != 0 {
                selectedPro2 = secondProArr[0]
            }
        }
    }
    
    
    fileprivate var selectedPro1: XHGoodsPropertyModel? { // 选中的第一属性值
        didSet {
            selectNumL.text = "已选：" + "\((selectedPro1?.value ?? "")!)" + " " + "\((selectedPro2?.value ?? "")!)" + " "  + "“" + "\(goodsNum)" + "”"
            propertySelectedClosure?(selectedPro1, selectedPro2, goodsNum)
        }
    }
    fileprivate var selectedPro2: XHGoodsPropertyModel? { // 选中的第二属性值
        didSet {
            selectNumL.text = "已选：" + "\((selectedPro1?.value ?? "")!)" + " " + "\((selectedPro2?.value ?? "")!)" + " "  + "“" + "\(goodsNum)" + "”"
            propertySelectedClosure?(selectedPro1, selectedPro2, goodsNum)
        }
    }
    
    fileprivate var goodsNum: Int = 1 {
        didSet {
            selectNumL.text = "已选：" + "\((selectedPro1?.value ?? "")!)" + " " + "\((selectedPro2?.value ?? "")!)" + " " + "“" + "\(goodsNum)" + "”"
            propertySelectedClosure?(selectedPro1, selectedPro2, goodsNum)
        }
    }
    
    fileprivate var stockNum: String? { // 商品库存
        didSet {
            if stockNum != nil {
                leftL.text = "库存：" + stockNum!
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadPropertyData(_ value: String) {
        let paraDict = ["zdval": value, "spid": (goodsModel?.detailData?.goods_id)!]
        let vc = UIViewController()
        vc.showHud(in: self, hint: "正在检查库存...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .checkGoodsStock, parameters: paraDict, failure: { [weak self] (errorType) in
            vc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            vc.showHint(in: (self?.superview)!, hint: title!)
        }, success: { [weak self] (sth) in
            vc.hideHud()
            if sth is [XHGoodsPropertyModel] {
                let proArr = sth as! [XHGoodsPropertyModel]
                self?.secondProArr.removeAll()
                self?.secondProArr.append(contentsOf: proArr)
                self?.tableView.reloadData()
            }
        })
    }
    
    
    // MARK:- ======= 事件相关 ========
    // MARK:- 加入购物车按钮点击事件
    @objc private func addToBuyCarButtonClicked() {
        if NSString(string: (goodsModel?.detailData?.stock ?? "0")).integerValue > goodsNum {
            propertySelectedClosure?(selectedPro1, selectedPro2, goodsNum)
            addToBuyCarButtonClickedClosure?()
        }else {
            closeButtonClosure?()
            XHAlertController.showAlertSigleAction(title: "提示", message: "该商品库存不足", confirmTitle: "朕知道了", confirmComplete: nil)
        }
    }
    
    /// MARK:- 立即购买按钮点击事件
    @objc private func nowBuyButtonClicked() {
        if NSString(string: (goodsModel?.detailData?.stock ?? "0")).integerValue >= goodsNum {
            propertySelectedClosure?(selectedPro1, selectedPro2, goodsNum)
            nowBuyButtonClickedClosure?()
        }else {
            closeButtonClosure?()
            XHAlertController.showAlertSigleAction(title: "提示", message: "该商品库存不足", confirmTitle: "朕知道了", confirmComplete: nil)
        }
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
        addSubview(integralPriceL)
        addSubview(leftL)
        addSubview(selectNumL)
        addSubview(line)
        addSubview(addToBuyCarBtn)
        addSubview(nowBuyBtn)
        addSubview(disappearBtn)
    }
    
    private func setupTableView() {
        addSubview(tableView)
        numberView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 40)
        tableView.tableFooterView = numberView
        /// 选择数量值的改变事件回调
        numberView.numberLabelValueChangedClosure = { [weak self] value in
            self?.goodsNum = value
        }
        
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
        
        integralPriceL.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceNumL)
            make.left.equalTo(priceNumL.snp.right).offset(5)
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
        
        if isIntegralGoods == true {
            nowBuyBtn.snp.makeConstraints { (make) in
                make.left.bottom.right.equalTo(self)
                make.height.equalTo(44)
            }
        }else {
            addToBuyCarBtn.snp.makeConstraints { (make) in
                make.left.bottom.equalTo(self)
                make.height.equalTo(45)
                make.width.equalTo(kUIScreenWidth / 2)
            }
            
            nowBuyBtn.snp.makeConstraints { (make) in
                make.bottom.right.equalTo(self)
                make.width.height.equalTo(addToBuyCarBtn)
            }
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(nowBuyBtn.snp.top)
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
    
    // 积分兑换
    private lazy var integralPriceL: UILabel = {
        let label = UILabel()
        label.backgroundColor = XHRgbColorFromHex(rgb: 0x53B6FF)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
//        label.text = "+￥0"
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.isHidden = true
        return label
    }()
    
    // 库存
    private lazy var leftL: UILabel = {
       let label = UILabel()
        label.text = "库存：0"
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
    
    /// 立即购买按钮
    private lazy var nowBuyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xffffff), for: .normal)
        btn.setTitle("立即购买", for: .normal)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(nowBuyButtonClicked), for: .touchUpInside)
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
    
    private lazy var numberView: XHGoodsDetail_propertyTable_FooterView = XHGoodsDetail_propertyTable_FooterView()
}

extension XHGoodsDetail_goodsPropertyView: UITableViewDelegate, UITableViewDataSource {
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count != 0, secondProArr.count != 0 {
            return 2
        }else if dataSource.count != 0, secondProArr.count == 0 {
            return 1
        }else {
            return 0
        }
    }
    
    /// cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHGoodsDetail_showPropertyCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHGoodsDetail_showPropertyCell
        
        if indexPath.row == 0 {
            cell.selectedStr = selectedPro1?.value
            cell.tagStrings = dataSource
        }else {
            cell.selectedStr = selectedPro2?.value
            cell.tagStrings = secondProArr
        }
        
        cell.indexPath = indexPath
        
        cell.tagViewDidClickClosure = { [weak self] idx, tagView, tagStringArr, indexP in
            for i in 0 ..< Int((tagView.subviews.count)) {
                let tag: SKTagButton = tagView.subviews[i] as! SKTagButton
                let propertyModel = tagStringArr[i]
                
                // 库存
                self?.stockNum = propertyModel.stock
                
                if tag.titleLabel?.text == tagStringArr[Int(idx)].value {
                    tag.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
                    tag.setTitleColor(.white, for: .normal)
                    if indexP.row == 0 {
                       self?.loadPropertyData(tagStringArr[Int(idx)].value ?? "0")
                        self?.selectedPro1 = propertyModel
                        self?.selectedPro2 = nil
                    }else {
                        self?.selectedPro2 = propertyModel
                    }
                }else {
                    let stock = NSString(string: propertyModel.stock!).floatValue
                    if stock != 0 {
                        tag.backgroundColor = XHRgbColorFromHex(rgb: 0xeeeeee)
                        tag.setTitleColor(XHRgbColorFromHex(rgb: 0x333333), for: .normal)
                    }else {
                        tag.setTitleColor(XHRgbColorFromHex(rgb: 0xaaaaaa), for: .normal)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: reuseId, cacheBy: indexPath, configuration: { [weak self] (cell) in
            let tableCell: XHGoodsDetail_showPropertyCell = cell as! XHGoodsDetail_showPropertyCell
            if indexPath.row == 0 {
                tableCell.tagStrings = self?.dataSource
            }else {
                tableCell.tagStrings = self?.secondProArr
            }
        })
    }
}

class XHGoodsDetail_propertyTable_FooterView: UIView {
    
    /// 数量label值的改变事件回调
    var numberLabelValueChangedClosure: ((_ value: Int) -> ())?
    
    private var number: Int = 1 {
        didSet {
            if number == 1 {
                minusBtn.isEnabled = false
            }else {
                minusBtn.isEnabled = true
            }
            numberLabelValueChangedClosure?(number)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 事件相关 ==
    // MARK:- 减号按钮的点击事件
    @objc private func minusButtonClicked() {
       
       number -= 1
        numberL.text = "\(number)"
    }
    
    // MARK:- 减号按钮的点击事件
    @objc private func plusButtonClicked() {
        number += 1
        numberL.text = "\(number)"
    }
    
    // MARK:- ======= 界面相关 ========
    private func setupUI() {
        addSubview(fontL)
        addSubview(line)
        addSubview(plusBtn)
        addSubview(numberL)
        addSubview(minusBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fontL.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        plusBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.height.equalTo(25)
            make.right.equalTo(-20)
        }
        
        numberL.snp.makeConstraints { (make) in
            make.right.equalTo(plusBtn.snp.left).offset(-1)
            make.centerY.equalTo(self)
            make.width.equalTo(27)
            make.height.equalTo(25)
        }
        
        minusBtn.snp.makeConstraints { (make) in
            make.right.equalTo(numberL.snp.left).offset(-1)
            make.centerY.equalTo(self)
            make.width.height.equalTo(25)
        }
    }
    
    // MARK:- ======= 懒加载 =========
    // 文字
    private lazy var fontL: UILabel = {
       let label = UILabel()
        label.text = "购买数量"
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // 分割线
    private lazy var line: UIView = {
       let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return view
    }()
    
    /// - 减号按钮
    private lazy var minusBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xaaaaaa), for: .normal)
        btn.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1.0)
        btn.setTitle("-", for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(minusButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 加号按钮点击事件
    private lazy var plusBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1.0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xaaaaaa), for: .normal)
        btn.setTitle("+", for: .normal)
        btn.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    /// 数量
    private lazy var numberL: UILabel = {
       let label = UILabel()
        label.text = "1"
        label.textAlignment = .center
        label.backgroundColor =  UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1.0)
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}
