//
//  XHShakeLuckyController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import AVFoundation

class XHShakeLuckyController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var upImgView: UIImageView!
    
    @IBOutlet weak var downImgView: UIImageView!
    
    fileprivate let viewName = "幸运摇一摇页"
    
    /// 播放器
    fileprivate var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = XHRgbColorFromHex(rgb: 0xFFE27C)
        /**
         开启摇动感应
         */
        UIApplication.shared.applicationSupportsShakeToEdit = true
        becomeFirstResponder()
        
        setupNav()
        
        UIApplication.shared.keyWindow?.addSubview(maskView)
        maskView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        //开始动画
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.upImgView.frame.origin.y -= 80
            self.downImgView.frame.origin.y += 80
        }, completion: nil)
        
        /// 设置音效
        let path1 = Bundle.main.path(forResource: "rock", ofType:"mp3")
        let data1 = try? Data(contentsOf: URL(fileURLWithPath: path1!))
//            NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1!)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        
        
        //结束动画
        UIView.animateKeyframes(withDuration: 0.5, delay: 1.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.upImgView.frame.origin.y += 80
            self.downImgView.frame.origin.y -= 80
        }, completion: nil)
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("摇一摇取消")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        /// 设置音效
        let path = Bundle.main.path(forResource: "rock_end", ofType:"mp3")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        self.player = try? AVAudioPlayer(data: data!)
        self.player?.delegate = self
        self.player?.updateMeters() // 更新数据
        self.player?.prepareToPlay() // 准备数据
        self.player?.play()
    }
    
    private func setupNav() {
        title = "摇一摇抽大奖"
    }
    
    private lazy var maskView: XHShakeLuckyMaskView = Bundle.main.loadNibNamed("XHShakeLuckyMaskView", owner: nil, options: nil)?.first as! XHShakeLuckyMaskView
}
