//
//  MyTicketsVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension MyTicketsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TicketsCell")  as? TicketsCell
        else { return TicketsCell() }
        
        cell.lbl_EventName.text = tickets?[indexPath.row].name ?? ""
        cell.lbl_Description.text = tickets?[indexPath.row].datumDescription ?? ""
        cell.lbl_OrderNumber.text = tickets?[indexPath.row].orderNumber ?? ""
        var eDate = tickets?[indexPath.row].endDate ?? ""
        eDate = eDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        let endDate = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
        let endTime = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
        cell.lbl_EndDate.text = endDate + " At " + endTime
        
        return cell
    }
}
extension MyTicketsVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = self.pushVC("MyTicketDetailVC") as? MyTicketDetailVC{
            vc.orderID = tickets?[indexPath.row].id ?? ""
        }
    }
}
extension MyTicketsVC : UserTicketsDelegate
{
    func didRecieveDataUpdate(data: UserTicketsModel)
    {
        print("UserTicketsData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.noDataFoundView.alpha = 0
            if currentPage-1 != 0{
                self.newTickets = data.data ?? []
                self.tickets?.append(contentsOf: self.newTickets ?? [])
            }
            else{
                self.tickets = data.data ?? []
            }
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
                if data.message == "Data not found" && currentPage-1 >= 1{
                    print("No data at page No : \(currentPage-1)")
                    currentPage = currentPage-1
                }
                else if data.message == "Data not found" && currentPage-1 == 0{
                    self.noDataFoundView.alpha = 1
                    self.tickets = []
                }
                else{
                    self.noDataFoundView.alpha = 1
                }
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
