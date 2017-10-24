//
//  XHShopUpgradeController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ALCameraViewController

class XHShopUpgradeController: UIViewController, ZLPhotoPickerViewControllerDelegate {

    @IBOutlet weak var idImageView: UIView! // 执照视图
    
    @IBOutlet weak var iconView: UIImageView! // 执照图片
    
    @IBOutlet weak var shopNameTF: UITextField! // 店铺名称输入框
    
    @IBOutlet weak var textView: ZYPlaceHolderTextView! // 文字输入视图
    
    @IBOutlet weak var confirmButton: UIButton! // 提交按钮
    
    @IBOutlet weak var imagesView: UIView!
    
    @IBOutlet weak var detailL: UILabel!
    
    fileprivate let viewName = "店铺升级设置页"
    
    /// 执照照片
    private var licenseImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "店铺升级"
        textView.placeholder = "店铺描述"
        confirmButton.layer.cornerRadius = 6
        confirmButton.layer.masksToBounds = true
        
        // 给上传营业执照视图添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(idImageViewTapGesture))
        idImageView.addGestureRecognizer(tap)
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        setupImageView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 上传营业执照视图手势事件
    @objc private func idImageViewTapGesture() {
        selectImagesClicked()
    }
    
    // MARK:- 提交审核按钮点击事件
    @IBAction func commitButtonClicked(_ sender: UIButton) {
        if judge() == true {
            showHint(in: view, hint: "升级成功！")
        }
    }
    
    
    private func setupImageView() {
        imagesView.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(imagesView)
            make.top.equalTo(8)
        }
        
        /// 添加图片点击事件回调
        footerView.addImagesCellClickedClosure = { [weak self] imagesArr in
//            self?.footerViewAddImages(imagesArr: imagesArr)
        }
        
        /// 图片点击事件回调
        footerView.imagesViewClickedClosure = { [weak self] images, index in
            
        }
        
        /// 关闭按钮点击事件回调
        footerView.closeButtonClickedClosure = { [weak self] index in
//            self?.footerView.imagesArr.remove(at: index)
//            self?.footerView.reloadCollectionView()
        }
    }
    
    // MARK:- 选择图片
    fileprivate func selectImagesClicked() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camaraA = UIAlertAction(title: "拍照", style: .default) { (action) in
            let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
                if image != nil {
                    self?.iconView.image = image
                    self?.licenseImg = image
                }
                self?.dismiss(animated: true, completion: {})
            }
            
            self.present(cameraViewController, animated: true, completion: nil)
        }
        alertVC.addAction(camaraA)
        
        let albumA = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: true) { [weak self] image, asset in
                if image != nil {
                    self?.iconView.image = image
                    self?.licenseImg = image
                }
                self?.dismiss(animated: true, completion: {
                })
            }
            
            self.present(libraryViewController, animated: true, completion: nil)
        }
        alertVC.addAction(albumA)
        
        let cancelA = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelA)
        
        self.present(alertVC, animated: true, completion: nil)
    }

    
    
    // MARK:- 底部视图中添加图片的方法
    fileprivate func footerViewAddImages(imagesArr: [UIImage]) {
        let pickerV = ZLPhotoPickerViewController()
        // 默认显示相册里面的内容SavePhotos
        pickerV.status = .cameraRoll
        pickerV.selectPickers = imagesArr
        pickerV.isShowCamera = true
        pickerV.topShowPhotoPicker = true
        // 选择图片的最小数
        pickerV.maxCount = 3 - imagesArr.count
        pickerV.showPickerVc(self)
        pickerV.delegate = self
    }

    func pickerViewControllerDoneAsstes(_ assets: [Any]!) {
        for asset in assets {
//            footerView.imagesArr.append((asset as AnyObject).thumbImage)
            footerView.reloadCollectionView()
        }
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            shopNameTF.resignFirstResponder()
            textView.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    // MARK:- 信息提交前的简单逻辑判断
    private func judge() -> Bool {
        if licenseImg == nil {
            showHint(in: view, hint: "营业执照不能为空~")
            return false
        }
        
        if shopNameTF.text?.isEmpty == true {
            showHint(in: view, hint: "店铺名称不能为空~")
            return false
        }
        
        return true
    }
    
    /// footerView
    private lazy var footerView: XHShopSetting_inStoreView = Bundle.main.loadNibNamed("XHShopSetting_inStoreView", owner: self, options: nil)?.last as! XHShopSetting_inStoreView
}
