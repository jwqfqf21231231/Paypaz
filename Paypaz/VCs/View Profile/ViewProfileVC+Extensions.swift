//
//  ViewProfileVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 26/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

//MARK:- --- Table View Delegate
extension ViewProfileVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushVC("MyPostedEventDetailsVC") as? MyPostedEventDetailsVC
        {
            vc.eventID = events[indexPath.row].id ?? ""
            vc.btn_EditHidden = true
        }
    }
    
}
//MARK:- --- Table View DataSource
extension ViewProfileVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell") as? MyEventsCell else { return MyEventsCell() }
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
        return cell
    }
    @objc func moreOptionsClicked(_ sender : UIButton){
        postshareLink(profile_URL: "The text that i want to share")
    }
}

//MARK:- --- Events List Data
extension ViewProfileVC : MyEventsListDataModelDelegate
{
    func didRecieveDataUpdate(data: MyEventsListModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.events = data.data ?? []
            DispatchQueue.main.async {
                self.tableViewEvents.reloadData()
            }
        }
        else
        {
            if data.message == "Data not found" {
                self.events = []
                self.tableViewEvents.reloadData()
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
//MARK:- --- User Details Data ---
extension ViewProfileVC : UserDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: UserDetailsModel)
    {
        print("UserDetailsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                let url =  APIList().getUrlString(url: .USERIMAGE)
                self.img_ProfilePic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_ProfilePic.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
                let fullName = (data.data?.firstName ?? "")+" "+(data.data?.lastName ?? "")
                self.lbl_ProfileName.text = fullName
                self.lbl_DOB.text = data.data?.dob
                self.lbl_PhoneNo.text = UserDefaults.standard.getPhoneCode() + " " + (data.data?.phoneNumber ?? "")
                self.lbl_Address.text = data.data?.state ?? ""
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
