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
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell") as? TransactionsCell else { return TransactionsCell() }
        
        if transactions?[indexPath.row].isCredited == "0"{
            cell.amountLabel.text = "+ $\(transactions?[indexPath.row].amount ?? "")"
            cell.amountLabel.textColor = UIColor(named: "GreenColor")
            cell.creditLabel.text = "Credit"
            cell.creditLabel.textColor = UIColor(named: "GreenColor")
        }
        else{
            cell.amountLabel.text = "- $\(transactions?[indexPath.row].amount ?? "")"
            cell.amountLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
            cell.creditLabel.text = "Debit"
            cell.creditLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
        }
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
            self.lbl_TotalBalance.text = "$ \(((data.data?.amount)! as NSString).integerValue)"
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
extension WalletVC : TransactionHistoryDelegate
{
    func didRecieveDataUpdate(data: TransactionHistoryModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.transactions = data.data ?? []
        }
        else
        {
            view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
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
