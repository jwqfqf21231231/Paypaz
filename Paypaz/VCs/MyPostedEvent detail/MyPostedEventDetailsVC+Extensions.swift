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
            return self.contacts.count
        } else {
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 10 {
            if indexPath.row == 4 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePeopleCell", for: indexPath) as? MorePeopleCell
                else { return MorePeopleCell() }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
                else { return ProductCell() }
                
                
                return cell
            }
            
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
            else { return ProductCell() }
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = products[indexPath.row].image ?? ""
            cell.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
            cell.lbl_ProductName.text = products[indexPath.row].name
            cell.lbl_ProductPrice.text = "$ \(((products[indexPath.row].price!) as NSString).integerValue)"
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
                _ = self.presentPopUpVC("InvitedPeopleVC", animated: true)
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
                let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                let imageString = (data.data?.image) ?? ""
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
                self.btn_Category.setTitle(data.data?.typeName, for: .normal)
                self.lbl_EventName.text = data.data?.name
                self.lbl_Price.text = "$ \(((data.data?.price!)! as NSString).integerValue)"
                self.lbl_Description.text = data.data?.dataDescription
                
                let sDate = self.getFormattedDate(strDate: data.data?.startDate ?? "", currentFomat: "yyyy-MM-dd HH:mm:ss", expectedFromat: "dd MMM yyyy")
                var sTime = self.getFormattedDate(strDate: data.data?.startDate ?? "", currentFomat: "yyyy-MM-dd HH:mm:ss", expectedFromat: "HH:mm:ss")
                sTime = sTime.UTCToLocal(incomingFormat: "HH:mm:ss", outGoingFormat: "hh:mm a")
                
                let eDate = self.getFormattedDate(strDate: data.data?.endDate ?? "", currentFomat: "yyyy-MM-dd HH:mm:ss", expectedFromat: "dd MMM yyyy")
                var eTime = self.getFormattedDate(strDate: data.data?.endDate ?? "", currentFomat: "yyyy-MM-dd HH:mm:ss", expectedFromat: "HH:mm:ss")
                eTime = eTime.UTCToLocal(incomingFormat: "HH:mm:ss", outGoingFormat: "hh:mm a")
                
                self.lbl_EventDateTime.text = "\(sDate) At \(sTime) To \(eDate) At \(eTime)"
                self.lbl_EventLocation.text = data.data?.location
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
            print(data.message ?? "")
        }
        if self.products.count == 0
        {
            self.view_Product.isHidden = true
            self.view_ProductHeight.constant = 0
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
    func didRecieveDataUpdate(data: MyPostedContactsModel)
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
