//
//  MyTicketDetailVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

extension MyTicketDetailVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ticketProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else{return ProductCell()}
        cell.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
        cell.img_ProductPic.sd_setImage(with: URL(string: url+(ticketProducts?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "ticket_img"))
        cell.lbl_ProductName.text = ticketProducts?[indexPath.row].name ?? ""
        cell.lbl_ProductPrice.text = ticketProducts?[indexPath.row].productPrice ?? ""
        return cell
    }
    
    
}
extension MyTicketDetailVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width  = UIScreen.main.bounds.size.width * 0.5
        return CGSize(width: width, height: height)
    }
    
}
extension MyTicketDetailVC : TicketDetailsDelegate
{
    func didRecieveDataUpdate(data: TicketDetailsModel)
    {
        print("UserTicketsData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.eventImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
            self.eventImage.sd_setImage(with: URL(string: url+(data.data?.image ?? "")), placeholderImage: UIImage(named: "ticket_img"))
            self.eventNameLabel.text = data.data?.name ?? ""
            self.categoryButton.setTitle("\(data.data?.typeName ?? "")", for: .normal)
            self.eventDescriptionLabel.text = data.data?.dataDescription ?? ""
            self.ticketPriceLabel.text = "$\(data.data?.price ?? "")"
            self.orderNumberLabel.text = data.data?.orderNumber ?? ""
            var eDate = data.data?.endDate ?? ""
            eDate = eDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
            let endDate = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd-MMM-yyyy")
            self.endDateLabel.text = endDate
            self.ticketProducts = data.data?.products ?? []
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