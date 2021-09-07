//
//  NotificationListV+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

extension NotificationsListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else { return NotificationCell() }
        cell.img_UserPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .USERIMAGE)
        cell.img_UserPic.sd_setImage(with: URL(string: url+(notifications[indexPath.row].userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
        cell.lbl_Message.text = notifications[indexPath.row].message
        return cell
    }
}

extension NotificationsListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // _ = self.pushToVC("HomeEventDetailVC")
    }
    
}
extension NotificationsListVC : NotificationListDataModelDelegate
{
    func didRecieveDataUpdate(data: InvitesListModel)
    {
        print("NotificationModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if currentPage-1 != 0{
                self.newNotifications = data.data ?? []
                self.notifications.append(contentsOf: self.newNotifications)
            }
            else{
                self.notifications = data.data ?? []
            }
            DispatchQueue.main.async {
                self.tableViewNotifications.reloadData()
            }
        }
        else
        {
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                self.notifications = []
                DispatchQueue.main.async {
                    self.tableViewNotifications.reloadData()
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

