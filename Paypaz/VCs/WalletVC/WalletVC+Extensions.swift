//
//  WalletVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

extension WalletVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell") as? TransactionsCell else { return TransactionsCell() }
        let url =  APIList().getUrlString(url: .USERIMAGE)
        cell.userImage.sd_setImage(with: URL(string: url+(transactions?[indexPath.row].userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
        cell.userNameLabel.text = (transactions?[indexPath.row].firstName ?? "") + " " + (transactions?[indexPath.row].lastName ?? "")
        DispatchQueue.main.async {
            if self.transactions?[indexPath.row].isCredited == "0"{
                if self.transactions?[indexPath.row].status == "0"{
                    if self.transactions?[indexPath.row].orderID != "0"{
                        cell.descriptionLabel.text = "\(self.transactions?[indexPath.row].firstName ?? "") Purchased Tickets For Your Event \(self.transactions?[indexPath.row].name ?? "")"
                    }
                    else if self.transactions?[indexPath.row].requestID != "0"{
                        if self.transactions?[indexPath.row].type == "1"{
                            
                        }
                        else{
                            
                        }
                        cell.descriptionLabel.text = "\(self.transactions?[indexPath.row].firstName ?? "") Purchased Tickets For Your Event \(self.transactions?[indexPath.row].name ?? "")"
                    }
                }
                else if self.transactions?[indexPath.row].status == "1"{
                    
                }
                else if self.transactions?[indexPath.row].status == "2"{
                    
                }
                cell.amountLabel.text = "+ $\(Float(self.transactions?[indexPath.row].amount ?? "")?.clean ?? "")"
                cell.amountLabel.textColor = UIColor(named: "GreenColor")
                cell.creditLabel.text = "Credit"
                cell.creditLabel.textColor = UIColor(named: "GreenColor")
            }
            else{
                if self.transactions?[indexPath.row].status == "3"{
                    if self.transactions?[indexPath.row].orderID != "0"{
                        
                    }
                    else if self.transactions?[indexPath.row].requestID != "0"{
                        if self.transactions?[indexPath.row].type == "1"{
                            cell.descriptionLabel.text = "You Transferred Money To \(self.transactions?[indexPath.row].firstName ?? "")"
                        }
                        else{
                            
                        }
                        cell.descriptionLabel.text = "You Transferred Money To \(self.transactions?[indexPath.row].firstName ?? "")"
                    }
                    
                }
                cell.amountLabel.text = "- $\(Float(self.transactions?[indexPath.row].amount ?? "")?.clean ?? "")"
                cell.amountLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
                cell.creditLabel.text = "Debit"
                cell.creditLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
            }
        }
        return cell
    }
}

//MARK:- Extensions

extension WalletVC : UITableViewDelegate {
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     _ = self.pushVC("TransactionDetailVC")
     }
     */
}
extension WalletVC : GetWalletAmountDelegate
{
    func didRecieveDataUpdate(data: GetWalletAmount)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.lbl_TotalBalance.text = "$ \(data.data?.amount ?? "")"
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
            transactionsView.alpha = 0
            if currentPage-1 != 0{
                self.newTransactions = data.data ?? []
                self.transactions?.append(contentsOf: self.newTransactions)
            }
            else{
                self.transactions = data.data ?? []
            }
            tableViewTransactions.reloadData()

        }
        else
        {
            
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
                self.transactions = []
                transactionsView.alpha = 1
            }
            tableViewTransactions.reloadData()

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
