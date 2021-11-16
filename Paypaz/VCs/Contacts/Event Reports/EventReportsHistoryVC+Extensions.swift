//
//  EventReportsVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 04/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import UIKit
import SDWebImage
extension EventReportsHistoryVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell")  as? MyEventsCell
            else { return MyEventsCell() }
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        let imageString = (events[indexPath.row].image ?? "").trimmingCharacters(in: .whitespaces)
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "place_holder"))
        cell.lbl_EventName.text = events[indexPath.row].name
        var sDate = events[indexPath.row].startDate ?? ""
        sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        
        let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
        let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
        
        cell.lbl_EventTime.text = "\(startDate) At \(startTime)"
        return cell
    }
}
extension EventReportsHistoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let vc = self.pushVC("EventReportVC") as? EventReportVC{
            let eventInfo = ["eventName" : events[indexPath.row].name ?? "","eventID" : events[indexPath.row].id ?? ""]
            vc.eventInfo = eventInfo
        }
    }
}

extension EventReportsHistoryVC : MyEventsListDataModelDelegate
{
    func didRecieveDataUpdate(data: MyEventsListModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            noDataFoundView.alpha = 0
            if currentPage-1 != 0{
                self.newEventItems = data.data ?? []
                self.events.append(contentsOf: self.newEventItems)
            }
            else{
                self.events = data.data ?? []
            }
            DispatchQueue.main.async {
                self.tableView_Events.reloadData()
            }
        }
        else
        {
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
                noDataFoundView.alpha = 1
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                self.events = []
                DispatchQueue.main.async {
                    self.tableView_Events.reloadData()
                }
            }
            else{
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                
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
