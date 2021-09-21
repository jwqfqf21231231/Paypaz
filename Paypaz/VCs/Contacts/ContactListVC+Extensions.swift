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
        return contactDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell")  as? MemberCell
        else { return MemberCell() }
        cell.contactName_lbl.text = (contactDetails[indexPath.row].firstName ?? "") + " " + (contactDetails[indexPath.row].lastName ?? "")
        cell.contactNo_lbl.text = contactDetails[indexPath.row].phoneNumber
        cell.contactPic_img.image = contactDetails[indexPath.row].profilePic
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
        
        self.navigationController?.popViewController(animated: true)
        self.delegate?.isSelectedContact(for: self.isRequestingMoney ?? false)
    }
}


