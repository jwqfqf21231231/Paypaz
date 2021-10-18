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
        cell.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "place_holder"))
        cell.lbl_EventName.text = events[indexPath.row].name
        var sDate = events[indexPath.row].startDate ?? ""
        sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        
        let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
        let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
        
        cell.lbl_EventTime.text = "\(startDate) At \(startTime)"
        cell.lbl_EventAddress.text = events[indexPath.row].location
        cell.btn_More.tag = indexPath.row
        cell.btn_More.addTarget(self, action: #selector(moreOptionsClicked(_:)), for: .touchUpInside)
        /*if events[indexPath.row].isinviteMember == "0"{
         cell.btn_Height.constant = 0
         cell.btn_PeopleInvited.isHidden = true
         }
         else{
         cell.btn_Height.constant = 25
         cell.btn_PeopleInvited.isHidden = false*/
        cell.btn_PeopleInvited.tag = indexPath.row
        cell.btn_PeopleInvited.addTarget(self, action: #selector(peopleInvited(_:)), for: .touchUpInside)
        return cell
    }
    @objc func peopleInvited(_ sender:UIButton){
        if events[sender.tag].isinviteMember == "0"{
            self.showAlert(withMsg: "No Invitees", withOKbtn: true)
        }
        else{
            
            Connection.svprogressHudShow(view: self)
            contactsDataSource.eventID = self.events[sender.tag].id ?? ""
            contactsDataSource.getContacts()
        }
    }
    @objc func moreOptionsClicked(_ sender : UIButton){
        if let popup = self.presentPopUpVC("MoreOptionsPopupVC", animated: true) as? MoreOptionsPopupVC {
            popup.eventID = events[sender.tag].id ?? ""
            popup.isPublic = events[sender.tag].ispublic ?? ""
            popup.isInvitedMember = events[sender.tag].isinviteMember ?? ""
            popup.delegate = self
        }
    }
}
extension MyEventsListVC : UpdateEventDelegate{
    func updateEventData(data : MyEvent?,eventID : String,deleted : Bool?){
        if deleted ?? false{
            if let index = events.firstIndex(where: { (abc) -> Bool in
                return abc.id == eventID
            }){
                self.events.remove(at: index)
                self.tableView_Events.reloadData()
            }
        }
        else{
            if let index = events.firstIndex(where: { (abc) -> Bool in
                return abc.id == eventID
            }){
                if let data = data{
                    self.events[index] = data
                    self.tableView_Events.reloadData()
                }
            }
        }
    }
}
extension MyEventsListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushVC("MyPostedEventDetailsVC") as? MyPostedEventDetailsVC
        {
            vc.updateEventDelegate = self
            vc.eventID = events[indexPath.row].id ?? ""
        }
    }
}
extension MyEventsListVC : MoreOptionsDelegate {
    func hasSelectedOption(type: OptionType,eventID:String,isPublic:String,isInvitedMember:String) {
        if type == .edit_Event{
            if let vc = self.pushVC("HostEventVC") as? HostEventVC
            {
                vc.eventID = eventID
                vc.isEdit = true
                vc.editEventDelegate = self
            }
        }
        else if type == .edit_EventProducts{
            if let vc = self.pushVC("AddEventProductsVC") as? AddEventProductsVC{
                vc.isEdit = true
                vc.eventID = eventID
            }
        }
        else if type == .edit_InvitedMembers{
            if let vc = self.pushVC("InviteMembersVC") as? InviteMembersVC{
                vc.isEdit = true
                vc.eventID = eventID
                vc.isPublicStatus = isPublic
                vc.isInviteMemberStatus = isInvitedMember
                vc.editInviteMemberDelegate = self
            }
            print("Invited Members for an event")
        }
        else if type == .delete_Event {
            if let deletePopup = self.presentPopUpVC("DeleteEventPopupVC", animated: false) as? DeleteEventPopupVC {
                deletePopup.selectedPopupType = .DeleteEvent
                deletePopup.eventID = eventID
                deletePopup.updateEventDelegate = self
            }
        }
        else{
            postshareLink(profile_URL: "The text that i want to share")
        }
    }
}
extension MyEventsListVC : EditInviteMemberDelegate
{
    func editInviteData(data:[String:String]?, eventID: String) {
        if let index = events.firstIndex(where: { (abc) -> Bool in
            return abc.id == eventID
        }){
            if let data = data{
                self.events[index].ispublic = data["isPublic"]
                self.events[index].isinviteMember = data["isInviteMember"]
                self.tableView_Events.reloadData()
            }
        }
    }
}
extension MyEventsListVC : EditEventDelegate
{
    func editEventData(data:MyEvent?, eventID: String) {
        if let index = events.firstIndex(where: { (abc) -> Bool in
            return abc.id == eventID
        }){
            if let data = data{
                self.events[index] = data
                self.tableView_Events.reloadData()
            }
        }
    }
}
extension MyEventsListVC : DeleteEventDelegate
{
    func deleteEventData(eventID: String) {
        if let index = events.firstIndex(where: { (abc) -> Bool in
            return abc.id == eventID
        }){
            self.events.remove(at: index)
            self.tableView_Events.reloadData()
        }
    }
}
extension MyEventsListVC : MyEventsListDataModelDelegate
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
            noDataFoundView.alpha = 1
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
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
extension MyEventsListVC : MyPostedContactsDataModelDelegate
{
    func didRecieveDataUpdate3(data: MyPostedContactsModel)
    {
        print("MyPostedContactsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitedPeopleVC") as! InvitedPeopleVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.contacts = data.data ?? []
            vc.peopleInvited = true
            self.present(vc, animated: false,completion: nil)
        }
        else
        {
            print(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}
