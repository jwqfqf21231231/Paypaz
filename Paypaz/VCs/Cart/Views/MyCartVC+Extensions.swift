//
//  MyCartVC+Extensions.swift
//  Paypaz
//
//  Created by MAC on 23/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage

extension MyCartVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell") as? MyEventsCell else{return MyEventsCell()}
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        let imageString = Items[indexPath.row].image ?? ""
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
        cell.lbl_EventName.text = Items[indexPath.row].name
        var sDate = Items[indexPath.row].addedDate ?? ""
        sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
        let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
        cell.lbl_EventTime.text = startDate
        cell.lbl_EventAddress.text = Items[indexPath.row].location
        return cell
    }
}
extension MyCartVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushVC("AddToCartVC") as? AddToCartVC{
            vc.cartID = Items[indexPath.row].id ?? ""
            vc.addToCart = false
        }
    }
}
extension MyCartVC : GetCartItemsDataModelDelegate{
    func didRecieveDataUpdate(data: CartItemsModel) {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.Items = data.data ?? []
            tableView_Items.reloadData()
        }
        else
        {
            view.makeToast(data.message ?? "")
        }
    }
    
    func didFailDataUpdateWithError2(error: Error) {
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
