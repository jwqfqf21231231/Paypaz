//
//  InvitesListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

extension InvitesListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell")  as? InviteCell
            else { return InviteCell() }
        
        cell.btn_accept.addTarget(self, action: #selector(btn_accept(_:)), for: .touchUpInside)
        cell.btn_reject.addTarget(self, action: #selector(btn_reject(_:)), for: .touchUpInside)
       
        cell.setCellData()
          return cell
    }
    
    
    @objc func btn_accept(_ sender:UIButton) {
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                popup.delegate  = self
                popup.selectedPopupType = .InviteAccept
            }
        }
    
    @objc func btn_reject(_ sender:UIButton) {
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                popup.delegate  = self
                popup.selectedPopupType = .InviteReject
            }
        }
    }


extension InvitesListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // _ = self.pushToVC("EventDetailVC")
        
    }
}
//MARK:-
extension InvitesListVC : PopupDelegate {
    func isClickedButton() {
        //self.navigationController?.popViewController(animated: true)
    }
}
