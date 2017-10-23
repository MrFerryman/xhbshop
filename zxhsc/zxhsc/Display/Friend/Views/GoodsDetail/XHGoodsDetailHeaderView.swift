//
//  XHGoodsDetailHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetailHeaderView: UIView {
    /// 标题按钮的点击事件回调
    var titleButtonClickedClosure: ((_ sender: UIButton) -> ())?
    
    private let titles = ["商品", "评价"]
    // 标题按钮数组
    private var titlesButtonArr: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ====== 事件相关 ========
    // MARK:- 标题按钮的点击事件
    @objc private func titleButtonClicked(sender: UIButton) {
        
        for i in 0 ..< Int(titlesButtonArr.count) {
            if i == sender.tag {
                let selectedBtn = titlesButtonArr[i]
                selectedBtn.isSelected = true
            }else {
                let selectedBtn = titlesButtonArr[i]
                selectedBtn.isSelected = false
            }
        }
        
        // 更新sliderView的frame
        var sliderFrame = sliderView.frame
        sliderFrame.origin.x = CGFloat(60 * sender.tag + (60 - 18) / 2)
        sliderFrame.origin.y = 42
        UIView.animate(withDuration: 0.3) {
            self.sliderView.frame = sliderFrame
        }
        
        titleButtonClickedClosure?(sender)
    }
    
    private func setupUI() {
        
        for i in 0 ..< 2 {
            let btn = UIButton(type: .custom)
            let title = titles[i]
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(XHRgbColorFromHex(rgb: 0x666666), for: .normal)
            btn.setTitleColor(XHRgbColorFromHex(rgb: 0xea2000), for: .selected)
            btn.tag = i
            let width: CGFloat = 60
            let height: CGFloat = 42
            let x = width * CGFloat(i)
            let y: CGFloat = 0.0
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            addSubview(btn)
            btn.addTarget(self, action: #selector(titleButtonClicked(sender:)), for: .touchUpInside)
            titlesButtonArr.append(btn)
        }
        
        titlesButtonArr[0].isSelected = true
        
        // 滑块
        addSubview(sliderView)
        let x: CGFloat = (60 - 18) / 2
        sliderView.frame = CGRect(x: x, y: 42, width: 18, height: 2)
        addSubview(sliderView)
    }
    
    // 滑块
    private lazy var sliderView: UIView = {
       let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xea2000)
        view.frame = CGRect(x: 0, y: 0, width: 18, height: 2)
        return view
    }()
}
