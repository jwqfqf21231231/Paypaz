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
        cell.userImage.sd_setImage(with: URL(string: url+(self.transactions?[indexPath.row].userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
        cell.userNameLabel.text = (self.transactions?[indexPath.row].firstName ?? "") + " " + (self.transactions?[indexPath.row].lastName ?? "")
        if self.transactions?[indexPath.row].isCredited == "0"{
            if self.transactions?[indexPath.row].status == "0"{
                if self.transactions?[indexPath.row].orderID != "0"{
                    let info = "\"\(self.transactions?[indexPath.row].firstName ?? "")\" Purchased Tickets For Your Event \"\(self.transactions?[indexPath.row].name ?? "")\""
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                    attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].firstName ?? "")\"", fontSize : 13)
                    attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].name ?? "")\"", fontSize : 13)
                    cell.descriptionLabel.attributedText = attributedString
                }
                else if self.transactions?[indexPath.row].requestID != "0"{
                    if self.transactions?[indexPath.row].type == "1"{
                        let info = "\"\(self.transactions?[indexPath.row].firstName ?? "")\" Sent Money To You"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                        attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].firstName ?? "")\"", fontSize : 13)
                        cell.descriptionLabel.attributedText = attributedString
                    }
                    else{
                        let info = "\"\(self.transactions?[indexPath.row].firstName ?? "")\" Sent Money To Your Money Request"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                        attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].firstName ?? "")\"", fontSize : 13)
                        cell.descriptionLabel.attributedText = attributedString
                    }
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
                    let info = "You Bought Event \"\(self.transactions?[indexPath.row].name ?? "")\" Tickets"
                    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                    attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].name ?? "")\"", fontSize : 13)
                    cell.descriptionLabel.attributedText = attributedString
                }
                else if self.transactions?[indexPath.row].requestID != "0"{
                    if self.transactions?[indexPath.row].type == "1"{
                        let info = "You Transferred Money To \"\(self.transactions?[indexPath.row].firstName ?? "")\""
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                        attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].firstName ?? "")\"", fontSize : 13)
                        cell.descriptionLabel.attributedText = attributedString
                    }
                    else{
                        let info = "You Sent Money To \"\(self.transactions?[indexPath.row].firstName ?? "")\" Money Request"
                        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: info)
                        attributedString.setBoldColor(color: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1), forText: "\"\(self.transactions?[indexPath.row].firstName ?? "")\"", fontSize : 13)
                        cell.descriptionLabel.attributedText = attributedString
                    }
                }
            }
            cell.amountLabel.text = "- $\(Float(self.transactions?[indexPath.row].amount ?? "")?.clean ?? "")"
            cell.amountLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
            cell.creditLabel.text = "Debit"
            cell.creditLabel.textColor = UIColor(red: 239/255, green: 67/255, blue: 67/255, alpha: 1)
        }
        return cell
    }
}


extension WalletVC : GetWalletAmountDelegate
{
    func didRecieveDataUpdate(data: GetWalletAmount)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.lbl_TotalBalance.text = "$ \(Float(data.data?.amount ?? "")?.clean ?? "")"
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                view.makeToast(data.message ?? "")
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
            self.tableViewTransactions.reloadArticleData{}
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else  if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                if data.message == "Data not found" && currentPage-1 >= 1{
                    print("No data at page No : \(currentPage-1)")
                    currentPage = currentPage-1
                }
                else if data.message == "Data not found" && currentPage-1 == 0{
                    self.transactions = []
                    transactionsView.alpha = 1
                }
                self.tableViewTransactions.reloadArticleData{}
            }
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
