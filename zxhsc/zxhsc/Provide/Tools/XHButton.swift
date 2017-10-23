//
//  XHButton.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/3.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHButton: UIButton {}

extension UIButton: CAAnimationDelegate {
    
    // !!!:- 动画方法
    /// 动画方法
    ///
    /// - Parameter animationImgName: 做动画所需要的图片的名称
    func startAnimation(animationImgName: String) {
        
        adjustsImageWhenHighlighted = false
        
        // 初始化frame
        let imgView   = UIImageView.init(image: UIImage.init(named: animationImgName))
        imgView.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: 24, height: 24)
        superview?.addSubview(imgView)
        
        // MARK: 1. 设置动画组
        let aniGroup = CAAnimationGroup.init()
        
        // MARK: 1.1 动画路径
        let ani = CAKeyframeAnimation.init()
        // 1.1.1 修改位置
        ani.keyPath = "position"
        // 1.1.2 画曲线
        let path       = UIBezierPath.init()
        let startPoint = self.center
        path.move(to: startPoint)
        // 1.1.3 设置最终点
        let endPoint = CGPoint.init(x: imgView.center.x + 5, y: imgView.center.y - 40)
        // 拐点
        path.addQuadCurve(to: endPoint, controlPoint: CGPoint.init(x: startPoint.x - 10, y: startPoint.y - 20))
        // 1.1.4 设置路径
        ani.path = path.cgPath
        
        // MARK: 2. 透明度变化
        let ani_opacity       = CABasicAnimation.init(keyPath: "opacity")
        ani_opacity.fromValue = NSNumber.init(value: 1.0)
        ani_opacity.toValue   = NSNumber.init(value: 0.0)
        
        // MARK: 3.缩放
        let ani_scale     = CABasicAnimation.init()
        ani_scale.toValue = NSValue.init(cgSize: CGSize.init(width: 1.3, height: 1.3))
        ani_scale.keyPath = "transform.scale"
        
        // MARK: 4. 向动画组中添加核心动画
        aniGroup.animations = [ani, ani_opacity, ani_scale]
        // 4.1 设置代理
        aniGroup.delegate   = self
        
        // 5. 设置时间
        aniGroup.duration = 0.8
        // 6. 完成动画后，layer不回到初始位置
        aniGroup.isRemovedOnCompletion = false
        aniGroup.fillMode = kCAFillModeForwards
        
        // 7. 设置的时候 写在添加核心动画之前，销毁视图所用
        aniGroup.setValue(imgView, forKey: "imgView")
        imgView.layer.add(aniGroup, forKey: nil)
        
    }
    
    // MARK: 动画完成之后，销毁图片
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let imgView: UIImageView = anim.value(forKey: "imgView") as! UIImageView
        imgView.removeFromSuperview()
    }
}
