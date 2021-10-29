//
//  ContactListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
import libPhoneNumber_iOS
extension ContactListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContactDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell")  as? MemberCell
        else { return MemberCell() }
        cell.contactName_lbl.text = (filteredContactDetails[indexPath.row].firstName ?? "") + " " + (filteredContactDetails[indexPath.row].lastName ?? "")
        cell.contactNo_lbl.text = filteredContactDetails[indexPath.row].phoneNumber
        cell.contactPic_img.image = filteredContactDetails[indexPath.row].profilePic
        return cell
    }
}

extension ContactListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        self.view.endEditing(true)
        self.contactName = (filteredContactDetails[indexPath.row].firstName ?? "") + " " + (filteredContactDetails[indexPath.row].lastName ?? "")
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
            return
        }
        do {
        let numberProto: NBPhoneNumber = try phoneUtil.parse(filteredContactDetails[indexPath.row].phoneNumber ?? "", defaultRegion: "IN")
        
        phoneCode = numberProto.countryCode!
        phoneNumber = numberProto.nationalNumber!
            Connection.svprogressHudShow(view: self)
            dataSource.phoneNumber = "\(phoneNumber ?? 0)"
            dataSource.phoneCode = "\(phoneCode ?? 0)"
            dataSource.verifyContact()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
       
    }
}
extension ContactListVC : VerifyContactDelegate{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let vc = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC{
                vc.userDetails = ["userPic":data.data?.userProfile ?? "","userName":((data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")), "phoneCode":data.data?.phoneCode ?? "", "phoneNumber":data.data?.phoneNumber ?? ""]
                vc.receiverID = data.data?.id ?? ""
                vc.selectedPaymentType = .local
                vc.paypazUser = true
            }
        }
        else
        {
            if let vc = self.pushVC("RequestPayAmountVC") as? RequestPayAmountVC{
                vc.userDetails = ["userName":self.contactName ?? "","phoneCode":"\(phoneCode ?? 0)","phoneNumber":"\(phoneNumber ?? 0)"]
                vc.selectedPaymentType = .local
                vc.paypazUser = false
            }
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
extension ContactListVC : PopupDelegate{
    func isClickedButton(){
        for vc in self.navigationController?.viewControllers ?? [] {
            if let home = vc as? HomeVC {
                self.navigationController?.popToViewController(home, animated: true)
                break
            }
        }
    }
}

