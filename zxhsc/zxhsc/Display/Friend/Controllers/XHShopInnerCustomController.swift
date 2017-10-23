//
//  XHShopInnerCustomController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopInnerCustomController: UIViewController {

    var shopModel: XHShopDetailModel?
    
    fileprivate let reuseId = "XHShopInnerCustomController_reuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "店内消费"
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        
        tableView.tableFooterView = footerView
        footerView.shopModel = shopModel
        footerView.confirmButtonClickedClosure = { [weak self] money in
            let paraDict = ["sellid": (self?.shopModel?.id)!, "bili": "\((self?.shopModel?.scale)!)", "xiaofeijine": money]
            XHGoodsDetailViewModel.shopInnerCustom(paraDict: paraDict, self!, dataClosure: { (result) in
                let number = NSString(string: result).integerValue
                if number != 0 {
                    let style = XHFukuanStyleController()
                    let model = XHShoppingCartModel()
                    model.price = money
                    model.buyCount = "1"
                    style.comeFrom = .shopping_pay
                    style.orderId = result
                    style.shoppingCartList = [model]
                    self?.navigationController?.pushViewController(style, animated: true)
                }else {
                    XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
                }
            })
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return tableView
    }()

    private lazy var footerView: XHShopInnerFooterView = XHShopInnerFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 300))
}

extension XHShopInnerCustomController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell
    }
}
