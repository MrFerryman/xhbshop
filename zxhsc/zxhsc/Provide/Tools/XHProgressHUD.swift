//
//  XHProgressHUD.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MBProgressHUD

struct XHProgressHUD {

}
// keyWindow
let KeyWindow : UIWindow = UIApplication.shared.keyWindow!

private var HUDKey = "HUDKey"
extension UIViewController {
    var hud: MBProgressHUD? {
        get{
            return objc_getAssociatedObject(self, &HUDKey) as? MBProgressHUD
        }
        set{
            objc_setAssociatedObject(self, &HUDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     显示提示信息(有菊花, 一直显示, 不消失)，默认文字“加载中”，默认偏移量0
     
     - parameter view:    显示在哪个View上
     - parameter hint:    提示信息
     - parameter yOffset: y上的偏移量
     */
    func showHud(in view: UIView, hint: String = "加载中...", yOffset:CGFloat? = 0, backColor: UIColor = .black) {
        hud?.hide(animated: true)
        hud = MBProgressHUD(view: view)
        hud?.label.text = hint
        hud?.label.font = UIFont.systemFont(ofSize: 13)
        hud?.label.numberOfLines = 0
        hud?.label.bounds.size.width = kUIScreenWidth - 40
        //设为false后点击屏幕其他地方有反应
        hud?.isUserInteractionEnabled = true
        //HUD内的内容的颜色
        hud?.contentColor = UIColor(red:0.82, green:0.82, blue:0.82, alpha:1.00)
        //View的颜色
        hud?.bezelView.color = backColor
        //style -blur 不透明 －solidColor 透明
        hud?.bezelView.style = .solidColor
        hud?.margin = 12
        //偏移量，以center为起点
        hud?.offset.y = yOffset ?? 0
        view.addSubview(hud!)
        hud?.show(animated: true)
    }
    
    /**
     显示纯文字提示信息(显示在keywindow上)，默认时间2s，默认偏移量0
     
     - parameter hint: 提示信息
     - parameter duration: 持续时间(不填的话, 默认两秒)
     - parameter yOffset: y上的偏移量
     */
    func showHintInKeywindow(hint: String, duration: Double = 2.0, yOffset:CGFloat? = 0) {
        hud?.hide(animated: true)
        let view = KeyWindow
        hud = MBProgressHUD(view: view)
        view.addSubview(hud!)
        hud?.animationType = .zoomOut
        hud?.isUserInteractionEnabled = false
        hud?.bezelView.color = UIColor.black
        hud?.contentColor = UIColor.white
        hud?.mode = .text
        hud?.label.text = hint
        hud?.label.numberOfLines = 0
        hud?.label.bounds.size.width = kUIScreenWidth - 40
        hud?.label.font = UIFont.systemFont(ofSize: 13)
        hud?.show(animated: true)
        hud?.removeFromSuperViewOnHide = false
        hud?.offset.y = yOffset ?? 0
        hud?.margin = 12
        hud?.hide(animated: true, afterDelay: duration)
    }
    
    /**
     显示纯文字提示信息，默认时间1.5s，默认偏移量0
     
     - parameter view: 显示在哪个View上
     - parameter hint: 提示信息
     - parameter duration: 持续时间(不填的话, 默认两秒)
     - parameter yOffset: y上的偏移量
     */
    func showHint(in view: UIView, hint: String, duration: Double = 1.5, yOffset:CGFloat? = 0) {
        hud?.hide(animated: true)
        hud = MBProgressHUD(view: view)
        view.addSubview(hud!)
        hud?.animationType = .zoomOut
        hud?.bezelView.color = UIColor.black
        hud?.contentColor = UIColor.white
        hud?.mode = .text
        hud?.label.text = hint
        hud?.label.font = UIFont.systemFont(ofSize: 13)
        hud?.label.numberOfLines = 0
        hud?.label.bounds.size.width = kUIScreenWidth - 40
        hud?.isUserInteractionEnabled = false
        hud?.removeFromSuperViewOnHide = false
        hud?.show(animated: true)
        hud?.offset.y = yOffset ?? 0
        hud?.margin = 12
        hud?.hide(animated: true, afterDelay: duration)
    }
    
    /// 移除提示
    func hideHud() {
        //如果解包成功则移除，否则不做任何事
        if let hud = hud {
            hud.hide(animated: true)
            hud.removeFromSuperview()
        }
        hud?.removeFromSuperview()
    }
}

