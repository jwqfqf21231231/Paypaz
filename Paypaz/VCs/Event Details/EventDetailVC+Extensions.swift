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
            return 5
        } else {
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 10
        {
            if indexPath.row == 4 {
                guard let more_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePeopleCell", for: indexPath) as? MorePeopleCell
                else { return MorePeopleCell() }
                return more_cell
            }
            else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell
                else { return ProductCell() }
                
                
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
            cell.lbl_ProductPrice.text = products[indexPath.row].price
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
        
        if collectionView.tag == 10  {
            if indexPath.row == 4 {
                if let _ = self.presentPopUpVC("InvitedPeopleVC", animated: false) as? InvitedPeopleVC {
                    
                }
            }else {
                _ = self.pushToVC("OtherUserProfileVC")
            }
            
        }  else if collectionView.tag != 10{
            if let vc = self.pushToVC("ProductDetailVC") as? ProductDetailVC
            {
                vc.productID = self.products[indexPath.row].id ?? ""
                vc.eventID = self.eventID
                vc.delegate = self
            }
        }
        
    }
}
extension EventDetailVC : PopupDelegate
{
    func isClickedButton() {
        Connection.svprogressHudShow(view: self)
        getProducts()
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
                let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                let imageString = (data.data?.image) ?? ""
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
                self.lbl_EventName.text = data.data?.name
                self.lbl_Price.text = data.data?.price
                self.lbl_EventDateTime.text = "\(data.data?.startDate ?? "") - \(data.data?.endDate ?? "")"
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
            self.showAlert(withMsg: data.message ?? "" , withOKbtn: true)
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
            // self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
