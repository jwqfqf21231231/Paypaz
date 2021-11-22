//
//  MyPostedEventDetailsVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension MyPostedEventDetailsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 10 {
            if self.contacts.count > 4{
                return 5
            }
            else{
                return contacts.count
            }
        } else {
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 10 {
            if indexPath.row == 4 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePeopleCell", for: indexPath) as? MorePeopleCell
                else { return MorePeopleCell() }
                let num = contacts.count - 4
                cell.lbl_Count.text = "+\(num)\n More"
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as? ContactCell
                else { return ContactCell() }
                let contactPic = contacts[indexPath.row].userProfile ?? ""
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .USERIMAGE)
                cell.img_ContactPic.sd_setImage(with: URL(string: url+(contactPic)), placeholderImage: UIImage(named: "place_holder"))
                return cell
            }
            
        }
        else
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
            else { return ProductCell() }
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = products[indexPath.row].image ?? ""
            cell.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
            cell.lbl_ProductName.text = products[indexPath.row].name
            if products[indexPath.row].isPaid == "0"{
                cell.lbl_ProductPrice.text = "Free"
            }
            else{
                cell.lbl_ProductPrice.text = "$\(Float(products[indexPath.row].price ?? "")?.clean ?? "")"
            }
            return cell
        }
    }
    
}
extension MyPostedEventDetailsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 10 {
            let height = collectionView.frame.size.height
            
            return CGSize(width: height, height: height)
        } else {
            let width = UIScreen.main.bounds.width
            
            return CGSize(width: width * 0.5, height: collectionView.frame.size.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 10 {
            if indexPath.row == 4 {
                var contacts = self.contacts
                contacts.removeFirst(4)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitedPeopleVC") as! InvitedPeopleVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.contacts = contacts
                vc.peopleInvited = true
                self.present(vc, animated: false,completion: nil)
            }
        }
    }
}
extension MyPostedEventDetailsVC : MyPostedEventDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedEventModel)
    {
        print("MyPostedEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.eventDetails = data.data
            
            DispatchQueue.main.async {
                var url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                var imageString = (data.data?.image) ?? ""
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
                url = APIList().getUrlString(url: .USERIMAGE)
                imageString = data.data?.userProfile ?? ""
                self.img_UserPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_UserPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "place_holder"))
                self.lbl_UserName.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
                self.btn_Category.setTitle(data.data?.typeName, for: .normal)
                self.lbl_EventName.text = data.data?.name
                if data.data?.paymentType ?? "" == "2"{
                    self.lbl_Price.text = "Free"
                }
                else{
                    self.lbl_Price.text = "$\(Float(data.data?.price ?? "")?.clean ?? "")"
                }
                self.lbl_Description.text = data.data?.dataDescription
                
                var sDate = data.data?.startDate ?? ""
                sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
                var eDate = data.data?.endDate ?? ""
                eDate = eDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
                let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
                let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm:a")
                
                
                let endDate = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
                let endTime = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
                
                self.lbl_EventDateTime.text = "\(startDate) At \(startTime) To \(endDate) At \(endTime)"
                self.lbl_EventLocation.text = data.data?.location
                self.isPublicStatus = data.data?.ispublic ?? ""
                self.isInviteMemberStatus = data.data?.isinviteMember ?? ""
                self.lbl_RegisteredCount.text = data.data?.registered ?? ""
                self.lbl_BuyCount.text = data.data?.buy ?? ""
            }
        }
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.unauthorized = true
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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

extension MyPostedEventDetailsVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.products = data.data ?? []
            DispatchQueue.main.async {
                self.collectionView_Products.reloadData()
            }
        }
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.unauthorized = true
                }
            }
            if data.message == "Data not found"{
                self.products.removeAll()
            }
            print(data.message ?? "")
        }
        if self.products.count == 0
        {
            self.view_Product.isHidden = true
            self.view_ProductHeight.constant = 0
        }
        else{
            self.view_Product.isHidden = false
            self.view_ProductHeight.constant = 129
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.products = []
            DispatchQueue.main.async {
                self.collectionView_Products.reloadData()
            }
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}
extension MyPostedEventDetailsVC : MyPostedContactsDataModelDelegate
{
    func didRecieveDataUpdate3(data: MyPostedContactsModel)
    {
        print("MyPostedContactsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.contacts = data.data ?? []
            DispatchQueue.main.async {
                self.collectionView_People.reloadData()
            }
        }
        else
        {
            if data.isAuthorized == 0{
                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.unauthorized = true
                }
            }
            else{
                print(data.message ?? "")
            }
        }
        if self.contacts.count == 0{
            view_Invitee.isHidden = true
            view_InviteeHeight.constant = 0
        }
        else{
            view_Invitee.isHidden = false
            view_InviteeHeight.constant = 102
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
extension MyPostedEventDetailsVC : MoreOptionsDelegate {
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
                vc.editEventProductsDelegate = self
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
extension MyPostedEventDetailsVC : EditEventDelegate
{
    func editEventData(data:MyEvent?, eventID: String) {
        self.getEvent()
    }
}
extension MyPostedEventDetailsVC : EditEventProductsDelegate
{
    func loadProductsData() {
        self.getProducts()
    }
}
extension MyPostedEventDetailsVC : EditInviteMemberDelegate
{
    func editInviteData(data:[String:String]?, eventID: String) {
        self.getInvitees()
        self.getEvent()
    }
}
extension MyPostedEventDetailsVC : DeleteEventDelegate
{
    func deleteEventData(eventID: String) {
        self.navigationController?.popViewController(animated: false)
        updateEventDelegate?.updateEventData(data: eventDetails, eventID: eventID, deleted: true)
    }
}
