//
//  XHRichLabel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
enum RichLabelImageStyle {
    case front // 图片在前
    case back  // 图片在后
}

class XHRichLabel: UILabel {
    
}
extension UILabel {
    
    func richLableWithImage(_ contentStr: String, fontSize: CGFloat, isShowColor: Bool? = true) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        if isShowColor == true || isShowColor == nil {
            attriStr.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.red, range: NSRange(location: 0, length: strLength))
        }
        
         attriStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: strLength))
        attriStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: strLength))
        
        // 添加图片到指定的位置
        let attchImage = NSTextAttachment()
        
        // 表情图片
        attchImage.image = UIImage(named: "home_yuanbao_white")
        
        // 设置图片大小
        attchImage.bounds = CGRect(x: 0, y: 0, width: 13, height: 9)
        let stringImage = NSAttributedString(attachment: attchImage)
        attriStr.insert(stringImage, at: 0)
        
        return attriStr
    }
    
    func richLableWithRedImage(_ contentStr: String, fontSize: CGFloat, imgName: String? = "home_yuanbao", imageStyle: RichLabelImageStyle? = .front) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        attriStr.addAttribute(NSAttributedStringKey.foregroundColor, value: XHRgbColorFromHex(rgb: 0xea2000), range: NSRange(location: 0, length: strLength))
        attriStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: strLength))
        
        // 添加图片到指定的位置
        let attchImage = NSTextAttachment()
        
        // 表情图片
        attchImage.image = UIImage(named: imgName!)
        
        // 设置图片大小
        attchImage.bounds = CGRect(x: 0, y: 0, width: 13, height: 9)
        let stringImage = NSAttributedString(attachment: attchImage)
        
        if imageStyle == .front {
            attriStr.insert(stringImage, at: 0)
        }else {
            attriStr.insert(stringImage, at: strLength)
        }
        
        return attriStr
    }

    func richLableWithOrderImage(_ contentStr: String) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        attriStr.addAttribute(NSAttributedStringKey.foregroundColor, value: XHRgbColorFromHex(rgb: 0x666666), range: NSRange(location: 0, length: strLength))
        attriStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: strLength))
        
        // 添加图片到指定的位置
        let attchImage = NSTextAttachment()
        
        // 表情图片
        attchImage.image = UIImage(named: "order_yuanbao_gray")
        
        // 设置图片大小
        attchImage.bounds = CGRect(x: 0, y: 0, width: 13, height: 9)
        let stringImage = NSAttributedString(attachment: attchImage)
        
        attriStr.insert(stringImage, at: 0)
        
        return attriStr
    }

    
    func richLabelWithBrandImage(contentStr: String, brandImage: String? = "coalition_brand") -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        // 添加图片到指定的位置
        let attchImage = NSTextAttachment()
        
        // 表情图片
        attchImage.image = UIImage(named: brandImage!)
        
        // 设置图片大小
        attchImage.bounds = CGRect(x: 0, y: -2, width: 35, height: 15)
        let stringImage = NSAttributedString(attachment: attchImage)
        
        attriStr.insert(stringImage, at: strLength)
        
        return attriStr
    }

    func stringWithTwoSize(_ contentStr: String, _ bigSize: CGFloat, _ otherSize: CGFloat) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        
        let str = NSString(string: contentStr)
        var tempStr1: String?
        var tempStr2: String?
        let tempArr = str.components(separatedBy: ".")
        for i in 0 ..< Int(tempArr.count) {
            if tempArr.count > 1 {
                if i == 0 {
                    tempStr1 = tempArr[i]
                }else {
                    tempStr2 = tempArr[i]
                }
            }else {
                tempStr1 = tempArr[i]
            }
            
        }
        
        attriStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: bigSize), range: NSRange(location: 0, length: NSString(string: tempStr1!).length))
        if tempArr.count > 1 {
            attriStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: otherSize), range: NSRange(location: NSString(string: tempStr1!).length + 1, length: NSString(string: tempStr2!).length))
        }
        
        return attriStr
    }
}
