//
//  EventDetailVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension EventDetailVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 10 {
            if self.contacts.count > 5{
                return 6
            }
            else{
                return contacts.count
            }
        }
        else{
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 10
        {
            if indexPath.row == 5 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePeopleCell", for: indexPath) as? MorePeopleCell
                else { return MorePeopleCell() }
                let num = contacts.count - 5
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "+\(num) \nMore")
                attributedString.setColor(color: .white, forText: "More", fontSize: 9)
                cell.lbl_Count.numberOfLines = 0
                cell.lbl_Count.lineBreakMode = .byWordWrapping
                cell.lbl_Count.attributedText = attributedString
                return cell
            }
            else {
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
                cell.lbl_ProductPrice.text = "$\(((products[indexPath.row].price!) as NSString).integerValue)"
            }
            return cell
        }
    }
    
    
}
extension EventDetailVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        if collectionView.tag == 10
        {
            if indexPath.row == 5
            {
                if let vc = self.presentPopUpVC("InvitedPeopleVC", animated: false) as? InvitedPeopleVC{
                    var contacts = self.contacts
                    contacts.removeFirst(5)
                    vc.contacts = contacts
                }
            }
        }
        else{
            if let vc = self.pushVC("ProductDetailVC") as? ProductDetailVC
            {
                vc.eventName = self.eventDetails?.name ?? ""
                vc.productID = self.products[indexPath.row].id ?? ""
            }
        }
    }
}
extension EventDetailVC : MyPostedEventDataModelDelegate
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
                let imageString = (data.data?.image) ?? ""
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
                self.btn_Category.setTitle(data.data?.typeName, for: .normal)
                self.lbl_EventName.text = data.data?.name
                if data.data?.paymentType ?? "" == "2"{
                    self.lbl_Price.text = "Free"
                }
                else{
                    self.lbl_Price.text = "$\(Float(data.data?.price ?? "")?.clean ?? "")"
                }
                self.lbl_Description.text = data.data?.dataDescription
                self.lbl_HostName.text = (data.data?.firstName ?? "") + " " + (data.data?.lastName ?? "")
                self.img_HostPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                url =  APIList().getUrlString(url: .USERIMAGE)
                self.img_HostPic.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "place_holder"))
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

extension EventDetailVC : MyPostedProductsDataModelDelegate
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
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}
extension EventDetailVC : MyPostedContactsDataModelDelegate
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
            view_InviteeHeight.constant = 113
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
