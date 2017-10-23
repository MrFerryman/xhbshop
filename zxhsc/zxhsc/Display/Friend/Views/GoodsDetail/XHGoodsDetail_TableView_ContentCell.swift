//
//  XHGoodsDetail_TableView_ContentCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetail_TableView_ContentCell: UITableViewCell, UIWebViewDelegate {

    var webViewScrollHeightClosure: ((_ scrollHeight: CGFloat) -> ())?
    
    var htmlStr: String? {
        didSet {
            
            webView.loadHTMLString(htmlStr!, baseURL: nil)
        }
    }
    
    fileprivate var index: Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
//        setWebViewHtmlImageFitPhone()
        index += 1
        if index < 2 {
            webViewScrollHeightClosure?(webView.scrollView.contentSize.height)
        }
    }
    
    private func setWebViewHtmlImageFitPhone() {
        let jsStr = String(format: "var script = document.createElement('script');" +
            "script.type = 'text/javascript';" +
            "script.text = \"function ResizeImages() { " +
            "var myimg,oldwidth;" +
            "var maxwidth = '%f';" + //自定义宽度
            "for(i=0;i <document.images.length;i++){" +
            "myimg = document.images[i];" +
            "if(myimg.width > maxwidth){" +
            "oldwidth = myimg.width;" +
            "myimg.width = maxwidth;" +
            "}" +
            "}" +
            "}\";" +
            "document.getElementsByTagName('head')[0].appendChild(script);", kUIScreenWidth)
        
        webView.stringByEvaluatingJavaScript(from: jsStr)
        webView.stringByEvaluatingJavaScript(from: "ResizeImages();")
    }

    
    lazy var webView: UIWebView = {
       let webView = UIWebView()
//        webView.contentMode = .center
//        webView.scrollView.contentMode = .center
//        webView.scalesPageToFit = true
        webView.delegate = self
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }()
    
    private lazy var fontL: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
}
