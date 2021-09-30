//
//  MyCartVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 23/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension AddToCartVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addToCart ?? false{
            return products.count
        }
        else{
            return cartItemProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell")  as? ProductTableCell
        else { return ProductTableCell() }
        if addToCart ?? false{
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = products[indexPath.row].image ?? ""
            cell.img_Product.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img_Product.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
            cell.btn_AddProduct.tag = indexPath.row
            cell.btn_DeleteProduct.tag = indexPath.row
            cell.btn_AddProduct.addTarget(self, action: #selector(btn_AddProducts(_:)), for: .touchUpInside)
            cell.btn_DeleteProduct.addTarget(self, action: #selector(btn_RemoveProducts(_:)), for: .touchUpInside)
            if products[indexPath.row].isPaid == "0"{
                cell.lbl_Price.text = "Free"
            }
            else{
                cell.lbl_Price.text = "$\(((products[indexPath.row].price!) as NSString).integerValue)"
            }
            cell.lbl_ProductName.text = products[indexPath.row].name
        }
        else{
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = cartItemProducts[indexPath.row].image ?? ""
            cell.img_Product.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img_Product.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
            cell.btn_AddProduct.tag = indexPath.row
            cell.btn_DeleteProduct.tag = indexPath.row
            cell.btn_AddProduct.addTarget(self, action: #selector(btn_AddProducts(_:)), for: .touchUpInside)
            cell.btn_DeleteProduct.addTarget(self, action: #selector(btn_RemoveProducts(_:)), for: .touchUpInside)
            cell.lbl_ProductCount.text = "\((((cartItemProducts[indexPath.row].productQty ?? "") as NSString).integerValue))"
            let cartProductPrice = ((cartItemProducts[indexPath.row].productPrice ?? "") as NSString).integerValue
            if cartProductPrice < 1{
                cell.lbl_Price.text = "Free"
            }
            else{
                cell.lbl_Price.text = "$\(cartProductPrice)"
            }
            cell.lbl_ProductName.text = cartItemProducts[indexPath.row].name
        }
        return cell
    }
    
    @objc func btn_AddProducts(_ sender:UIButton){
        if addToCart ?? false{
            var productPrice = ((products[sender.tag].price!) as NSString).integerValue
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = ((cell.lbl_ProductCount.text!) as NSString).integerValue
                count = count + 1
                cell.lbl_ProductCount.text = "\(count)"
                productPrice = productPrice * count
                products[sender.tag].updatedProductPrice = productPrice
                calculateTotalProductPrice()
                productCollection(productData: products[sender.tag], count: count)
            }
        }
        else{
            var productPrice = ((cartItemProducts[sender.tag].productPrice!) as NSString).integerValue
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = ((cell.lbl_ProductCount.text!) as NSString).integerValue
                count = count + 1
                cell.lbl_ProductCount.text = "\(count)"
                productPrice = productPrice * count
                cartItemProducts[sender.tag].updatedProductPrice = productPrice
                calculateTotalProductPrice()
                productCollectionFromCart(productData: cartItemProducts[sender.tag], count: count)
            }
        }
        
    }
    @objc func btn_RemoveProducts(_ sender:UIButton){
        if addToCart ?? false{
            var productPrice = ((products[sender.tag].price!) as NSString).integerValue
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = ((cell.lbl_ProductCount.text!) as NSString).integerValue
                if count > 0{
                    count = count - 1
                    cell.lbl_ProductCount.text = "\(count)"
                    productPrice = productPrice * count
                    products[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                }
                productCollection(productData: products[sender.tag], count: count)
            }
        }
        else{
            var productPrice = ((cartItemProducts[sender.tag].productPrice!) as NSString).integerValue
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = ((cell.lbl_ProductCount.text!) as NSString).integerValue
                if count > 0{
                    count = count - 1
                    cell.lbl_ProductCount.text = "\(count)"
                    productPrice = productPrice * count
                    cartItemProducts[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                }
                productCollectionFromCart(productData: cartItemProducts[sender.tag], count: count)
            }
        }
    }
    func productCollectionFromCart(productData:Product, count:Int){
        if !productsArray.isEmpty{
            if let index = productsArray.firstIndex (where: {(abc) -> Bool in
                abc["productID"] == productData.id
            }){
                if count > 0{
                    productsArray[index]["productQty"] = "\(count)"
                    productsArray[index]["productQtyPrice"] = "\(Float(((productData.productPrice! as NSString).integerValue)*count))"
                }
                else{
                    productsArray.remove(at: index)
                }
            }
            else{
                let productPrice = (productData.productPrice! as NSString).integerValue
                productDict["productID"] = productData.id
                productDict["productPrice"] = "\(Float(productPrice))"
                productDict["productQty"] = "\(count)"
                productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"//"\(Float(productPrice*count))"
                productsArray.append(productDict)
            }
        }
        else{
            let productPrice = (productData.productPrice! as NSString).integerValue
            productDict["productID"] = productData.id
            productDict["productPrice"] = "\(Float(productPrice))"
            productDict["productQty"] = "\(count)"
            productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"//"\(Float(productPrice*count))"
            productsArray.append(productDict)
        }
    }
    func productCollection(productData:MyProducts, count:Int){
        if !productsArray.isEmpty{
            if let index = productsArray.firstIndex (where: {(abc) -> Bool in
                abc["productID"] == productData.id
            }){
                if count > 0{
                    productsArray[index]["productQty"] = "\(count)"
                    productsArray[index]["productQtyPrice"] = "\(Float(((productData.price! as NSString).integerValue)*count))"
                }
                else{
                    productsArray.remove(at: index)
                }
            }
            else{
                let productPrice = (productData.price! as NSString).integerValue
                productDict["productID"] = productData.id
                productDict["productPrice"] = "\(Float(productPrice))"
                productDict["productQty"] = "\(count)"
                productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice))"//"\(Float(productPrice*count))"
                productsArray.append(productDict)
            }
        }
        else{
            let productPrice = (productData.price! as NSString).integerValue
            productDict["productID"] = productData.id
            productDict["productPrice"] = "\(Float(productPrice))"
            productDict["productQty"] = "\(count)"
            productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice))"//"\(Float(productPrice*count))"
            productsArray.append(productDict)
        }
    }
}
extension AddToCartVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
extension AddToCartVC : MyPostedEventDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedEventModel)
    {
        print("EventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.eventDetails = data.data
            let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
            let imageString = (data.data?.image) ?? ""
            self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
            self.lbl_EventName.text = data.data?.name
            var sDate = data.data?.startDate ?? ""
            sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
            let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
            let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
            self.lbl_EventDate.text = startDate + " At " + startTime
            self.lbl_Address.text = data.data?.location
            self.eventOriginalPrice = (((data.data?.price ?? "") as NSString).integerValue)
            if eventOriginalPrice == 0{
                self.lbl_Price.text = "Free"
            }
            else{
                self.lbl_Price.text = "$\(eventOriginalPrice ?? 0)"
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

extension AddToCartVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.products = data.data ?? []
                        //self.tableView_Height.constant = CGFloat(200 * products.count)
            DispatchQueue.main.async {
                self.tableView_Height.constant = self.tableView_Products.contentSize.height
            }
            self.tableView_Products.reloadData()
        }
        else
        {
            if data.message == "Data not found"{
                self.products.removeAll()
            }
            print(data.message ?? "")
        }
        if self.products.count == 0
        {
            self.tableView_Height.constant = 0
            //            self.view_Products.isHidden = true
            
        }
        else{
           self.tableView_Height.constant = 125
            //            self.view_Products.isHidden = false
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
extension AddToCartVC : AddToCartDataModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.successDelegate?.addedToCart()
            self.navigationController?.popViewController(animated: false)
            //            self.dismiss(animated: false) {[weak self] in
            //                self?.successDelegate?.addedToCart()
            //            }
        }
        else
        {
            view.makeToast(data.message ?? "")
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
extension AddToCartVC : GetCartDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: CartDetailsModel)
    {
        print("EventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
            let imageString = (data.data?.image) ?? ""
            self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.img_EventPic.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "ticket_img"))
            self.lbl_EventName.text = data.data?.name
            var sDate = data.data?.addedDate ?? ""
            sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
            let startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "dd MMM yyyy")
            let startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
            self.lbl_EventDate.text = startDate + " At " + startTime
            self.lbl_Address.text = data.data?.location ?? ""
            let eventQty = (((data.data?.eventQty ?? "") as NSString).integerValue)
            self.lbl_EventCount.text = "\(eventQty)"
            
            self.eventOriginalPrice = (((data.data?.price ?? "") as NSString).integerValue)
            if eventOriginalPrice == 0{
                self.lbl_Price.text = "Free"
            }
            else{
                self.lbl_Price.text = "$\(eventOriginalPrice ?? 0)"
            }
            
            self.eventPrice = (((data.data?.eventPrice ?? "") as NSString).integerValue)
            self.lbl_EventPrice.text = "$\(eventPrice)"
            
            self.productPrice = (((data.data?.productsPrice ?? "") as NSString).integerValue)
            self.lbl_ProductPrice.text = "$\(self.productPrice)"
            
            self.lbl_TotalPrice.text = "$\((((data.data?.grandTotal ?? "") as NSString).integerValue))"
            self.cartItemProducts = data.data?.products ?? []
            if self.cartItemProducts.count == 0
            {
                self.tableView_Height.constant = 0
                //                self.view_Products.isHidden = true
                //
            }
            else{
                self.tableView_Height.constant = 125
                //                self.view_Products.isHidden = false
                for i in 0..<cartItemProducts.count{
                    cartItemProducts[i].updatedProductPrice = (((cartItemProducts[i].productQtyPrice ?? "") as NSString).integerValue)
                }
                DispatchQueue.main.async {
                    self.tableView_Height.constant = self.tableView_Products.contentSize.height
                }
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