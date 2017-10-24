//
//  XHShoppingCartController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  购物车

import UIKit

class XHShoppingCartController: UIViewController, UIGestureRecognizerDelegate, UINavigationBarDelegate {

    fileprivate let reuseId_normal = "XHShoppingCartController_reuseId_normal"
    fileprivate let reuseId_editting = "XHShoppingCartController_reuseId_editting"
    fileprivate let viewName = "购物车页面"
    
    /// 控制是否是编辑状态
    fileprivate var isCellEditting: Bool = false
    
    fileprivate var dataSource: [XHShoppingCartModel] = [] {
        didSet {
            if dataSource.count == 0 {
                self.setupEmptyUI()
                self.bottomView.isHidden = true
            }
        }
    }
    
    /// 存放被选中的订单数组
    fileprivate var selectedModelsArr: [XHShoppingCartModel] = [] {
        didSet {
            bottomView.shoppingModelsArr = selectedModelsArr
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        automaticallyAdjustsScrollViewInsets = true
        TalkingData.trackPageEnd(viewName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    // MARK:- 获取网络数据
    private func loadData() {
        XHShoppingCartViewModel.getShoppingCartList( self) { [weak self] (result) in
            self?.dataSource = result
            if result.count == 0 {
                self?.setupNav()
                self?.setupEmptyUI()
            }else {
                self?.setupNav()
                self?.setupTableView()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK:- 修改购物车
    private func modifyShoppingCart() {
        var para = Array<Any>()
        for model in dataSource {
            var innerArr = Array<String>()
            innerArr.append(model.id!)
            innerArr.append(model.buyCount!)
            innerArr.append(model.goods_id!)
            innerArr.append(model.tab_Id!)
            innerArr.append(model.property1 ?? "")
            para.append(innerArr)
        }
        let paraDict = ["cart": "\(para)"]
        XHShoppingCartViewModel.changeShoppingCart(paraDict, self) { (result) in
        }
    }
    
    // MARK:- ====== 事件相关 =====
    /// MARK:- 编辑按钮点击事件
    @objc private func editButtonClicked(_ sender: UIBarButtonItem) {
        if sender.title == "编辑" {
             sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0xea2000), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
            sender.title = "完成"
            isCellEditting = true
        }else {
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x666666), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
            isCellEditting = false
            sender.title = "编辑"
            modifyShoppingCart()
        }
        
        tableView.reloadData()
    }
    
    // MARK:- 收藏按钮点击事件
    fileprivate func collectedProduct(_ model: XHShoppingCartModel) {
        showHud(in: view)
        let paraDict = ["spid": (model.goods_id)!]
        _ = XHRequest.shareInstance.requestNetData(dataType: .addProductCollection, parameters: paraDict, failure: { [weak self] (errorType) in
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
                if sth is String {
                    if (sth as! String) != "商品已经被收藏！！！",  (sth as! String) !=  "请先登录" {
                        self?.showHint(in: (self?.view)!, hint: "收藏成功")
                    }else {
                        self?.showHint(in: (self?.view)!, hint: sth as! String)
                    }
                }
        })
    }


   
    // MARK:- ===== 界面相关 ======
    private func setupTableView() {
        
        emptyImgView.removeFromSuperview()
        emptyL.removeFromSuperview()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(-45)
        }
        
        tableView.register(UINib(nibName: "XHShoppingCartNormalCell", bundle: nil), forCellReuseIdentifier: reuseId_normal)
        tableView.register(UINib(nibName: "XHShoppingCartEdittingCell", bundle: nil), forCellReuseIdentifier: reuseId_editting)
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
        }
        
       
        // MARK:- 全选按钮点击事件回调
        bottomView.allSelectedButtonClickedClosure = { [weak self] sender in
            for model in (self?.dataSource)! {
                if sender.isSelected == true { // 全选
                    model.isSelected = true
                    self?.selectedModelsArr = (self?.dataSource)!
                }else { // 全不选
                    model.isSelected = false
                    self?.selectedModelsArr.removeAll()
                }
            }
            
            self?.tableView.reloadData()
        }
        
        // MARK:- 去结算按钮点击事件回调
        bottomView.goToSettleButtonClickedClosure = { [weak self] in
            let confirmV = XHConfirmOrderController()
            confirmV.ordersArr = (self?.selectedModelsArr)!
            confirmV.comeFrom = .shoppingCart
            
            if (self?.selectedModelsArr.count)! > 0 {
                self?.navigationController?.pushViewController(confirmV, animated: true)
            }else {
                self?.showHint(in: (self?.view)!, hint: "请选择您要结算的商品~")
            }
        }
    }
    
    // MARK:- 可选按钮被点击后，遍历选中模型数组，移除或添加相关模型
    fileprivate func removeOrAddModelToSelectedModelArray(_ shoppingCartModel: XHShoppingCartModel, _ sender: UIButton) {
        if sender.isSelected == true {
            self.selectedModelsArr.append(shoppingCartModel)
        }else {
            var index: Int = -1
            for idx in 0 ..< self.selectedModelsArr.count {
                let model = self.selectedModelsArr[idx]
                if model.id == shoppingCartModel.id {
                    index = idx
                }
            }
            if index != -1 {
                self.selectedModelsArr.remove(at: index)
            }
        }
    }
    
    // MARK:- 蒙版视图轻点手势事件
    @objc private func maskViewTapGesture() {
        UIView.animate(withDuration: 0.3, animations: {
            self.propertyView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 450)
        }) { (isFinished) in
            self.propertyView.removeFromSuperview()
            self.maskView.removeFromSuperview()
        }
    }
    
    // MARK:- == 手势事件的代理方法
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: propertyView) == true {
            return false
        }
        return true
    }
    
    @objc private func backBarButtonClicked() {
        if isCellEditting == true {
            XHAlertController.showAlert(title: "提示", message: "您的购物车还未保存，确定要离开吗？", Style: .alert, confirmTitle: "去意已决", confirmComplete: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:- ======== 界面相关 ===========
    // MARK:- 导航栏设置
    private func setupNav() {
        title = "购物车"
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        if dataSource.count == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }else {
            let rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editButtonClicked(_:)))
            rightItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x666666), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], for: .normal)
            navigationItem.rightBarButtonItem = rightItem
        }
        
        let backItem = UIBarButtonItem(image: UIImage(named: "Back Chevron"), style: .plain, target: self, action: #selector(backBarButtonClicked))
        navigationItem.leftBarButtonItem = backItem
    }
    
    /// MARK:- 空页面
    private func setupEmptyUI() {
        tableView.removeFromSuperview()
        view.addSubview(emptyImgView)
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topView.snp.bottom).offset(60)
            make.width.equalTo(123)
            make.height.equalTo(124)
        }
        
        view.addSubview(emptyL)
        emptyL.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(emptyImgView.snp.bottom).offset(20)
        }
    }
    
    // MARK:- ======== 懒加载 =========
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    /// 空页面
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "buycar_empty_image"))
    private lazy var emptyL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x666666)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "购物车空空荡荡，快去逛逛吧～"
        return label
    }()
    
    // 底部视图
    fileprivate lazy var bottomView: XHShoppingCartBottomView = Bundle.main.loadNibNamed("XHShoppingCartBottomView", owner: self, options: nil)?.last as! XHShoppingCartBottomView
    
    // 蒙版
    fileprivate lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = XHRgbaColorFromHex(rgb: 0x000000, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(maskViewTapGesture))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        return view
    }()
    
    // 属性视图
    fileprivate lazy var propertyView: XHConfirmOrderPropertyView = XHConfirmOrderPropertyView()
}

