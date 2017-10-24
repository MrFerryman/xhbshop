//
//  XHImageManager.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHImageManager: NSObject {

    class func saveImageToDocument(image: UIImage, imageName: String) {
        /// 拿到图片
        let imageSave = image
        let path_sandbox = NSHomeDirectory()
        // 设置图片路径
        let imagePath = path_sandbox + "/Documents/\(imageName).png"
        // 把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        try? UIImagePNGRepresentation(imageSave)?.write(to: URL(fileURLWithPath: imagePath), options: Data.WritingOptions.atomic)
    }
    
    class func getDocumentImage(imageName: String) -> UIImage {
         // 读取沙盒路径图片
        let aPath = NSHomeDirectory() + "/Documents/" + imageName + ".png"
        // 拿到沙盒路径图片
        let imageFromURL = UIImage(contentsOfFile: aPath)
        return imageFromURL!
    }
}
