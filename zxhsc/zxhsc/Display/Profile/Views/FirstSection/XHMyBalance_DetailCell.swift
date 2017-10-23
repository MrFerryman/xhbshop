//
//  XHMyBalance_DetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import Charts

class XHMyBalance_DetailCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var balanceL: UILabel!
    
    @IBOutlet weak var redL: UILabel!
    
    @IBOutlet weak var greenL: UILabel!
    
    @IBOutlet weak var withdrawL: UILabel!
    
    @IBOutlet weak var staticL: UILabel!
    
    @IBOutlet weak var chartsView: UIView!
    
    var earningModel: XHUserEarningModel? {
        didSet {
            let activity = NSString(string: (earningModel?.balance_activity ?? "0")).floatValue
            let unactivity = NSString(string: (earningModel?.balance_unactivuty ?? "0")).floatValue
            let result = activity + unactivity
            balanceL.text = String(format: "%.2f", result)
            
            withdrawL.text = earningModel?.balance_activity ?? "0"
            staticL.text = earningModel?.balance_unactivuty ?? "0"
            
            setupUI()
            
            let withdraw = NSString(string: (earningModel?.balance_activity ?? "0")).doubleValue
            let staticV = NSString(string: (earningModel?.balance_unactivuty ?? "0")).doubleValue
            setData(values: [withdraw, staticV])
        }
    }
    
    /// 钱包明细  按钮点击事件回调
    var walletDetailButtonClickedClosure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        redL.layer.cornerRadius = 7
        redL.layer.masksToBounds = true
        
        greenL.layer.cornerRadius = 7
        greenL.layer.masksToBounds = true
        
    }
    
    // MARK:-
    private func setupUI() {
        
        setupChartView()
        
        pieView.legend.enabled = false
        pieView.delegate = self
        pieView.setExtraOffsets(left: 15.0, top: 0.0, right: 10.0, bottom: 0.0)
        pieView.animate(yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func setupChartView() {
        
        chartsView.addSubview(pieView)
        pieView.snp.makeConstraints { (make) in
            make.center.equalTo(chartsView)
            make.width.height.equalTo(280)
        }
        
        pieView.usePercentValuesEnabled = true // 是否根据所提供的数据, 将显示数据转换为百分比格式
        pieView.drawEntryLabelsEnabled = false  // 是否显示区块文本
        pieView.drawCenterTextEnabled = true
        pieView.holeRadiusPercent = 0.4
        pieView.transparentCircleRadiusPercent = 0.5
        pieView.chartDescription?.enabled = true
        pieView.setExtraOffsets(left: 5.0, top: 10.0, right: 5.0, bottom: 5.0)
        
        // 设置饼状图描述
        pieView.chartDescription?.text = ""
        pieView.chartDescription?.font = UIFont.systemFont(ofSize: 10)
        pieView.chartDescription?.textColor = .gray
        
        pieView.drawHoleEnabled = true
        pieView.rotationAngle = 0.0
        pieView.rotationEnabled = true
        pieView.highlightPerTapEnabled = true
        
        let l: Legend = pieView.legend
        l.horizontalAlignment = .center // 图例在饼状图中的位置 水平
        l.verticalAlignment = .bottom // 图例在饼状图中的位置 垂直
        l.orientation = .vertical
        l.drawInside = true
        l.xEntrySpace = 7.0
        l.yEntrySpace = 0.0
        l.yOffset = 0.0
        
        // 设置饼状图图例样式
        pieView.legend.maxSizePercent = 1;//图例在饼状图中的大小占比, 这会影响图例的宽高
        pieView.legend.formToTextSpace = 5;//文本间隔
        pieView.legend.font = UIFont.systemFont(ofSize: 10) //字体大小
        pieView.legend.textColor = .gray //字体颜色
        
        pieView.legend.form = .circle;//图示样式: 方形、线条、圆形
        //        pieView.legend.formSize = 12;//图示大小
    }

    
//    private func updateChartData() {
//
//        setData()
//    }

    private func setData(values: [Double]) {
        var entries = Array<PieChartDataEntry>()
        
        for i in 0 ..< values.count {
            entries.append(PieChartDataEntry(value: values[i], label: ""))
        }
        
        let dataSet = PieChartDataSet(values: entries, label: "")
        dataSet.sliceSpace = 2.0
        
        // 添加颜色
        var colors = [NSUIColor]()
        colors.append(XHRgbColorFromHex(rgb: 0xff4e4e))
        colors.append(XHRgbColorFromHex(rgb: 0x5ea5f7))
//        colors.append(contentsOf: ChartColorTemplates.colorful())
//        colors.append(contentsOf: ChartColorTemplates.liberty())
//        colors.append(contentsOf: ChartColorTemplates.pastel())
        
//        colors.append(NSUIColor(colorLiteralRed:  51/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1.0))
        
        dataSet.colors = colors
        
        dataSet.valueLinePart1OffsetPercentage = 0.6
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        
        dataSet.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont(name: "Helvetica Neue Light", size: 11.0))
        data.setValueTextColor(UIColor.black)
        
        pieView.data = data
        pieView.highlightValues(nil)
    }
    
    @IBAction func walletDetailButtonClicked(_ sender: UIButton) {
        walletDetailButtonClickedClosure?()
    }
    
    // MARK:- 懒加载
    private lazy var pieView: PieChartView = PieChartView()
}
