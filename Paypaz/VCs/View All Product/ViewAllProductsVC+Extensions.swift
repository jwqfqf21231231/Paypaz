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
        cell.btn_Edit.tag = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Edit.addTarget(self, action: #selector(editButtonClicked(_:)), for: .touchUpInside)
        cell.btn_Delete.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        return cell
    }
    @objc func editButtonClicked(_ sender:UIButton)
    {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as? AddProductVC
        else { return  }
        vc.modalPresentationStyle = .overCurrentContext
        vc.isEdit = true
        vc.productID = products[sender.tag].id ?? ""
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
        print("edit button clicked")
    }
    @objc func deleteButtonClicked(_ sender:UIButton)
    {
        Connection.svprogressHudShow(view: self)
        self.deletedProductId = self.products[sender.tag].id ?? ""
        dataSource1.productID = self.products[sender.tag].id ?? ""
        dataSource1.eventID = self.products[sender.tag].eventID ?? ""
        dataSource1.type = "1"
        dataSource1.deleteProduct()
    }
}
extension ViewAllProductsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.pushToVC("ProductDetailVC") as? ProductDetailVC
        {
            vc.productID = self.products[indexPath.row].id ?? ""
            vc.eventID = self.products[indexPath.row].eventID ?? ""
            vc.eventName = self.eventName 
            vc.updatedProductDelegate = self
        }
    }
}
extension ViewAllProductsVC : AddProductDelegate
{
    func isAddedProduct(data: MyProducts?, productId: String) {
        if let index = products.firstIndex(where: { (abc) -> Bool in
            return abc.id == productId
        }){
            if let productData = data{
                self.products[index] = productData
                self.tableView_Products.reloadData()
            }
        }
    }
}
extension ViewAllProductsVC : DeleteProductDataModelDelegate
{
    func didRecieveDataUpdate(data: SuccessModel)
    {
        print("DeleteProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if let index = products.firstIndex(where: { (abc) -> Bool in
                return abc.id == self.deletedProductId
            }){
                self.products.remove(at: index)
                self.tableView_Products.reloadData()
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
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
            if currentPage-1 != 0{
                self.newProducts = data.data ?? []
                self.products.append(contentsOf: self.newProducts)
            }
            else{
                self.products = data.data ?? []
            }
            DispatchQueue.main.async {
                self.tableView_Products.reloadData()
            }
            
        }
        else
        {
            
            if data.message == "Data not found" && currentPage-1 >= 1{
                print("No data at page No : \(currentPage-1)")
                currentPage = currentPage-1
            }
            else if data.message == "Data not found" && currentPage-1 == 0{
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
extension ViewAllProductsVC : UpdatedProductDelegate{
    
    func isUpdatedProduct(data: MyProducts?, productId: String, isEdited: Bool?, isDeleted: Bool?) {
        if isEdited ?? false{
            if let index = products.firstIndex(where: { (abc) -> Bool in
                return abc.id == productId
            }){
                if let productData = data{
                    self.products[index] = productData
                    self.tableView_Products.reloadData()
                }
            }
        }
        if isDeleted ?? false{
            if let index = products.firstIndex(where: { (abc) -> Bool in
                return abc.id == productId
            }){
                self.products.remove(at: index)
                self.tableView_Products.reloadData()
            }
            
        }
    }
}
