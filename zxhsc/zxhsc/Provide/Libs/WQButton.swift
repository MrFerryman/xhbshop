//
//  WQButton.swift
//  CustomButton
//
//  Created by 醉清风 on 2017/5/4.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit

class WQButton: NSObject {

    
}

enum style {
    case styleLeft // 文字在左，图片在右
    case styleRight // 文字在右，图片在左
    case styleTop // 文字在上，图片在下
    case styleBottom // 文字在下，图片在上
}

// !!!: 按钮的扩展
extension UIButton {
    
    /// 设置按钮 文字和图片 结构
    ///
    /// - Parameters:
    ///   - style: 文字和图片的位置类型
    ///   - titleImageSpace: 标题和图片的距离
    func layoutButtonTitleImageEdge(style: style, titleImageSpace: CGFloat) {
        // 获取label的宽和高
        let labelW: CGFloat = (titleLabel?.intrinsicContentSize.width)!
        let labelH: CGFloat = (titleLabel?.intrinsicContentSize.height)!
        
        // 获取图片的宽和高
        let imageW: CGFloat = (imageView?.intrinsicContentSize.width)!
        let imageH: CGFloat = (imageView?.intrinsicContentSize.height)!
        
        var labelEdgeInsets = UIEdgeInsets.zero
        var imgEdgeInsets = UIEdgeInsets.zero
        
        switch style {
            
        case .styleLeft:
            imgEdgeInsets = UIEdgeInsets(top: 0, left: labelW + titleImageSpace / 2, bottom: 0, right: -labelW - titleImageSpace / 2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageW - titleImageSpace / 2, bottom: 0, right: imageW + titleImageSpace / 2)
            
        case .styleRight:
            imgEdgeInsets = UIEdgeInsets(top: 0, left: titleImageSpace / 2, bottom: 0, right: -titleImageSpace / 2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: titleImageSpace / 2, bottom: 0, right: -titleImageSpace / 2)
            
        case .styleTop:
            imgEdgeInsets = UIEdgeInsetsMake(labelH / 2 + titleImageSpace / 4, labelW / 2, -labelH / 2 - titleImageSpace / 4, -labelW / 2)
            labelEdgeInsets = UIEdgeInsetsMake(-imageH / 2 - titleImageSpace / 4, -imageW / 2, imageH / 2 + titleImageSpace / 4, imageW / 2)
            
        case .styleBottom:
            imgEdgeInsets = UIEdgeInsets(top: -labelH / 2 - titleImageSpace / 4, left: labelW / 2, bottom: labelH / 2 + titleImageSpace / 4, right: -labelW / 2)
            labelEdgeInsets = UIEdgeInsets(top: imageH / 2 + titleImageSpace / 4, left: -imageW / 2, bottom: -imageH / 2 - titleImageSpace / 4, right: imageW / 2)

        }
        
        titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imgEdgeInsets
    }
}
