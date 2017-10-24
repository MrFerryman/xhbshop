//
//  XHHotClassifyViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHotClassifyViewController: UIViewController, UISearchBarDelegate {

    var type_id: String? {
        didSet {
            setupUI()
            searchResultV.type_id = type_id
        }
    }
    
    fileprivate let viewName = "热门分类商品列表页"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        view.backgroundColor = .white
        setupUI()
        //点击空白处收回键盘 注册点击事件
        searchResultV.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 搜索框的代理方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultV.keyword = searchBar.text
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    private func setupNav() {
        
//        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navigationItem.backBarButtonItem = item
        
        searchBar.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
    }
    
    private func setupUI() {
        view.addSubview(searchResultV.view)
        searchResultV.view.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        searchResultV.goodsItemClickedClosure = { [weak self] model in
            let goodsV = XHGoodsDetailController()
            goodsV.goodsId = model.id
            self?.navigationController?.pushViewController(goodsV, animated: true)
        }
        
        searchResultV.collectionViewScrollClosure = { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
    }
    
    // MARK:- ===== 懒加载 ========
    private lazy var searchResultV: XHSearchResultController = XHSearchResultController()
    // 搜索框
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入商品或品牌关键字"
        bar.setSearchFieldBackgroundImage(UIImage(named: "searchBar_bg"), for: .normal)
        bar.delegate = self
        bar.showsCancelButton = false
        bar.backgroundColor = .clear
        bar.backgroundImage = UIImage()
        return bar
    }()

}
