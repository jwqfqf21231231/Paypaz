//
//  PayAmountVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class PayAmountVC : CustomViewController {
    
    var totalPrice : Int?
    var cartInfo : UpdatedCartInfo?
    @IBOutlet weak var hostImage : UIImageView!
    @IBOutlet weak var hostNameLabel : UILabel!
    @IBOutlet weak var totalAmountLabel : UILabel!
    @IBOutlet weak var btn_PayByPaypaz : RoundButton!
    @IBOutlet weak var btn_PayByQR     : RoundButton!
    @IBOutlet weak var btn_PayByBank   : RoundButton!
    private let userProfileDataSource = LogInDataModel()
    var userDetails = [String:String]()
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalAmountLabel.text = "$\(totalPrice ?? 0)"
        getUserProfile()
    }
    
    private func getUserProfile(){
        userProfileDataSource.delegate = self
        userProfileDataSource.userID = self.cartInfo?.eventUserID ?? ""
        Connection.svprogressHudShow(view: self)
        userProfileDataSource.getUserProfile()
    }
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_P_Logo(_ sender:UIButton) {
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
    @IBAction func btn_PayByPaypaz(_ sender:UIButton) {
        if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
            vc.userDetails = self.userDetails
            vc.cartInfo = self.cartInfo
            vc.selectedPayType = .paypaz
        }
    }
    @IBAction func btn_PayByQRCode(_ sender:UIButton) {
        if let vc = self.pushVC("PaymentOptionsVC") as? PaymentOptionsVC{
            vc.userDetails = self.userDetails
            vc.cartInfo = self.cartInfo
            vc.selectedPayType = .QRCode
        }
    }
    @IBAction func btn_PayByBankAcc(_ sender:UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoneyPopupVC") as? AddMoneyPopupVC{
            vc.cartInfo = self.cartInfo
            vc.buyTicket = true
            vc.totalAmount = totalPrice
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
    }
}
extension PayAmountVC : LogInDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.userDetails["userImage"] = data.data?.userProfile ?? ""
            self.userDetails["userName"] = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
            self.userDetails["ticketPrice"] = "\(totalPrice ?? 0)"
           
            self.hostImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .USERIMAGE)
            self.hostImage.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
            self.hostNameLabel.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
        }
        else
        {
            view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
