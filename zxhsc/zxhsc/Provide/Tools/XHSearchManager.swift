//
//  XHSearchManager.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import PYSearch

class XHSearchManager: NSObject, PYSearchViewControllerDelegate {

    /// 搜索结果商品的点击事件
    var searchResultGoodsDetailItemClickedClosure: ((_ model: XHSpecialFavModel) -> ())?
    
    fileprivate var time: Int = 0
    fileprivate var targetVc: UIViewController?
    // 单例创建
    static let instance = XHSearchManager()
    private override init() {}
    
    func pushSearchViewController(targetVc: UIViewController?, placeholdStr: String, isAnimation: Bool, searchDidResult: PYDidSearchBlock?) {
        
        targetVc?.tabBarController?.tabBar.isHidden = true
        self.targetVc = targetVc
        
        let hotSearches = Array<String>()
        let searchVC = PYSearchViewController(hotSearches: hotSearches, searchBarPlaceholder: placeholdStr) { [weak self] (searchVc, searchBar, searchText) in
            
            searchVc?.delegate = self
            searchDidResult?(searchVc, searchBar, searchText)
            
            searchVc?.showHud(in: (searchVc?.view)!)
            searchVc?.hideHud()
            searchVc?.view.addSubview((self?.searchResultVc.view)!)
            self?.searchResultVc.view.snp.makeConstraints({ (make) in
                make.edges.equalTo((searchVc?.view)!)
            })
            self?.searchResultVc.reset()
            self?.searchResultVc.keyword = searchText
        }
        
        searchVC?.hotSearchStyle = .borderTag
        searchVC?.searchHistoryStyle = .borderTag
        targetVc?.navigationController?.pushViewController(searchVC!, animated: isAnimation)
        
        searchResultVc.goodsItemClickedClosure = { [weak self] model in
            
            self?.searchResultGoodsDetailItemClickedClosure?(model)
        }
    }
    
    // MARK:- 搜索代理方法
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        searchResultVc.view.removeFromSuperview()
        searchViewController.searchBar.text = ""
        searchViewController.searchBar.resignFirstResponder()
        time += 1
        if time == 2 {
            targetVc?.navigationController?.popViewController(animated: true)
        }
    }
    // MARK:- 懒加载
    // 搜索结果控制器
    private lazy var searchResultVc: XHSearchResultController = XHSearchResultController()
}
