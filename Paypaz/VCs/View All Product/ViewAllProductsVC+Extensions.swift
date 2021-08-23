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
        cell.img_ProductPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
        cell.lbl_ProductName.text = products[indexPath.row].name
        cell.lbl_ProductPrice.text = products[indexPath.row].price
        cell.lbl_ProductDescription.text = products[indexPath.row].datumDescription
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
        cell.btn_Delete.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        return cell
    }
    @objc func editButtonClicked(_ sender:UIButton)
    {
        print("edit button clicked")
    }
    @objc func deleteButtonClicked(_ sender:UIButton)
    {
        print("delete button clicked")
    }
}
extension ViewAllProductsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushToVC("ProductDetailVC") as? ProductDetailVC
        {
            vc.productID = self.products[indexPath.row].id ?? ""
            vc.eventID = self.eventID
            vc.delegate = self
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
            self.products = data.data ?? []
            DispatchQueue.main.async {
                self.tableView_Products.reloadData()
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
            self.products = []
            DispatchQueue.main.async {
                self.tableView_Products.reloadData()
            }
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
            //self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
extension ViewAllProductsVC : PopupDelegate
{
    func isClickedButton() {
        Connection.svprogressHudShow(view: self)
        getAllProducts()
    }
}
