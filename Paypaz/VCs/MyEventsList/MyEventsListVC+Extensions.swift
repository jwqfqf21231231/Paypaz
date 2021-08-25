//
//  MyEventsListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
import Toast_Swift
extension MyEventsListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell")  as? MyEventsCell
            else { return MyEventsCell() }
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        let imageString = (events[indexPath.row].image ?? "").trimmingCharacters(in: .whitespaces)
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "profile_c"))
        cell.lbl_EventName.text = events[indexPath.row].name
        cell.lbl_EventTime.text = events[indexPath.row].startDate
        cell.lbl_EventAddress.text = events[indexPath.row].location
        cell.btn_More.tag = indexPath.row
        cell.btn_More.addTarget(self, action: #selector(moreOptionsClicked(_:)), for: .touchUpInside)
          return cell
    }
    
    @objc func moreOptionsClicked(_ sender : UIButton){
        if let popup = self.presentPopUpVC("MoreOptionsPopupVC", animated: true) as? MoreOptionsPopupVC {
            popup.eventID = events[sender.tag].id ?? ""
            popup.delegate = self
        }
    }
}
extension MyEventsListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushToVC("MyPostedEventDetailsVC") as? MyPostedEventDetailsVC
        {
            vc.eventID = events[indexPath.row].id ?? ""
        }
    }
}

extension MyEventsListVC : PopupDelegate {
    func isClickedButton() {
        //Connection.svprogressHudShow(view: self)
        
        dataSource.getMyEvents()
    }
}

extension MyEventsListVC : MoreOptionsDelegate {
    func hasSelectedOption(type: OptionType,eventID:String) {
        if type == .delete {
            if let deletePopup = self.presentPopUpVC("DeleteEventPopupVC", animated: false) as? DeleteEventPopupVC {
                deletePopup.eventID = eventID
                deletePopup.delegate  = self
            }
        } else
        {
            if let vc = self.pushToVC("HostEventVC") as? HostEventVC
            {
                vc.eventID = eventID
                vc.isEdit = true
            }
        }
    }
}
extension MyEventsListVC : MyEventsListDataModelDelegate
{
    func didRecieveDataUpdate(data: MyEventsListModel)
    {
        //print("MyEventsListModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
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
            self.events = []
            DispatchQueue.main.async {
                self.tableView_Events.reloadData()
            }
            self.view.makeToast(data.message ?? "", duration: 3, position: .center)
           // self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
