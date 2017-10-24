//
//  XHCheckPendingImageView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCheckPendingImageView: UIView {
    
    var imagesArr: [String] = [] {
        didSet {
            
            setupImages()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @objc private func imageClicked(_ sender: UIGestureRecognizer) {
        
        UIApplication.shared.keyWindow?.addSubview(showView)
        
        showView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
        
        showView.dataImgArr = imagesArr
        
        showView.alpha = 0
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.showView.alpha = 1.0
        }
        
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(showViewClicked))
        showView.addGestureRecognizer(tap)
    }
    
    @objc private func showViewClicked() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.showView.alpha = 0
        }) { [weak self] (finish) in
            self?.showView.removeFromSuperview()
        }
    }
    
    
    private func setupImages() {
        let width: CGFloat = 70
        let height: CGFloat = width
        let margin: CGFloat = (kUIScreenWidth - 32 - width * 4) / 3
        for i in 0 ..< imagesArr.count {
            
            let x: CGFloat = (margin + width) * CGFloat(i)
            let y: CGFloat = 6
            let imgView = UIImageView(image: UIImage(named: "loding_icon"))
            imgView.isUserInteractionEnabled = true
            imgView.tag = i
            imgView.frame = CGRect(x: x, y: y, width: width, height: height)
            addSubview(imgView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageClicked(_:)))
            imgView.addGestureRecognizer(tap)
        }
    }
    
    private lazy var showView: XHEvaluationShowImagesView = XHEvaluationShowImagesView()
    
}
