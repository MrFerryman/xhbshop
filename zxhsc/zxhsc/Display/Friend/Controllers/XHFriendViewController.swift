//
//  XHFriendViewController.swift
//  zxhsc
//
//  Created by 12345678 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import PYSearch

class XHFriendViewController: UIViewController, UISearchBarDelegate, PYSearchViewControllerDelegate {

    fileprivate let reuseId = "XHFriendViewController_tableViewCell_reuseId"
    fileprivate let reuseId_classes = "XHFriendViewController_tableViewCell_reuseId_classes"
    
    /// 第一组的展开与否
    fileprivate var firstSectionIsFlod: Bool = false
    
    fileprivate var classesArr: Array<XHFriendClassModel> = []
    
    fileprivate var shopsArr: Array<XHBussinessShopModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: friendCalssesPath) != nil {
            
            classesArr = NSKeyedUnarchiver.unarchiveObject(withFile:friendCalssesPath) as! Array<XHFriendClassModel>
        }
        
        if NSKeyedUnarchiver.unarchiveObject(withFile: friendRecommendPath) != nil {
            
            shopsArr = NSKeyedUnarchiver.unarchiveObject(withFile:friendRecommendPath) as! Array<XHBussinessShopModel>
        }

        view.backgroundColor = .white
        
        setupTableView()
        
        loadClassesList()
        loadRecommendShopList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    // MARK:- 搜索事件
    @objc private func searchDidStart() {
        
    }
    
    // MARK:- 搜索框的代理方法
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        let hotSearches = Array<String>()
        let searchV = PYSearchViewController(hotSearches: hotSearches, searchBarPlaceholder: "店铺名称/分类名称") { [weak self] (searchVc, searchBar, searchText) in
            searchVc?.delegate = self
            if searchText != nil {
                self?.searchResultVc.searchKey = searchText
                searchVc?.view.addSubview((self?.searchResultVc.view)!)
                self?.searchResultVc.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo((searchVc?.view)!)
                })
                
                searchVc?.cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
                
                self?.searchResultVc.jumpToNextViewClosure = { model in
                    let shopVc = XHBussinessShopController()
                    shopVc.shopId = model.shopId
                    searchBar?.resignFirstResponder()
                    self?.searchBar.resignFirstResponder()
                    self?.navigationController?.pushViewController(shopVc, animated: true)
                }
            }
        }
        
        searchV?.hotSearchStyle = .borderTag
        searchV?.searchHistoryStyle = .borderTag
        navigationController?.pushViewController(searchV!, animated: false)
        return true
    }

    // MARK:- 搜索代理方法
    func didClickCancel(_ searchViewController: PYSearchViewController!) {
        searchResultVc.view.removeFromSuperview()
        searchViewController.searchBar.text = ""
        searchViewController.searchBar.resignFirstResponder()
    }

    
    // MARK:- ======= 事件相关 =========
    // MARK:- 地图按钮点击事件
    @objc private func mapButtonItemClicked() {
        let locationVc = XHLocationViewController()
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(locationVc, animated: true)
    }
    
    // MARK:- 请求分类列表
    private func loadClassesList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getFriendClassesList, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.loadClassesList()
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHFriendClassModel] {
                self?.classesArr = sth as! [XHFriendClassModel]
                self?.tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    // MARK:-  请求推荐商铺列表
    private func loadRecommendShopList() {
        showHud(in: view)
        let paraDict = ["page": "0", "cateid": "0"]
        _ = XHRequest.shareInstance.requestNetData(dataType: .getRecommandShopList, parameters: paraDict, failure: { [weak self] (errorType) in
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
            if sth is [XHBussinessShopModel] {
                self?.shopsArr = sth as! [XHBussinessShopModel]
                self?.tableView.reloadData()
            }
        })
    }
    
    /// MARK:- ====== 界面相关 ========
    /// 设置导航栏
    private func setupNav() {
        navigationItem.titleView = searchBar
    }
    
    /// 设置tableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(XHFriendFirstSectionCell.self, forCellReuseIdentifier: reuseId_classes)
        tableView.register(UINib(nibName: "XHRecommendViewCell", bundle: nil), forCellReuseIdentifier: reuseId)

    }
    
    fileprivate func setupChildViewController() {
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0x333333)]
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK:- ====== 懒加载 =========
    /// tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()
    
    /// 搜索框
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入店铺名称"
        bar.setSearchFieldBackgroundImage(UIImage(named: "searchBar_bg"), for: .normal)
        bar.delegate = self
        bar.showsCancelButton = true
        bar.backgroundColor = .clear
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private lazy var searchResultVc: XHShopClassController = XHShopClassController()
}

extension XHFriendViewController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return shopsArr.count
        }
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHFriendFirstSectionCell = tableView.dequeueReusableCell(withIdentifier: reuseId_classes, for: indexPath) as! XHFriendFirstSectionCell
            
            cell.classesArr = classesArr
            
            // 类型item的点击回调
            cell.collectionViewItemClickedClosure = { [weak self] model in
                let classV = XHShopClassController()
                self?.setupChildViewController()
                classV.title = model.cl_title
                classV.classId = model.cl_id
                self?.navigationController?.pushViewController(classV, animated: true)
            }
            
            cell.rotateButtonClosure = { [weak self] in
                if self?.firstSectionIsFlod == true {
                    // 展开
                    self?.firstSectionIsFlod = false
                    tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                    cell.isOpen = false
                }else {
                    self?.firstSectionIsFlod = true
                    tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                    cell.isOpen = true
                }
            }
            
            return cell
        }
        
        let cell: XHRecommendViewCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHRecommendViewCell
        cell.shopModel = shopsArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = shopsArr[indexPath.row]
            let shopVc = XHBussinessShopController()
            shopVc.shopId = model.shopId
            setupChildViewController()
            navigationController?.pushViewController(shopVc, animated: true)
        }
    }
    
    // 组视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView()
            headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 38)
            headerView.backgroundColor = .white
            let imgView = UIImageView(image: UIImage(named: "coalition_recommend"))
            headerView.addSubview(imgView)
            imgView.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerView)
                make.left.equalTo(16)
                make.width.equalTo(15)
                make.height.equalTo(14)
            })
            
            let sectionTitleL = UILabel()
            sectionTitleL.text = "推荐商家"
            sectionTitleL.textColor = XHRgbColorFromHex(rgb: 0x333333)
            sectionTitleL.font = UIFont.systemFont(ofSize: 14)
            
            headerView.addSubview(sectionTitleL)
            sectionTitleL.snp.makeConstraints({ (make) in
                make.centerY.equalTo(headerView)
                make.left.equalTo(imgView.snp.right).offset(5)
            })

            let line = UIView()
            line.backgroundColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1.0)
            headerView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.bottom.right.equalTo(headerView)
                make.height.equalTo(1)
            })
            return headerView
        }
        
        return nil
    }
    
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if firstSectionIsFlod == false {
                return 190
                
            }else {
                return CGFloat(((classesArr.count) % 4 == 0 ? (classesArr.count) / 4 : (classesArr.count / 4 + 1)) * 79 + 32)
            }
        default:
            return 114
        }
    }
    
    // 组的头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 38
        }
        return 0.01
    }
    
    // 组的尾部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
