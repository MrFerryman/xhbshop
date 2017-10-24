//
//  WQComposeView.swift
//  封装好用的方法
//
//  Created by 清风依旧醉春风 on 2017/4/10.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit
import pop

// 定义一个枚举,来定义按钮的动画方法
enum ComposeAnimationType: Int {
    case up = 0
    case down = 1
    case left = 2
    
}
class WQComposeView: UIView {

    // 动画出来的按钮点击回调事件
    var composeButtonsClickClosure:((_ sender: WQComposeButton) -> ())?
    
    // 定义一个成员变量,来接收控制器
    var viewC: UIViewController?
    
    // 创建一个数组,来盛放按钮
    fileprivate lazy var composeButtons: [UIView] = [UIView]()
    
    // 第一步 -- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 第二步 -- 定义一个方法,来实现 视图的添加和布局
    fileprivate func setupUI(){
        
        // 改变背景颜色
        backgroundColor = UIColor.yellow
        // 设置一下frmae
        var frame = self.frame
        
        frame.size = kUIScreenSize
        
        self.frame = frame
        
        
        addSubview(bgImageView)
        
        bgImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        bgImageView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImageView)
            make.bottom.equalTo(-15)
            make.width.height.equalTo(35)
        }
        self.bringSubview(toFront: cancelButton)
        
        addButtons()
    }
    // 添加按钮的方法
    fileprivate func addButtons(){
        
        // 0 .设置一下固定值
        let maxRow = 4
        let childButtonW: CGFloat = 46
        let childButtonH: CGFloat = 75
        let childButtonMargin = ( kUIScreenWidth - 4 * childButtonW ) / (CGFloat(maxRow) + 1)
        
        // 1. 读取plist文件
        let composeArray: Array<Dictionary<String, String>> = NSArray(contentsOfFile: Bundle.main.path(forResource: "compose.plist", ofType: nil)!)! as! Array<Dictionary<String, String>>
        
        // 2. 对数组进行遍历
        for i in 0..<composeArray.count {
            
            // 3
            let button = WQComposeButton()
            button.tag = i
            // 4. 拿到数据
            //  as! 只要敢保证前边的数据有值,而且类型也正确就可以 as!
            let dict = composeArray[i]
            let bgImg = dict["icon_bg"]
            let imageString = dict["icon"]
            let title = dict["title"]
            // 设置图片
            
            button.imgView.setBackgroundImage(UIImage(named: bgImg!), for: .disabled)
            button.imgView.setImage(UIImage(named: imageString!), for: .disabled)
            // 设置标题
            button.titleL.text = title
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClick(_:)))
            button.addGestureRecognizer(tap)
            
            
            // 5. 设置frame
            // 列
            let col = i % (maxRow)
            // 行
            let row = i / maxRow
    
            let x = childButtonMargin * CGFloat(col + 1) + childButtonW * CGFloat(col)
            
            let y = (childButtonMargin - 25) * CGFloat(row) + childButtonH * CGFloat(row) + KUIScreenHeight
            
            button.frame = CGRect(x: x, y: y, width: childButtonW, height: childButtonH)
            addSubview(button)
            
            
            // 添加到数组
            composeButtons.append(button)
        }
        
        
    }
    // MARK:-- 添加按钮动画的方法
    fileprivate func addButtonAnmation(_ button: UIView,time: CFTimeInterval,type: ComposeAnimationType) {
        
        
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        
        // 修改toValue, 让视图到指定的位置
        if type == .up { // up
            
            
            anim?.toValue = NSValue(cgPoint: CGPoint(x: button.center.x, y: button.center.y - KUIScreenHeight + 400))
        } else if type == .down { // down
            
            anim?.toValue = NSValue(cgPoint: CGPoint(x: button.center.x, y: button.center.y + KUIScreenHeight ))
        }
        
        //  弹性的反弹
        anim?.springBounciness = 4
        //  设置sprintSpeed
        anim?.springSpeed = 10
        
        //       let time = CACurrentMediaTime()
        // 动画的开始时间
        // CFTimeInterval
        anim?.beginTime = time
        
        // 添加动画
        button.pop_add(anim, forKey: nil)
    }
    // MARK:-- 这个是 对象方法
    func show(_ target: UIViewController){
        
        viewC = target
        
        viewC?.view.addSubview(self)
        
        // 对数组进行遍历,来添加动画
        for (index,button) in composeButtons.enumerated() {
            addButtonAnmation(button, time: CACurrentMediaTime() + 0.025 * Double(index),type: .up)
        }
        
    }
    //MARK:-- 类方法
    // 通过类方法,实现方法的调用,方便外接调用
    class func show(_ target: UIViewController){
        
        WQComposeView().show(target)
    }
    
    // MARK:- 退出事件
    @objc private func quitButtonClicked() {
        // 根据动画效果,是反着来的,所以我们的数组也可以反着遍历
        for (index,button) in composeButtons.reversed().enumerated() {
            addButtonAnmation(button, time: CACurrentMediaTime() + 0.025 * Double(index),type: .down)
        }
        
        // 为什么直接remove 没有任何效果,因为动画还没有来得及执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.removeFromSuperview()
        }
    }
    
    // MARK:-- 实现touch方法
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        quitButtonClicked()
    }
    
    //MARK:-- 按钮点击方法
    @objc fileprivate func buttonClick(_ sender: UITapGestureRecognizer){
        
        //
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            for value in self.composeButtons{
                // 让所有的控件的alpha 都变成0
                value.alpha = 0
                
                if value == sender.view! {
                    
                    value.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                    
                } else {
                    
                    value.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }
                
                
            }
            
        }, completion: { (_) -> Void in
            // 动画完成之后,进行页面的跳转
            
            self.composeButtonsClickClosure?(sender.view as! WQComposeButton)
            // 把自己移除
            self.removeFromSuperview()

        })
        
    }
    
    // MARK:-- 获取当前屏幕的截图
    func getScreenShot() -> UIImage{
        
        
        // 1. 先要获取一下当前的window
        let window = UIApplication.shared.keyWindow!
//        let window = (viewC?.view)!
        // 2. 开启绘图
        /*
         size: 大小
         opaque:是否透明
         scale: 缩放系数
         */
        UIGraphicsBeginImageContextWithOptions(kUIScreenSize, false, 1)
        
        // 3. 把window画在画板上
        window.drawHierarchy(in: kUIScreenBounds, afterScreenUpdates: false)
        
        // 4. 拿到image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭画板
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // 第三步: 懒加载控件
    fileprivate lazy var bgImageView: UIImageView = {
        
        let img = UIImageView()
        
        img.image = self.getScreenShot() //self.getScreenShot()
        
        // iOS 8 之后,系统为我们提供了一个毛玻璃效果
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        // 创建一个毛玻璃视图
        let effectView = UIVisualEffectView(effect: effect)
        
        // 把这个毛玻璃添加到 img
        img.addSubview(effectView)
        
        // 设置毛玻璃视图的约束
        effectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        effectView.alpha = 0.9
        return img
    }()


    // MARK:- 取消按钮
    private lazy var cancelButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setImage(UIImage(), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: "shop_close"), for: .normal)
        btn.addTarget(self, action: #selector(quitButtonClicked), for: .touchUpInside)
        return btn
    }()
}
