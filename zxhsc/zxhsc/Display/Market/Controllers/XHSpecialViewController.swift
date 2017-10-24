//
//  XHSpecialViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHSpecialViewController: UIViewController {

    // MARK:- 私有属性
    fileprivate let collMargin: CGFloat = 7 // collectionView各个格子之间的间距
    fileprivate let collLRMargin: CGFloat = 12 // collectionView距离边界的距离
    fileprivate let reuseId = "XHSpecialViewController_collectionView_Reuse" // collectionView的cell的复用标志
    fileprivate let reuseId_reuseView = "XHSpecialViewController_collectionView_headerView" // collectionView的header的复用标志
    
    fileprivate let viewName = "精选推荐专区商品列表页"
    
    fileprivate var sessionModel: XHSessionModel = XHSessionModel()
    
    fileprivate var page: Int = 0
    /// 专场ID
    var sessionId: String? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RandomColor()
        
        // 设置导航栏
        setupNav()
        
        // 设置collectionView
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    private func loadData() {
        page += 1
        showHud(in: view)
        let paraDict = ["sub_id": sessionId!, "page": "\(page)"]
        _ = XHRequest.shareInstance.requestNetData(dataType: .getSessionData, parameters: paraDict, failure: { [weak self] (errorType) in
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
            if sth is XHSessionModel {
                let sessionModel = sth as! XHSessionModel
                self?.sessionModel.id = sessionModel.id
                self?.sessionModel.banner = sessionModel.banner
                self?.sessionModel.title = sessionModel.title
                self?.sessionModel.goodsArr.append(contentsOf: sessionModel.goodsArr)
                self?.setupCollectionView()
                self?.collectionView.reloadData()
                
                if self?.collectionView.mj_footer != nil {
                    if sessionModel.goodsArr.count == 0 {
                        self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self?.collectionView.mj_footer.endRefreshing()
                    }
                }
            }else {
                self?.showHint(in: (self?.view)!, hint: sth as! String)
            }
        })
    }
    
    // MARK:- 刷新页面
    @objc private func refresh() {
        loadData()
    }
    

    // MARK:- ======= 界面相关 ==========
    // MARK:- 布局collectionVIew
    private func setupCollectionView() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.bottom.equalTo(view)
        }
        
        collectionView.register(UINib(nibName: "XHSpecialCollViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        collectionView.register(XHspecialCollReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_reuseView)
        
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
        
        if sessionModel.banner != nil {
            layout.headerReferenceSize = CGSize(width: kUIScreenWidth, height: 165)
        }else {
            layout.headerReferenceSize = CGSize.zero
        }
    }
    // MARK:- 设置导航栏
    private func setupNav() {
        tabBarController?.tabBar.isHidden = true
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
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
}

extension XHSpecialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 有几个格子
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessionModel.goodsArr.count
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHSpecialCollViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! XHSpecialCollViewCell
        cell.sessionGoodsM = sessionModel.goodsArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = sessionModel.goodsArr[indexPath.row]
        let goodsDetailV = XHGoodsDetailController()
        goodsDetailV.goodsId = model.id
        navigationController?.pushViewController(goodsDetailV, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView: XHspecialCollReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseId_reuseView, for: indexPath) as! XHspecialCollReusableView
        headerView.imgName = sessionModel.banner
        return headerView
    }
}
