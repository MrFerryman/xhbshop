//
//  XHRedPacketController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHRedPacketController: UIViewController {

    @IBOutlet weak var upImage_heightCon: NSLayoutConstraint!
    
    @IBOutlet weak var redHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var redWidthCon: NSLayoutConstraint!
    
    
    @IBOutlet weak var personalButton: UIButton!
    
    @IBOutlet weak var groupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        upImage_heightCon.constant =  320 * kUIScreenWidth / 375
        redWidthCon.constant = (kUIScreenWidth - 50) / 2
        redHeightCon.constant = (200 * (kUIScreenWidth - 50) / 2) / 160
        personalButton.adjustsImageWhenHighlighted = true
        
        setupNav()
    }

    // MARK:- 个人红包按钮点击事件
    @IBAction func personalRedPacketButtonDidClicked(_ sender: UIButton) {
        let personalRed = XHPostPersonalRedPackedsController()
        personalRed.isPersonalRedPacketes = true
        navigationController?.pushViewController(personalRed, animated: true)
    }
    
    // MARK:-群红包按钮点击事件
    @IBAction func groupRedPackedButtonDidClicked(_ sender: UIButton) {
        let personalRed = XHPostPersonalRedPackedsController()
        personalRed.isPersonalRedPacketes = false
        navigationController?.pushViewController(personalRed, animated: true)
    }
    
    // MARK:- 我的红包按钮点击事件
    @objc private func myRedPackedsButtonDidClicked() {
        let myRedP = XHMyRedPackectsController()
        navigationController?.pushViewController(myRedP, animated: true)
    }
    
    // MARK:- 设置导航栏
    private func setupNav() {
        title = "红包"
        
        let rightItem = UIBarButtonItem(title: "我的红包", style: .plain, target: self, action: #selector(myRedPackedsButtonDidClicked))
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0xea2000)], for: .normal)
        navigationItem.rightBarButtonItem = rightItem
    }

}
