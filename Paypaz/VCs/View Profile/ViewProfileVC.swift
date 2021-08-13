//
//  ViewProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 26/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

class ViewProfileVC : CustomViewController {
    //Here i am using UserDetailsDataModel. You can find it in SideDrawer
    private let dataSource = UserDetailsDataModel()
    @IBOutlet weak var img_ProfilePic : UIImageView!
    @IBOutlet weak var lbl_ProfileName : UILabel!
    @IBOutlet weak var lbl_Address : UILabel!
    @IBOutlet weak var lbl_DOB : UILabel!
    @IBOutlet weak var lbl_PhoneNo : UILabel!
    //MARK:- ----
    @IBOutlet weak var tableViewEvents : UITableView! {
        didSet {
            self.tableViewEvents.dataSource = self
            self.tableViewEvents.delegate   = self
        }
    }
    
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.getUserDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getUserDetails()
    }
    private func getUserDetails()
    {
        Connection.svprogressHudShow(view: self)
        dataSource.getUserDetails()
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_ViewQR(_ sender:UIButton) {
         _ = self.pushToVC("ScanQRCodeVC")
    }
    @IBAction func btn_Edit(_ sender:UIButton) {
        _ = self.pushToVC("EditProfileVC",animated: false)
    }
}
extension ViewProfileVC : UserDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: UserDetailsModel)
    {
        print("UserDetailsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                let url =  APIList().getUrlString(url: .USERIMAGE)
                self.img_ProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_ProfilePic.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
                let fullName = (data.data?.firstName ?? "")+" "+(data.data?.lastName ?? "")
                self.lbl_ProfileName.text = fullName
                self.lbl_DOB.text = data.data?.dob
                self.lbl_PhoneNo.text = UserDefaults.standard.getPhoneCode() + " " + (data.data?.phoneNumber ?? "")
                self.lbl_Address.text = data.data?.state ?? ""
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
