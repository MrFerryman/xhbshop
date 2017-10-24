//
//  XHIntegralController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MJRefresh

class XHIntegralController: UIViewController {

    /// 格子之间的间距
    fileprivate let collMargin: CGFloat = 7
    /// 左右间距
    fileprivate let collLRMargin: CGFloat = 12
    fileprivate let reuseID = "XHIntegralController_reuseiD"
    fileprivate var page: Int = 0
    
    fileprivate var listArr: [XHIntegralGoodsModel] = []
    fileprivate let viewName = "积分商城页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupCollectionView()
        
        loadData()
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
        let paraDict = ["page": "\(page)"]
        XHIntegralShopViewModel.getIntegralShopList(paraDict: paraDict, self) { [weak self] (integralList) in
            self?.listArr.append(contentsOf: integralList )
            self?.collectionView.reloadData()
            if self?.collectionView.mj_footer != nil {
                if integralList.count == 0 {
                    self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    self?.collectionView.mj_footer.endRefreshing()
                }
            }
        }
    }
    
    @objc private func refresh() {
        loadData()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        collectionView.register(UINib(nibName: "XHIntegralCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseID)
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refresh))
    }
    
    private func setupNav() {
        title = "积分商城"
    }

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = self.collMargin
        layout.minimumLineSpacing = self.collMargin
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(self.collLRMargin, self.collLRMargin, 0, self.collLRMargin)
        
        let width = (kUIScreenWidth - self.collLRMargin * 2 - self.collMargin) / 2
        let height = width + 48.0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        view.delegate = self
        view.dataSource = self
        return view
    }()

}

extension XHIntegralController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHIntegralCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! XHIntegralCollectionCell
        cell.integralModel = listArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listArr[indexPath.row]
        let goodsDetail = XHGoodsDetailController()
        goodsDetail.isIntegral = true
        goodsDetail.goodsId = model.id
        navigationController?.pushViewController(goodsDetail, animated: true)
    }
}
