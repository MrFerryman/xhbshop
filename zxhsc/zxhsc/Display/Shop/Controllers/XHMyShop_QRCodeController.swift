//
//  XHMyShop_QRCodeController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyShop_QRCodeController: UIViewController {

    fileprivate let reuseId_qrCoder = "XHMyShop_QRCodeController_qrCoder"
    fileprivate let reuseId_detail = "XHMyShop_QRCodeController_detail"
    
    fileprivate let viewName = "店铺二维码页"
    
    fileprivate var shopModel: XHMyShop_settingModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
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
        XHShopSettingViewModel.getShop_setting_info(self) { [weak self] (result) in
            if result is XHMyShop_settingModel {
                self?.shopModel = result as? XHMyShop_settingModel
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 保存按钮点击事件
    @objc private func saveButtonClicked() {
        savePhotoToLibrary()
    }
    
    // 保存图片到相册
    private func savePhotoToLibrary() {
        let image = captureImage(fromView: self.view)
        
        let library = ALAssetsLibrary()
        let data = UIImageJPEGRepresentation(image, 1.0)
        library.writeImage(toSavedPhotosAlbum: UIImage(data: data!)?.cgImage, metadata: nil) { [weak self] (url, error) in
            if error == nil {
                self?.qrcodeImgView.image = image
                UIApplication.shared.keyWindow?.addSubview((self?.qrcodeImgView)!)
                self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth / 4, y: KUIScreenHeight / 4), size: CGSize(width:  0, height: 0))
                UIView.animate(withDuration: 0.3, animations: {
                    self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth / 4, y: KUIScreenHeight / 4), size: CGSize(width:  kUIScreenWidth / 2, height: KUIScreenHeight / 2))
                })
                
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    UIView.animate(withDuration: 1.0, animations: {
                        self?.qrcodeImgView.frame = CGRect(origin: CGPoint(x: kUIScreenWidth - 40, y: 32), size: CGSize.zero)
                    }, completion: { (finished) in
                        self?.qrcodeImgView.removeFromSuperview()
                        let alertView: UIAlertView = UIAlertView(title: "提示", message: "截取屏幕成功，请到相册查看", delegate: nil, cancelButtonTitle: "确定")
                        alertView.show()
                    })
                }
            }else {
                let alertView: UIAlertView = UIAlertView(title: "截取屏幕失败", message: nil, delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
    
    // 截图功能
    private func captureImage(fromView view: UIView) -> UIImage {
        let screenRect = view.bounds
        UIGraphicsBeginImageContextWithOptions(screenRect.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        view.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK:- 界面相关
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "XHMyShop_QRCoderImageCell", bundle: nil), forCellReuseIdentifier: reuseId_qrCoder)
        tableView.register(UINib(nibName: "XHMyShop_QRCoderDetailCell", bundle: nil), forCellReuseIdentifier: reuseId_detail)
    }
    
    
    private func setupNav() {
        title = "店铺二维码"
        let rightItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonClicked))
        rightItem.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0xea2000)], for: .normal)
        navigationItem.rightBarButtonItem = rightItem
    }

    // MARK:- ====== 懒加载 ============
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedRowHeight = 80
        return tableView
    }()
    
    private lazy var qrcodeImgView: UIImageView = UIImageView()
}

extension XHMyShop_QRCodeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: XHMyShop_QRCoderImageCell = tableView.dequeueReusableCell(withIdentifier: reuseId_qrCoder, for: indexPath) as! XHMyShop_QRCoderImageCell
            cell.shopModel = shopModel
            return cell
        }
        let cell: XHMyShop_QRCoderDetailCell = tableView.dequeueReusableCell(withIdentifier: reuseId_detail, for: indexPath) as! XHMyShop_QRCoderDetailCell
        cell.shopModel = shopModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
}
