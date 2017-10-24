//
//  XHSearchResultController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import YBPopupMenu
import MJRefresh

enum productSortType: Int {
    case proportion = 0 // 比例
    case newest         // 最新
    case price0         // 价格 降序
    case price1         // 价格 升序
    case cycle0         // 循环宝 降序
    case cycle1         // 循环宝 升序
}

enum XHGoodsSearchType {
    case keyword // 关键字
    case typeId    // 类型ID
}

class XHSearchResultController: UIViewController, YBPopupMenuDelegate {

    @IBOutlet weak var topTitleView: UIView!
    
    @IBOutlet weak var salesSolButton: UIButton!
    
    @IBOutlet weak var newestButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    
    @IBOutlet weak var cycleButton: UIButton!
    
    @IBOutlet weak var excitationButton: UIButton!
    
    fileprivate let viewName = "商品搜索结果页面"
    
    /// 商品格子的点击事件回调
    var goodsItemClickedClosure: ((_ model: XHSpecialFavModel) -> ())?
    /// collectionView的滑动事件回调
    var collectionViewScrollClosure: (() -> ())?
    
    var type_id: String? {
        didSet {
            searchType = .typeId
            page = 0
            let paraDict = ["type_id": type_id!, "page": "\(page)"]
            self.paraDict = paraDict
            loadData(paraDict)
        }
    }
    
    var keyword: String? {
        didSet {
            searchType = .keyword
            page = 0
            let paraDict = ["key": keyword!, "page": "\(page)"]
            self.paraDict = paraDict
            loadData(paraDict)
            let btn = UIButton()
            btn.tag = 2
            newestBtnClicked(btn)
        }
    }
    
    /// 排序规则
    var sortStyle: productSortType = .newest
    
    // MARK:- 私有属性
    fileprivate let collMargin: CGFloat = 7 // collectionView各个格子之间的间距
    fileprivate let collLRMargin: CGFloat = 12 // collectionView距离边界的距离
    
    // 标记点击次数 2 表示降序  1 表示升序
    fileprivate var priceTag: Int = 2     // 价格
    fileprivate var cycleTag: Int = 2     // 循环宝
    fileprivate var newest: Int = 2        // 最新
    fileprivate var returnScale: Int = 2  // 让利比
    fileprivate var times: Int = 0           // 激励倍数 0 - 全部 1 - 一倍 2 - 二倍 。。。
    
    // 激励倍数数组
    fileprivate let excitationTitles = ["全部倍数", "5倍激励", "4倍激励", "3倍激励", "2倍激励", "1倍激励"]
    fileprivate let reuseId = "XHSearchResultController_collectionView_Reuse" // collectionView的cell的复用标志
    private var popupMenu: YBPopupMenu?
    
    /// 当前页数
    fileprivate var page: Int = 0
    /// 搜索类型
    fileprivate var searchType: XHGoodsSearchType = .typeId
    /// 数据数组
    fileprivate var dataArr: [XHSpecialFavModel] = []
    
    
    fileprivate var cancelRequest: XHCancelRequest?
    /// 参数字典
    fileprivate var paraDict: Dictionary<String, String> = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        newestButton.isSelected = true
        priceButton.layoutButtonTitleImageEdge(style: .styleLeft, titleImageSpace: 4)
        cycleButton.layoutButtonTitleImageEdge(style: .styleLeft, titleImageSpace: 4)
        excitationButton.layoutButtonTitleImageEdge(style: .styleLeft, titleImageSpace: 4)
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
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
    
    // MARK:- 执行网络操作
    private func excuteLoad() {
        page += 1
        cancelRequest?.cancelRequest()
        
        var paraDict = Dictionary<String, String>()
        paraDict["page"] = "\(page)"
        if searchType == .keyword { // 关键字搜索
            paraDict["key"] = keyword!
            switch sortStyle {
            case .proportion: // 让利比
                paraDict["bili"] = "\(returnScale)"
            case .newest: // 最新
                paraDict["new"] = "\(newest)"
            case .price0, .price1: // 价格
                paraDict["price"] = "\(priceTag)"
            case .cycle0, .cycle1: // 循环宝
                paraDict["xhb"] = "\(cycleTag)"
            }
            
            paraDict["multiple"] = "\(times)"
            self.paraDict = paraDict
            loadData(paraDict)
            
        }else { // typeid 搜索
            paraDict["type_id"] = type_id!
            switch sortStyle {
            case .proportion: // 让利比
                paraDict["bili"] = "\(returnScale)"
            case .newest: // 最新
                paraDict["new"] = "\(newest)"
            case .price0, .price1: // 价格
                paraDict["price"] = "\(priceTag)"
            case .cycle0, .cycle1: // 循环宝
                paraDict["xhb"] = "\(cycleTag)"
            }
            
            paraDict["multiple"] = "\(times)"
            self.paraDict = paraDict
            loadData(paraDict)
        }
        
    }
    
    // MARK:- 刷新
    @objc fileprivate func refresh() {
        excuteLoad()
    }
    
