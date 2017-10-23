//
//  XHShopSettingController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ALCameraViewController

class XHShopSettingController: UIViewController,  ZLPhotoPickerViewControllerDelegate {

    fileprivate let reuseId = "XHShopSettingController_reuseId"
    fileprivate let reuseId_image = "XHShopSettingController_reuseId_image"
    
    fileprivate let dataArr = XHShopSettingViewModel().dataSourceArr
    fileprivate var settingModel: XHMyShop_settingModel?
    fileprivate var classListArr: Array<String> = []
    fileprivate var classArr: Array<XHFriendClassModel> = []
    /// 行业类型
    fileprivate var shopClass_Model: XHFriendClassModel?
    /// 营业执照URL
    fileprivate var licenseUrl: String?
    /// 店铺logoURL
    fileprivate var logoURL: String?
    /// 店铺详情图片数组
    fileprivate var shopIconsArr: Array<String> = []
    
    
    /// 是否是开通店铺2
    var isOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNav()
        
        loadData()
        
        setupTableView()
        
        getShopClassesList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK:- 请求店铺信息
    private func loadData() {
        if isOpen { return }
        
        XHShopSettingViewModel.getShop_setting_info(self) { [weak self] (result) in
            if result is XHMyShop_settingModel {
                let model = result as! XHMyShop_settingModel
                self?.settingModel = model
                self?.dataArr?[0].content?[0].subTitle = model.name
                self?.dataArr?[0].content?[1].subTitle = model.city
                self?.dataArr?[0].content?[2].subTitle = model.detailAddress
                self?.dataArr?[0].content?[4].subTitle = model.scale
                self?.dataArr?[0].content?[5].subTitle = model.mainBusy
                self?.dataArr?[0].content?[6].iconUrlStr = model.license
                self?.dataArr?[1].content?[0].iconUrlStr = model.logo
                self?.dataArr?[1].content?[1].subTitle = model.phoneNum
                self?.dataArr?[1].content?[2].subTitle = model.busyTime
                self?.dataArr?[1].content?[3].subTitle = model.description
                var urlArr: [String] = []
                for url in model.shop_icons_Arr {
                    var urlStr = url.replacingOccurrences(of: "[", with: "")
                    urlStr = urlStr.replacingOccurrences(of: "]", with: "")
                    let whitespace = NSCharacterSet.whitespacesAndNewlines
                    urlStr = urlStr.trimmingCharacters(in: whitespace)
                    urlStr = urlStr.replacingOccurrences(of: "\"", with: "")
                    urlArr.append(urlStr)
                }
                self?.footerView.iconUrlsArr = urlArr
                self?.tableView.reloadData()
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 请求店铺分类列表
    fileprivate func getShopClassesList() {
        XHShopSettingViewModel.getShop_setting_classList(self) { [weak self] (result) in
            if result is [XHFriendClassModel] {
                self?.classListArr.removeAll()
                self?.classArr = result as! [XHFriendClassModel]
                for model in (result as! [XHFriendClassModel]) {
                    self?.classListArr.append(model.cl_title!)
                    if model.cl_id == self?.settingModel?.class_id {
                        self?.dataArr?[0].content?[3].subTitle = model.cl_title
                        self?.shopClass_Model = model
                        self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                    }
                }
            }
        }
    }
    
    // MARK:- 保存设置
    fileprivate func saveSetting() {
        
        if judge() == true {
            let type = settingModel?.shop_status
            var paraDict = ["type": (type ?? "1")]
            paraDict["name"] = dataArr?[0].content?[0].subTitle ?? ""
            paraDict["quyu"] = dataArr?[0].content?[1].subTitle ?? ""
            paraDict["address"] = dataArr?[0].content?[2].subTitle ?? ""
            paraDict["flid"] = shopClass_Model?.cl_id ?? ""
            paraDict["bili"] = dataArr?[0].content?[4].subTitle ?? ""
            paraDict["zhuying"] = dataArr?[0].content?[5].subTitle ?? ""
            paraDict["zhizhiurl"] = licenseUrl ?? (settingModel?.license ?? "")
            paraDict["logourl"] = logoURL ?? (settingModel?.logo ?? "")
            paraDict["tel"] = dataArr?[1].content?[1].subTitle ?? ""
            paraDict["yysj"] = dataArr?[1].content?[2].subTitle ?? ""
            paraDict["jianjie"] = dataArr?[1].content?[3].subTitle ?? ""
            paraDict["shop_id"] = settingModel?.id ?? "0"
            if footerView.iconUrlsArr.count != 0 || settingModel?.shop_icons_Arr.count != 0 {
                paraDict["pic"] = String(describing: footerView.iconUrlsArr.count == 0 ? settingModel?.shop_icons_Arr : footerView.iconUrlsArr)
            }
            XHShopSettingViewModel.openShopInfo(paraDict, self, dataArrClosure: { (result) in
                XHAlertController.showAlertSigleAction(title: "提示", message: result as? String, confirmTitle: "确定", confirmComplete: {
                    if (result as! String) == "资料设置成功" {
                        let time: TimeInterval = 0.5
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                })
            })
        }
    }
    
    // MARK:- 对行业类型
    fileprivate func classType(title: String) {
        for classModel in classArr {
            if classModel.cl_title == title {
                self.shopClass_Model = classModel
            }
        }
    }
    
    private func judge() -> Bool {
        if self.dataArr?[0].content?[0].subTitle?.isEmpty == true {
            showHint(in: view, hint: "请输入正确的店铺名称~")
            return false
        }
        
        if self.dataArr?[0].content?[1].subTitle?.isEmpty == true {
            showHint(in: view, hint: "请输入正确的店铺区域~")
            return false
        }
        
        if self.dataArr?[0].content?[2].subTitle?.isEmpty == true {
            showHint(in: view, hint: "请输入正确的店铺详细地址~")
            return false
        }
        
        if shopClass_Model == nil {
            showHint(in: view, hint: "请选择正确的行业类型~")
            return false
        }
        
        if self.dataArr?[0].content?[4].subTitle?.isEmpty == true {
            showHint(in: view, hint: "请输入正确让利比例~")
            return false
        }

        if self.dataArr?[0].content?[5].subTitle?.isEmpty == true {
            showHint(in: view, hint: "请输入主营业务~")
            return false
        }
        
        if licenseUrl?.isEmpty == true {
            showHint(in: view, hint: "请上传正确的营业执照~")
            return false
        }
        return true
    }
    
    // MARK:- ======= 事件相关 ========
    /// 上传图片
    ///
    /// - Parameters:
    ///   - image: 要上传的图片
    ///   - type: 0 - 店铺营业执照 1 - 店铺logo 2 - 店内详情图片
    private func uploadPicture(image: UIImage, type: String) {
        XHProfileViewModel.uploadImage(image: image, target: self, success: { [weak self] (imageName) in
            switch type {
            case "0": // 店铺营业执照
                self?.licenseUrl = imageName
                self?.dataArr?[0].content?[6].iconUrlStr = imageName
            case "1": // 店铺logo
                self?.logoURL = imageName
                self?.dataArr?[1].content?[0].iconUrlStr = imageName
            case "2": // 店内详情图片
                self?.shopIconsArr.append(imageName)
                self?.footerView.iconUrlsArr.append(imageName)
            default:
                break
            }
            self?.tableView.reloadData()
        }) { (error) in
            XHAlertController.showAlertSigleAction(title: "提示", message: error.localizedDescription, confirmTitle: "确定", confirmComplete: nil)
        }
    }
    
    
    // MARK:- 保存按钮点击事件
    @objc private func saveButtonClicked() {
        saveSetting()
    }
    
    // MARK:- 选择图片
    fileprivate func selectImagesClicked(_ model: XHShopSettingDetailModel, type: String) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camaraA = UIAlertAction(title: "拍照", style: .default) { (action) in
            let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
                if image != nil {
                    model.icon = image
                    self?.uploadPicture(image: image!, type: type)
                }
                self?.dismiss(animated: true, completion: {
                    self?.tableView.reloadData()
                })
            }
            
            self.present(cameraViewController, animated: true, completion: nil)
        }
        alertVC.addAction(camaraA)
        
        let albumA = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: true) { [weak self] image, asset in
                if image != nil {
                    model.icon = image
                    self?.uploadPicture(image: image!, type: type)
                }
                self?.dismiss(animated: true, completion: {
                    self?.tableView.reloadData()
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
    fileprivate func footerViewAddImages(imagesArr: [String]) {
        let pickerV = ZLPhotoPickerViewController()
        // 默认显示相册里面的内容SavePhotos
        pickerV.status = .cameraRoll
//        pickerV.selectPickers = imagesArr
        pickerV.isShowCamera = true
        pickerV.topShowPhotoPicker = true
        // 选择图片的最大数
        pickerV.maxCount = 9 - imagesArr.count
        
        pickerV.showPickerVc(self)
        pickerV.delegate = self
    }
    
    func pickerViewControllerDoneAsstes(_ assets: [Any]!) {
        for asset in assets {
            uploadPicture(image: (asset as AnyObject).thumbImage, type: "2")
        }
    }
    
    // MARK:- ======== 界面相关 ========
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
        
        tableView.register(UINib(nibName: "XHShopSettingCell", bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "XHShopSettingImageCell", bundle: nil), forCellReuseIdentifier: reuseId_image)
        
        footerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 150)
        tableView.tableFooterView = footerView
        
        /// 添加图片点击事件回调
        footerView.addImagesCellClickedClosure = { [weak self] imagesArr in
            self?.footerViewAddImages(imagesArr: imagesArr)
        }
        
        /// 图片点击事件回调
        footerView.imagesViewClickedClosure = { [weak self] images, index in
            
        }
        
        /// 关闭按钮点击事件回调
        footerView.closeButtonClickedClosure = { [weak self] index in
            self?.footerView.iconUrlsArr.remove(at: index)
            self?.tableView.reloadData()
        }
    }
    
    private func setupNav() {
        title = "店铺设置"
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        let rightItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonClicked))
        rightItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: XHRgbColorFromHex(rgb: 0xea2000), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        navigationItem.rightBarButtonItem = rightItem
    }
    
    // 懒加载
    // tableView
    private lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView
    }()

