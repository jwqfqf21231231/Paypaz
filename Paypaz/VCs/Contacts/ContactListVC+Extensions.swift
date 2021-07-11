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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell")  as? DrawerCell
            else { return DrawerCell() }
        
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


