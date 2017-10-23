//
//  XHSettingConfigController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ALCameraViewController
import Photos
import Alamofire
import SSKeychain

/// 修改资料的类型
enum configType {
    case nickname // 昵称
    case name     // 姓名
    case idNumber // 身份证号码
}

class XHSettingConfigController: UIViewController {

    fileprivate let reuseId = "XHSettingConfigController_tableView_CELL"
    
    /// 标题数组
    fileprivate let titlesArr = ["会员头像", "会员id","手机号", "会员昵称", "姓名", "身份证号"]
    
    /// 内容数组
    fileprivate var contentArr: [String] = []
    // 头像图片
    fileprivate var headerImg: UIImage?
    /// 用户信息模型
    fileprivate var userModel: XHMemberDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        // 设置tableView
        setupTableView()
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 请求用户详情
    private func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .get_memberDetail, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.loadData()
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is XHMemberDetailModel {
                 let userModel = sth as! XHMemberDetailModel
                self?.userModel = userModel
                self?.saveModelToArray(userModel)
            }else {
                let str = sth as! String
                XHAlertController.showAlertSigleAction(title: nil, message: str, confirmTitle: "确定", confirmComplete: {
                    if str == "请重新登陆！" {
                        let login = XHLoginController()
                        let nav = XHNavigationController(rootViewController: login)
                        self?.present(nav, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    // MARK:- 保存用户详情
    private func saveMemberDetail() {
        let paraDict = ["name": contentArr[4], "nicheng": contentArr[3], "user": contentArr[2], "shenfenzhenghao": contentArr[5], "touurl": contentArr[0]]
        
        showHud(in: view, hint: "上传中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .modifyUserDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            let str = sth as! String
            self?.showHint(in: (self?.view)!, hint: str)
            if str == "信息修改成功！" {
                let userModel = NSKeyedUnarchiver.unarchiveObject(withFile: userAccountPath) as? XHUserModel
                userModel?.iconName = self?.userModel?.iconName
                userModel?.nickname = self?.userModel?.nickname
                NSKeyedArchiver.archiveRootObject(userModel, toFile: userAccountPath)
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK:- 上传头像
    private func uploadPicture(image: UIImage, asset: PHAsset) {
        XHProfileViewModel.uploadImage(image: image, target: self, success: { [weak self] (imageName) in
            self?.userModel?.iconName = imageName
            self?.saveModelToArray((self?.userModel)!)
            self?.tableView.reloadData()
        }) { (error) in
            XHAlertController.showAlertSigleAction(title: "提示", message: error.localizedDescription, confirmTitle: "确定", confirmComplete: nil)
        }
    }
    
    fileprivate func saveModelToArray(_ userModel: XHMemberDetailModel) {
        contentArr.removeAll()
        contentArr.append(userModel.iconName)
        contentArr.append(userModel.numberStr)
        contentArr.append(userModel.account)
        contentArr.append(userModel.nickname)
        contentArr.append(userModel.name)
        contentArr.append(userModel.idCardNum)
        tableView.reloadData()
    }
    
    // MARK:- 更改头像cell点击事件
    fileprivate func setupHeaderImageClicked() {
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camaraA = UIAlertAction(title: "拍照", style: .default) { (action) in
            let cameraViewController = CameraViewController(croppingEnabled: true, allowsLibraryAccess: true) { [weak self] image, asset in
                if image != nil {
                    self?.uploadPicture(image: image!, asset: asset!)
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
                    self?.uploadPicture(image: image!, asset: asset!)
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
    
    // MARK:- 界面相关
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        tableView.register(XHSettingConfigCell.self, forCellReuseIdentifier: reuseId)
        tableView.tableFooterView = footerView
        footerView.saveButtonClickedClosure = { [weak self] in
            self?.saveMemberDetail()
        }
    }
    
    // MARK:- 设置导航栏
    private func setupNav() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }

        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK:- 懒加载
    /// tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        return tableView
    }()

    // 顶部视图
    private lazy var topView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var footerView: XHSettingConfigFooterView = XHSettingConfigFooterView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: 100))
}

extension XHSettingConfigController: UITableViewDelegate, UITableViewDataSource {
    // 几行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArr.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: XHSettingConfigCell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! XHSettingConfigCell
        cell.accessoryType = .disclosureIndicator
        cell.isImgCell = false
        if indexPath.row == 0 {
            cell.isImgCell = true
        }else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        
        cell.title = titlesArr[indexPath.row]
        if contentArr.count == titlesArr.count {
            cell.contentStr = contentArr[indexPath.row]
        }
        if headerImg != nil {
            cell.img = headerImg
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            setupHeaderImageClicked()
        case 1, 2, 3:
            showHint(in: view, hint: "该信息不能被修改~")
        default:
            
            var comeFrom: configType = .nickname
            switch indexPath.row {
            case 4:
                comeFrom = .name
            case 5:
                comeFrom = .idNumber
            default:
                break
            }
            
            let setting = XHSettingDetailConfController()
            setting.comeFromType = comeFrom
            setting.userModel = self.userModel
            navigationController?.pushViewController(setting, animated: true)
            
            setting.savedButtonClickedClosure = { [weak self] userModel in
                self?.saveModelToArray(userModel)
            }
        }
    }
}

class XHSettingConfigFooterView: UIView {
    
    /// 保存按钮的点击事件回调
    var saveButtonClickedClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }
    }
    
    // MARK:- 保存按钮点击事件
    @objc private func saveButtonClick() {
        saveButtonClickedClosure?()
    }
    
    /// 保存按钮
    private lazy var saveButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("保存", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        return btn
    }()
}
