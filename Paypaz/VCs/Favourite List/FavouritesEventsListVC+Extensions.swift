//
//  FavouritesEventsListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension FavouritesEventsListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell")  as? FavouriteCell
        else { return MyEventsCell() }
        cell.selectionStyle = .none
        cell.txt_EventName.text = favEvents[indexPath.row].name
        var sDate = favEvents[indexPath.row].startDate ?? ""
        sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        
        let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
        let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm:a")
        
        cell.txt_EventDate.text = "\(startDate) At \(startTime)"
        cell.txt_Location.text = favEvents[indexPath.row].location
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        cell.img_EventPic.sd_setImage(with: URL(string: url+(favEvents[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "terms_img"))
        cell.btn_PeopleInvited.tag = indexPath.row
        cell.btn_PeopleInvited.addTarget(self, action: #selector(peopleInvited(_:)), for: .touchUpInside)
        cell.btn_ShareEvent.addTarget(self, action: #selector(shareEvent(_:)), for: .touchUpInside)
        return cell
    }
    @objc func peopleInvited(_ sender:UIButton){
        if favEvents[sender.tag].isinviteMember == "0"{
            self.showAlert(withMsg: "No Invitees", withOKbtn: true)
        }
        else{

            Connection.svprogressHudShow(view: self)
            contactsDataSource.eventID = self.favEvents[sender.tag].id ?? ""
            contactsDataSource.getContacts()
        }
    }
    @objc func shareEvent(_ sender:UIButton){
        postshareLink(profile_URL: "The text that i want to share")
    }
}

extension FavouritesEventsListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushVC("EventDetailVC") as? EventDetailVC
        {
            vc.eventID = favEvents[indexPath.row].id ?? ""
        }
    }
}

extension FavouritesEventsListVC : MyPostedContactsDataModelDelegate
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

extension FavouritesEventsListVC : FavouritesListDataModelDelegate
{
    func didRecieveDataUpdate(data: MyEventsListModel)
    {
        print("FavEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if currentPage-1 != 0{
                self.newFavEvents = data.data ?? []
                self.favEvents.append(contentsOf: self.newFavEvents)
            }
            else{
                self.favEvents = data.data ?? []
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
                self.view.makeToast(data.message ?? "", duration: 3, position: .center)
                self.favEvents = []
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


