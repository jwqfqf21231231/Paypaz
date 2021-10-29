//
//  ScanQRCodeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 30/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class ScanQRCodeVC: CustomViewController {
    
    @IBOutlet weak var userPic : UIImageView!
    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var qrCodeImg : UIImageView!
    var userName : String?
    var userImage :UIImage?
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = userName ?? ""
        userPic.image = userImage ?? UIImage(named: "place_holder")
        self.qrCodeImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .QRCODE)
        self.qrCodeImg.sd_setImage(with: URL(string: url+(UserDefaults.standard.getQRCode())), placeholderImage: UIImage(named: "qr_codes"))
    }

    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