    // MARK:- 请求网络数据
    private func loadData(_ paraDict: Dictionary<String, String>) {
        
        showHud(in: view)
        cancelRequest = XHRequest.shareInstance.requestNetData(dataType: .search_goods, parameters: paraDict, failure: { [weak self] (errorType) in
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
            if sth is [XHSpecialFavModel] {
                if self?.page == 1 {
                    self?.dataArr.removeAll()
                }
                let modelArr = sth as! [XHSpecialFavModel]
                self?.dataArr.append(contentsOf: modelArr)
                self?.collectionView.reloadData()
                if self?.dataArr.count == 0 {
                    self?.setupEmptyUI()
                    self?.showHint(in: (self?.view)!, hint: "暂无更多数据~")
                }else {
                    self?.setupCollectionView()
                 }
            }
            
            if self?.collectionView.mj_footer != nil {
                if (sth as! [XHSpecialFavModel]).count == 0 {
                    self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self?.collectionView.mj_footer.endRefreshing()
                }
            }
        })
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            excitationButton.imageView?.transform = CGAffineTransform.identity
            popupMenu?.dismiss()
        }
        sender.cancelsTouchesInView = false
    }

    
    func reset() {
        setupButtonStatus(btnTag: 2)
    }
    
    // MARK:- ======= 事件相关 =========
    /// MARK:- 销量按钮的点击事件
    @IBAction func salesVolBtnClicked(_ sender: UIButton) {
        returnScale = returnScale == 2 ? 1 : 2
        page = 0
        setupButtonStatus(btnTag: sender.tag)
        excuteLoad()
    }
    
    /// MARK:- 最新按钮点击事件
    @IBAction func newestBtnClicked(_ sender: UIButton) {
        newest = newest == 2 ? 1 : 2
        page = 0
        setupButtonStatus(btnTag: sender.tag)
        excuteLoad()
    }
    
    /// MARK:- 价格按钮的点击事件
    @IBAction func priceBtnClicked(_ sender: UIButton) {
        setupButtonStatus(btnTag: sender.tag)
        let imgName: String = priceTag == 2 ? "Group-jiantou-hei1" : "Group-jiantou-hei2"
        sender.setImage(UIImage(named: imgName), for: .selected)
        priceTag = priceTag == 2 ? 1 : 2
        page = 0
        excuteLoad()
    }
    
    /// MARK:- 循环宝按钮的点击事件
    @IBAction func cycleBtnClicked(_ sender: UIButton) {
        setupButtonStatus(btnTag: sender.tag)
        let imgName: String = cycleTag == 2 ? "Group-jiantou-hei1" : "Group-jiantou-hei2"
        sender.setImage(UIImage(named: imgName), for: .selected)
        cycleTag = cycleTag == 2 ? 1 : 2
        page = 0
        excuteLoad()
    }

    /// MARK:- 激励倍数按钮点击事件
    @IBAction func excitationBtnClicked(_ sender: UIButton) {
        
        sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        popupMenu?.dismiss()
        YBPopupMenu.showRely(on: sender, titles: excitationTitles, icons: nil, menuWidth: 80) { [weak self] (popMenu) in
            self?.popupMenu = popMenu
            popMenu?.showMaskView = true
            popMenu?.dismissOnTouchOutside = true
            popMenu?.delegate = self
            popMenu?.fontSize = 12
            popMenu?.itemHeight = 30
            popMenu?.backColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            popMenu?.textColor = .white
        }
    }
    
    // MARK:- 激励倍数弹出视图的代理事件
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        excitationButton.isSelected = true
        excitationButton.imageView?.transform = CGAffineTransform.identity
        
        excitationButton.setTitle(excitationTitles[index], for: .selected)
        
        if index == 0 {
            times = index
        }else {
            times = 6 - index
        }
        page = 0
        excuteLoad()
    }
    
    private func setupButtonStatus(btnTag: Int) {
        salesSolButton.isSelected = salesSolButton.tag == btnTag ? true : false
        if salesSolButton.isSelected == true {
            sortStyle = .proportion
        }
        newestButton.isSelected = newestButton.tag == btnTag ? true : false
        if newestButton.isSelected == true {
            sortStyle = .newest
        }

        priceButton.isSelected = priceButton.tag == btnTag ? true : false
        if priceButton.isSelected == false {
            priceButton.setImage(UIImage(named: "Group-jiantou-hei"), for: .normal)
            priceTag = 2
        }else {
            sortStyle = priceTag == 2 ? .price0 : .price1
        }
        
        cycleButton.isSelected = cycleButton.tag == btnTag ? true : false
        if cycleButton.isSelected == false {
            cycleButton.setImage(UIImage(named: "Group-jiantou-hei"), for: .normal)
            cycleTag = 2
        }else {
            sortStyle = cycleTag == 2 ? .cycle0 : .cycle1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionViewScrollClosure?()
    }
    
    // MARK:- ====== 界面相关 =======
    // MARK:- 设置collectionView
    private func setupCollectionView() {
        emptyImgView.removeFromSuperview()
        emptyL.removeFromSuperview()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(topTitleView.snp.bottom)
        }
        
        collectionView.register(UINib(nibName: "XHSpecialCollViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
    }
    
    private func setupEmptyUI() {
        collectionView.removeFromSuperview()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topTitleView.snp.bottom).offset(60)
            make.width.equalTo(167)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(38)
        }
    }
    
    // MARK:- 懒加载
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = self.collMargin
        layout.minimumLineSpacing = self.collMargin
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(self.collLRMargin, self.collLRMargin, 0, self.collLRMargin)
        
        layout.itemSize = CGSize(width: (kUIScreenWidth - self.collLRMargin * 2 - self.collMargin) / 2, height: 220)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.delegate = self
        view.dataSource = self
        return view
        
    }()
    
    // 空页面
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "goods_empty_image"))
    private lazy var emptyL: UILabel = {
        let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "暂时没有相关产品，敬请期待～"
        return label
    }()
}

extension XHSearchResultController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 有几个格子
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHSpecialCollViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! XHSpecialCollViewCell
        cell.sessionGoodsM = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        goodsItemClickedClosure?(model)
    }
    
}
