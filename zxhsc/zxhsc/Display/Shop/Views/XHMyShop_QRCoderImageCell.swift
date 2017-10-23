//
//  XHMyShop_QRCoderImageCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit


class XHMyShop_QRCoderImageCell: UITableViewCell {

    @IBOutlet weak var qrcoderView: UIImageView!
    
    var shopModel: XHMyShop_settingModel? {
        didSet {
            if shopModel?.id != nil {
                let qrStr = "{shop_id:\(String(describing: (shopModel?.id)!))}"
                qrcoderView.image = XHQRCodeManager().generateQRCodeImage(info: qrStr, size: CGSize(width: 240, height: 240), avartarImg: nil)
                if shopModel?.logo != nil {
                    let imgView = UIImageView()
                    imgView.sd_setImage(with: URL(string: XHImageBaseURL + (shopModel?.logo)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload, completed: { [weak self] (image, error, imgChachaType, url) in
                        self?.qrcoderView.image = XHQRCodeManager().insertAvatarImage(qrimage: (self?.qrcoderView.image)!, avatar: image!)
                    })
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