extension XHShoppingCartController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section]
        if isCellEditting == false {
            let cell: XHShoppingCartNormalCell = tableView.dequeueReusableCell(withIdentifier: reuseId_normal, for: indexPath) as! XHShoppingCartNormalCell
            cell.shoppingCartModol = model
            cell.selectedButtonClickedClosure = { [weak self] model, sender in
                /// 当tableView中任意一个不被选中，则底部视图中的全选按钮则不被选中
                if sender.isSelected == false { // 取消选中
                    self?.bottomView.isAllSelectedBtnSelected = false
                }
                // 遍历选中模型数组，移除或添加相关模型
                self?.removeOrAddModelToSelectedModelArray(model, sender)
            }
            
            // MARK:- 图片手势点击事件回调
            cell.iconViewClickGestureClosure = { [weak self] model in
                let goodsDetailV = XHGoodsDetailController()
                goodsDetailV.goodsId = model.goods_id
                self?.navigationController?.pushViewController(goodsDetailV, animated: true)
            }
            return cell
        }
        
        let cell: XHShoppingCartEdittingCell = tableView.dequeueReusableCell(withIdentifier: reuseId_editting, for: indexPath) as! XHShoppingCartEdittingCell
        cell.shoppingCartModel = model
        cell.goodsIdx = indexPath.section
        
        // MARK:- 图片点击事件
        cell.productIconClickedGestureClosure = { [weak self] model in
            let goodsDetailV = XHGoodsDetailController()
            goodsDetailV.goodsId = model.goods_id
            self?.navigationController?.pushViewController(goodsDetailV, animated: true)
        }
        
        // MARK:- 可选按钮点击事件回调
        cell.selectedButtonClickedClosure = { [weak self] shoppingCartModel, sender in
            /// 当tableView中任意一个不被选中，则底部视图中的全选按钮则不被选中
            if sender.isSelected == false {
                self?.bottomView.isAllSelectedBtnSelected = false
            }
            
            // 遍历选中模型数组，移除或添加相关模型
            self?.removeOrAddModelToSelectedModelArray(model, sender)
        }
        
        /// MARK:- 属性视图按钮点击手势事件回调
        cell.propertyViewClickedGestureClosure = { [weak self] shoppingCartModel in
            UIApplication.shared.keyWindow?.addSubview((self?.maskView)!)
            self?.maskView.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIApplication.shared.keyWindow!)
            })
            self?.propertyView.frame = CGRect(x: 0, y: KUIScreenHeight, width: kUIScreenWidth, height: 450)
            self?.maskView.addSubview((self?.propertyView)!)
            UIView.animate(withDuration: 0.3) {  [weak self] in
                self?.propertyView.frame = CGRect(x: 0, y: KUIScreenHeight - 450, width: kUIScreenWidth, height: 450 * KUIScreenHeight / 667)
            }
        }
        
        // MARK:- 删除事件回调
        cell.deleteButtonClickedClosure = { [weak self] model, index in
            
            XHAlertController.showAlert(title: "提示", message: "确定要删除吗？", Style: .actionSheet, confirmTitle: "确定", confirmComplete: {
                self?.dataSource.remove(at: index)
                tableView.reloadData()
                
                for idx in 0 ..< Int((self?.selectedModelsArr.count)!) {
                    let shoppingCartModel = self?.selectedModelsArr[idx]
                    if model.id == shoppingCartModel?.id {
                        self?.selectedModelsArr.remove(at: idx)
                    }
                }
                self?.showHint(in: (self?.view)!, hint: "删除成功")
            })
        }
        
        // MARK:- 收藏按钮回调
        cell.collectionButtonClickedClosure = { [weak self] shoppingCartModel in
            self?.collectedProduct(shoppingCartModel)
        }
        
        /// MARK: 商品数量编辑回调
        cell.productNumberEditClosure = { [weak self] in
            self?.selectedModelsArr = (self?.selectedModelsArr)!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
}
