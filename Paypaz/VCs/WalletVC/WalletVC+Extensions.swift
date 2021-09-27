//
//  WalletVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

//MARK:-
extension WalletVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as? DrawerCell else { return DrawerCell() }
        return cell
    }
}

//MARK:-
extension WalletVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         _ = self.pushVC("TransactionDetailVC")
    }

}
extension WalletVC : GetWalletAmountDelegate
{
    func didRecieveDataUpdate(data: GetWalletAmount)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.lbl_TotalBalance.text = "$\(data.data?.amount ?? "")"
        }
        else
        {
            view.makeToast(data.message ?? "")
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

