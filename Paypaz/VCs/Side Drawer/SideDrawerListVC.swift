//
//  SideDrawerListVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class SideDrawerListVC : CustomViewController {

    private let dataSource = UserDetailsDataModel()

    @IBOutlet weak var img_ProfilePic : UIImageView!
    @IBOutlet weak var lbl_ProfileName : UILabel!
    @IBOutlet weak var lbl_PhoneNo : UILabel!
    @IBOutlet weak var tableViews : UITableView! {
        didSet {
            tableViews.dataSource = self
            tableViews.delegate   = self
        }
    }
    
    var arr_Menu : [String]?
    var arr_imgs : [String]?
    
    @IBOutlet weak var view_Profile : UIView!
    
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.arr_Menu = [Constants.title_Home, Constants.title_Wallet, Constants.title_MyTickets, Constants.title_Settings, Constants.title_MyEvents, Constants.title_Favourites , Constants.title_Invites, Constants.title_EventReport, Constants.title_Logout]
    
        self.arr_imgs = ["home", "wallet", "ticketsicon", "settings", "event", "heart-o", "add-group", "event_report", "logout"]
        
        self.addTapGestureToView()
        self.getUserDetails()
    }
  
    private func getUserDetails()
    {
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.getUserDetails()
        
    }
    func pushToChildVC (_ identifier : String, animated:Bool = true) -> UIViewController {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) else { return UIViewController() }
        if let nav = self.sideMenuController?.rootViewController as? UINavigationController {
            nav.pushViewController(viewController, animated: true)
        }
        return viewController
        
    }
    
    private func addTapGestureToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(action_ProfileView(_:)))
        
        self.view_Profile.addGestureRecognizer(tap)
    }
    
    @objc private func action_ProfileView(_ gesture:UITapGestureRecognizer){
        self.sideMenuController?.hideLeftView()
        _ = self.pushToChildVC("ViewProfileVC",animated: false)
    }
    
    //MARK:-
    @IBAction func btn_QRCode (_ sender:UIButton)
    {
        self.sideMenuController?.hideLeftView()
        _ = self.pushToChildVC("ViewProfileVC",animated: false)
    }
    
}
extension SideDrawerListVC : UserDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: UserDetailsModel)
    {
        print("UserDetailsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                self.img_ProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .USERIMAGE)
                self.img_ProfilePic.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
                let fullName = (data.data?.firstName ?? "")+" "+(data.data?.lastName ?? "")
                self.lbl_ProfileName.text = fullName
                self.lbl_PhoneNo.text = data.data?.phoneNumber
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
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