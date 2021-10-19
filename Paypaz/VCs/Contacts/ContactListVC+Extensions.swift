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
        
        //        if self.isLocalContactSelected ?? true {
        //            if let req_payAmountVC = self.pushToVC("RequestPayAmountVC") as? RequestPayAmountVC {
        //                req_payAmountVC.selectedPaymentType = .local
        //            }
        //        } else {
        //            if let req_payAmountVC = self.pushToVC("RequestPayAmountVC") as? RequestPayAmountVC {
        //                req_payAmountVC.selectedPaymentType = .global
        //            }
        //        }
        
//        self.navigationController?.popViewController(animated: true)
//        self.delegate?.isSelectedContact(for: self.isRequestingMoney ?? false)
        self.view.endEditing(true)
        guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
            return
        }
        do {
        let numberProto: NBPhoneNumber = try phoneUtil.parse(filteredContactDetails[indexPath.row].phoneNumber ?? "", defaultRegion: "IN")
        let phoneCode = numberProto.countryCode!
        let phoneNumber = numberProto.nationalNumber!
            Connection.svprogressHudShow(view: self)
            dataSource.phoneNumber = "\(phoneNumber)"
            dataSource.phoneCode = "\(phoneCode)"
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
            if let paymentOption = self.paymentOption{
                switch paymentOption {
                case .Request:
                    if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                        popup.delegate = self
                        popup.selectedPopupType = .PaymentRequestSent
                    }
                default:
                    _ = self.pushVC("EnterPinVC")
                }
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

