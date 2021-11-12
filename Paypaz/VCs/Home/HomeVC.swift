//
//  HomeVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class HomeVC : CustomViewController {
    
    //MARK:- --- View Life Cycle ----
    @IBOutlet weak var cartCountLabel : UILabel!{
        didSet{
            cartCountLabel.layer.cornerRadius = cartCountLabel.frame.height/2
            cartCountLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var notificationIcon : UIButton!
    private let GetCartItemsDataSource = AddToCartDataModel()
    var Items = [CartInfo]()
    let application = UIApplication.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        getCartItems()
   
        if application.applicationIconBadgeNumber > 0{
            notificationIcon.setImage(UIImage(named: "notification_red_with_dot"), for: .normal)
        }
        else{
            notificationIcon.setImage(UIImage(named: "notification_red"), for: .normal)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(showPopupForPaymentSuccess(notification:)), name: NSNotification.Name("ShowPopUp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeDotFromNotification(notification:)), name: NSNotification.Name("RemoveDotInHomeVC"), object: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.notificationsFetched = {
            self.notificationIcon.setImage(UIImage(named: "notification_red_with_dot"), for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if application.applicationIconBadgeNumber > 0{
            notificationIcon.setImage(UIImage(named: "notification_red_with_dot"), for: .normal)
        }
    }
    @objc func removeDotFromNotification(notification: Notification)
    {
        notificationIcon.setImage(UIImage(named: "notification_red"), for: .normal)
    }
    @objc func showPopupForPaymentSuccess(notification: Notification)
    {
        getCartItems()
        let message = notification.userInfo?["Message"] as? String ?? ""
        self.view.makeToast(message)
    }
    func getCartItems(){
        Connection.svprogressHudShow(view: self)
        GetCartItemsDataSource.cartItemsDelegate = self
        GetCartItemsDataSource.getCartItems()
    }
    //MARK:- --- Action ----
    @IBAction func btn_SideDrawer(_ sender:UIButton) {
        
        self.sideMenuController?.toggleLeftView()
    }
    @IBAction func btn_Cart(_ sender:UIButton) {
        _ = self.pushVC("MyCartVC")
    }
    @IBAction func btn_Notification(_ sender:UIButton) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationIcon.setImage(UIImage(named: "notification_red"), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name("RemoveDotInSettingsVC"), object: nil, userInfo: nil)
        _ = self.pushVC("NotificationsListVC")
    }
    
    @IBAction func btn_PaypazSecureMoney(_ sender:UIButton) {
        _ = self.pushVC("WalletVC")
    }
    @IBAction func btn_Payment(_ sender:UIButton) {
        _ = self.pushVC("PaymentTypeVC")
    }
    @IBAction func btn_Event(_ sender:UIButton) {
        if let vc = self.pushVC("EventVC") as? EventVC{
            vc.delegate = self
        }
    }
}
extension HomeVC : PopupDelegate{
    func isClickedButton(){
        self.getCartItems()
    }
}
extension HomeVC : GetCartItemsDataModelDelegate{
    func didRecieveDataUpdate(data: CartItemsModel) {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.Items = data.data ?? []
            self.cartCountLabel.alpha = 1
            self.cartCountLabel.text = "\(self.Items.count)"
            UserDefaults.standard.setValue(self.Items.count, forKey: "CartCount")
        }
        else
        {
            self.cartCountLabel.alpha = 0
            //view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError5(error: Error) {
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
