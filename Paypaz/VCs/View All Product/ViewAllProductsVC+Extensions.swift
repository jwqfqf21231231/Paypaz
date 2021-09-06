//
//  ViewAllProductsVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension ViewAllProductsVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllProductsCell")  as? AllProductsCell
        else { return AllProductsCell() }
        let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
        let imageString = products[indexPath.row].image ?? ""
        cell.img_ProductPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"), options: .highPriority, context: nil)
        cell.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
        cell.lbl_ProductName.text = products[indexPath.row].name
        if products[indexPath.row].isPaid == "0"{
            cell.lbl_ProductPrice.text = "Free"
        }
        else{
            cell.lbl_ProductPrice.text = "$\((products[indexPath.row].price! as NSString).integerValue)"
        }
        cell.lbl_ProductDescription.text = products[indexPath.row].dataDescription
        return cell
    }
}
extension ViewAllProductsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushToVC("ProductDetailVC") as? ProductDetailVC
        {
            vc.productID = self.products[indexPath.row].id ?? ""
            vc.eventID = self.products[indexPath.row].eventID ?? ""
            vc.eventName = self.eventName 
        }
    }
}



extension ViewAllProductsVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let normalString = NSMutableAttributedString(string: "All Products From ")
            let attributedString = NSMutableAttributedString(string:"\"\(self.eventName) Event\"", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
            normalString.append(attributedString)
            self.lbl_EventName.attributedText = normalString
            
            self.products = data.data ?? []
            
            DispatchQueue.main.async {
                self.tableView_Products.reloadData()
            }
        }
        else
        {
            if data.message == "Data not found"{
                view.makeToast(data.message ?? "", duration: 3, position: .center)
                self.lbl_EventName.text?.removeAll()
                self.products = []
                DispatchQueue.main.async {
                    self.tableView_Products.reloadData()
                }
            }
            else{
                view.makeToast(data.message ?? "", duration: 3, position: .center)
            }
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
                self.tableView_Products.reloadData()
            }
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}
