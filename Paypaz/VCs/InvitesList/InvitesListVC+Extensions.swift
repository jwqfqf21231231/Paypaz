//
//  InvitesListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

extension InvitesListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell")  as? InviteCell
        else { return InviteCell() }
        cell.txt_message.text = invitesList[indexPath.row].message
        let  url = APIList().getUrlString(url: .USERIMAGE)
        cell.img_InviteePic.sd_setImage(with: URL(string: url+(invitesList[indexPath.row].userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
        cell.btn_accept.addTarget(self, action: #selector(btn_accept(_:)), for: .touchUpInside)
        cell.btn_reject.addTarget(self, action: #selector(btn_reject(_:)), for: .touchUpInside)
        var sendDateString = invitesList[indexPath.row].createdDate ?? ""
        sendDateString = sendDateString.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm:ss")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let convertedStringToDate = dateformatter.date(from: sendDateString)?.toLocalTime()
        let timeBefore = (Date().toLocalTime()).timeAgo(from: convertedStringToDate ?? Date())
        cell.lbl_Time.text = timeBefore
        cell.btn_accept.tag = indexPath.row
        cell.btn_reject.tag = indexPath.row
        cell.setCellData()
        return cell
    }
    
    
    @objc func btn_accept(_ sender:UIButton) {
        if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
            popup.acceptOrRejectDelegate = self
            popup.inviteID = invitesList[sender.tag].id ?? ""
            popup.selectedPopupType = .InviteAccept
        }
    }
    
    @objc func btn_reject(_ sender:UIButton) {
        if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
            popup.acceptOrRejectDelegate = self
            popup.inviteID = invitesList[sender.tag].id ?? ""
            popup.selectedPopupType = .InviteReject
        }
    }
}

extension InvitesListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // _ = self.pushToVC("EventDetailVC")
        
    }
}
extension InvitesListVC : AcceptOrRejectInviteDelegate {
    func acceptOrReject(inviteID: String) {
        if let index = invitesList.firstIndex(where: { (abc) -> Bool in
            return abc.id == inviteID
        }){
            invitesList.remove(at: index)
            tableView_Invites.reloadData()
            if invitesList.count <= 5{
                Connection.svprogressHudShow(view: self)
                dataSource.pageNo = "\(currentPage)"
                currentPage = currentPage + 1
                dataSource.getInvitees()
            }
        }
    }
        //self.navigationController?.popViewController(animated: true)
}
extension InvitesListVC : InvitesListDataModelDelegate
{
    func didRecieveDataUpdate(data: InvitesListModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if currentPage-1 != 0{
                self.newInvitesList = data.data ?? []
                self.invitesList.append(contentsOf: self.newInvitesList)
            }
            else{
                self.invitesList = data.data ?? []
            }
            DispatchQueue.main.async {
                self.tableView_Invites.reloadData()
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
                self.invitesList = []
                DispatchQueue.main.async {
                    self.tableView_Invites.reloadData()
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
