//
//  XHWinning_luckyCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWinning_luckyCell: UITableViewCell {

    
    var modelArr: [XHLuckyModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var topView: UIView!
    
    fileprivate let reuseID_LUCKY = "XHWinning_luckyCell_reuseID_LUCKY"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.layer.cornerRadius = 6
        topView.layer.masksToBounds = true
        selectionStyle = .none
        setupCollectionView()
    }

    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.bottom.equalTo(-50)
            make.right.equalTo(-40)
            make.top.equalTo(topView.snp.bottom).offset(8)
        }
        
        collectionView.register(UINib(nibName: "XHWinning_mineCollectionCell", bundle: nil), forCellWithReuseIdentifier: reuseID_LUCKY)
    }

    
    // MARK:- 懒加载
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        // 间距,行间距,偏移
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.itemSize = CGSize(width: kUIScreenWidth - 40, height: 30)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
}

extension XHWinning_luckyCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: XHWinning_mineCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID_LUCKY, for: indexPath) as! XHWinning_mineCollectionCell
        cell.luckyModel = modelArr?[indexPath.row]
        return cell
    }
}
