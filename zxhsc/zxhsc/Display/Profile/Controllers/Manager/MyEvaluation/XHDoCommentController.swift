//
//  XHDoCommentController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/3.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHDoCommentController: UIViewController, ZLPhotoPickerViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var productIconView: UIImageView! // 产品图片
    
    @IBOutlet weak var productNameL: UILabel! // 产品名称
    
    @IBOutlet weak var wordNumL: UILabel!
    
    
    @IBOutlet weak var commentTextView: ZYPlaceHolderTextView! // 评论输入框
    
    @IBOutlet weak var imagesView: UIView! // 上传图片视图
    
    @IBOutlet weak var goodButton: UIButton! // 好评按钮
    
    @IBOutlet weak var mediumButton: UIButton! // 中评按钮
    
    @IBOutlet weak var badButton: UIButton! // 差评按钮
    
    @IBOutlet weak var commitButton: UIButton! //提交按钮
    
    /// 当前选中的评论按钮 默认是好评 1001-- 好评      1002 -- 中评  1003 -- 差评
    private var currentButtonTag: Int = 1001
    
    fileprivate let viewName = "做出评价页面"
    
    /// 上传的图片数组
    private var iconUrlsArr: [String] = []
    
    @IBOutlet weak var topCon: NSLayoutConstraint!
    /// 评价模型
    var model: XHMyValuationModel? {
        didSet {
            getOrderDetail()
        }
    }
    fileprivate var orderModel: XHMyOrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if model?.pro_icon != nil {
            productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (model?.pro_icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
        }
        
        productNameL.text = model?.pro_name
        commentTextView.delegate = self
        
        if KUIScreenHeight == 812 {
            topCon.constant = 90
        }else {
            topCon.constant = 64
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- 上传评论
    private func uploadCommend() {
        if orderModel?.orderNum == nil {self.showHint(in: view, hint: "信息不完整，请重新尝试~")}
        var state: String = "1"
        switch currentButtonTag {
        case 1001:
            state = "1"
        case 1002:
            state = "2"
        case 1003:
            state = "3"
        default:
            break
        }
        
        var paraDict = ["dingdanhao": (orderModel?.orderNum)!, "spid": (model?.order_id)!, "content": commentTextView.text!, "state": state]
        if iconUrlsArr.count != 0 {
            paraDict["pic"] = "\(iconUrlsArr)"
        }
        XHMyOrderViewModel.commitMyValuation(paraDict: paraDict, self) { [weak self] (result) in
            self?.showHint(in: (self?.view)!, hint: "\(result)")
            if (result as? String) == "评论提交成功" {
                let time: TimeInterval = 0.3
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK:- 获取订单详情
    private func getOrderDetail() {
        let paraDict = ["orderid": (model?.order_id)!]
        XHMyOrderViewModel.getMyOrderDetail(paraDict: paraDict, self) { (result) in
            if result is XHMyOrderModel {
                self.orderModel = result as? XHMyOrderModel
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let length = NSString(string: commentTextView.text).length
        wordNumL.text = "\(length)" + "/100"
        if length > 100 {
            wordNumL.textColor = .red
            XHAlertController.showAlertSigleAction(title: "提示", message: "评论文字需要在100字以内，请稍作修改！", confirmTitle: "确定", confirmComplete: nil)
        }else {
            wordNumL.textColor = .rgbColorFromHex(rgb: 0xcccccc)
        }
    }
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - image: 要上传的图片
    ///   - type: 0 - 店铺营业执照 1 - 店铺logo 2 - 店内详情图片
    private func uploadPicture(image: UIImage, type: String) {
        XHProfileViewModel.uploadImage(image: image, target: self, success: { [weak self] (imageName) in
           self?.iconUrlsArr.append(imageName)
            self?.collectionView.iconUrlsArr = (self?.iconUrlsArr)!
        }) { (error) in
            XHAlertController.showAlertSigleAction(title: "提示", message: error.localizedDescription, confirmTitle: "确定", confirmComplete: nil)
        }
    }
    
    @IBAction func goodButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentButtonTag = 1001
        
        mediumButton.isSelected = false
        badButton.isSelected = false
    }

    @IBAction func mediumButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentButtonTag = 1002
        
        goodButton.isSelected = false
        badButton.isSelected = false
    }
    
    @IBAction func badButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentButtonTag = 1003
        
        mediumButton.isSelected = false
        goodButton.isSelected = false
    }
    
    
    @IBAction func commitButtonClicked(_ sender: UIButton) {
        if judge() == true {
            uploadCommend()
        }
    }

    private func setupUI() {
        goodButton.isSelected = true
        commitButton.layer.cornerRadius = 6
        commitButton.layer.masksToBounds = true
        
        commentTextView.placeholder = "请填写你对商品的评价，多说说您的使用感受，分享给想购买的伙伴吧"
        commentTextView.font = UIFont.systemFont(ofSize: 12)
        commentTextView.placeholderColor = XHRgbColorFromHex(rgb: 0xaaaaaa)
        
        title = "订单评价"
        
        imagesView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(imagesView)
        }
        
        collectionView.limitPagesNum = 3
        collectionView.isScrollEnabled = true
        
        /// 添加图片点击事件回调
        collectionView.addImagesCellClickedClosure = { [weak self] imagesArr in
            self?.footerViewAddImages(imagesArr: imagesArr)
        }
        
        /// 图片点击事件回调
        collectionView.imagesViewClickedClosure = { [weak self] images, index in
            
        }
        
        /// 关闭按钮点击事件回调
        collectionView.closeButtonClickedClosure = { [weak self] index in
            self?.iconUrlsArr.remove(at: index)
            self?.collectionView.iconUrlsArr = (self?.iconUrlsArr)!
        }
    }
    
    // MARK:- 底部视图中添加图片的方法
    fileprivate func footerViewAddImages(imagesArr: [String]) {
        let pickerV = ZLPhotoPickerViewController()
        // 默认显示相册里面的内容SavePhotos
        pickerV.status = .cameraRoll
        //        pickerV.selectPickers = imagesArr
        pickerV.isShowCamera = true
        pickerV.topShowPhotoPicker = true
        // 选择图片的最大数
        pickerV.maxCount = 3 - imagesArr.count
        
        pickerV.showPickerVc(self)
        pickerV.delegate = self
    }
    
    func pickerViewControllerDoneAsstes(_ assets: [Any]!) {
        for asset in assets {
            uploadPicture(image: (asset as AnyObject).thumbImage, type: "2")
        }
    }
    
    private func judge() -> Bool {
        if commentTextView.text.isEmpty == true {
            showHint(in: view, hint: "评价文字不能为空的哟~")
            return false
        }
        return true
    }

    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        layout.itemSize = CGSize(width: 70, height: 70)
        return layout
    }()
    
    private lazy var collectionView: XHSelectImagesCollView = {
        let collectionView: XHSelectImagesCollView = XHSelectImagesCollView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = true
        return collectionView
    }()
}