    /// footerView
    private lazy var footerView: XHShopSetting_inStoreView = Bundle.main.loadNibNamed("XHShopSetting_inStoreView", owner: self, options: nil)?.last as! XHShopSetting_inStoreView
}

extension XHShopSettingController: UITableViewDelegate, UITableViewDataSource {
    // 有几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return (dataArr?.count)!
    }
    
    // 有几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataArr?[section]
        return (model?.content?.count)!
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr?[indexPath.section]
        let settingModel = model?.content?[indexPath.row]
        if settingModel?.style == 2 {
            let cell: XHShopSettingImageCell = tableView.dequeueReusableCell(withIdentifier: reuseId_image, for: indexPath) as! XHShopSettingImageCell
            cell.shopSettingModel = settingModel
            return cell
        }
        let cell: XHShopSettingCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHShopSettingCell
        cell.shopSettingModel = settingModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr?[indexPath.section]
        let settingModel = model?.content?[indexPath.row]
        if settingModel?.style == 2 {
            var type: String = "0"
            if indexPath.section == 0 {
                type = "0"
            }else if indexPath.section == 1 {
                type = "1"
            }
            selectImagesClicked(settingModel!, type: type)
        }else if settingModel?.style == 0 {
            let settingV = XHShopSettingDetailController()
            navigationController?.pushViewController(settingV, animated: true)
            settingV.shopSettingModel = settingModel
            settingV.saveButtonClickedClosure = {
                tableView.reloadData()
            }
        }else if settingModel?.style == 1 {
            if settingModel?.title == "店铺区域" { // 店铺区域
                XHPickerViewManager.instance.show()
                XHPickerViewManager.instance.pichkerViewReturnClosure = { province, city in
                    settingModel?.subTitle = province + " " + city
                    tableView.reloadData()
                }
            }else if settingModel?.title == "行业类型" {  // 行业类型
                if classListArr.count == 0 {
                    getShopClassesList()
                    return
                }
                XHPickerViewManager.instance.showSinglePickerView(dataArr: classListArr)
                XHPickerViewManager.instance.siglePickerViewClosure = { [weak self] title in
                    settingModel?.subTitle = title
                    tableView.reloadData()
                    self?.classType(title: title)
                }
            }else if settingModel?.title == "营业时间" { // 营业时间
                let timePickerView = XHDatePickerView(complete: { (startDate, endDate) in
                    let sformatter = DateFormatter()
                    sformatter.dateFormat = "HH:mm"
                    var startStr = sformatter.string(from: Date())
                    var endStr = sformatter.string(from: Date())
                    if startDate != nil {
                        startStr = sformatter.string(from: startDate!)
                    }
                    if endDate != nil {
                        endStr = sformatter.string(from: endDate!)
                    }
                    
                    settingModel?.subTitle = startStr + " - " + endStr
                    tableView.reloadData()
                })
                timePickerView?.datePickerStyle = DateStyleShowHourMinute
                timePickerView?.dateType = DateTypeStartDate
                
                let timeStamp = 0000000000
                //转换为时间
                let timeInterval:TimeInterval = TimeInterval(timeStamp)
                let date = Date(timeIntervalSince1970: timeInterval)
                timePickerView?.minLimitDate = date
                timePickerView?.show()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let titleL = UILabel()
        titleL.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        titleL.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(16)
        }
        
        let model = dataArr?[section]
        titleL.text = model?.headerTitle
        
        if section == 0 {
            titleL.textColor = XHRgbColorFromHex(rgb: 0xea2000)
        }else {
            if #available(iOS 10.0, *) {
                titleL.textColor = UIColor(displayP3Red:  58 / 255, green: 219 / 255, blue: 73 / 255, alpha: 1.0)
            } else {
                titleL.textColor = UIColor(red: 58 / 255, green: 219 / 255, blue: 73 / 255, alpha: 1.0)
            }
        }
        headerView.frame = CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 36)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 6 {
            return 76
        }else if indexPath.section == 1, indexPath.row == 0 {
            return 76
        }else {
            return 40
        }
    }
}
