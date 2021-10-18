//
//  ContactListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

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

