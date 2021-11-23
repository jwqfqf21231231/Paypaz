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
            if products[indexPath.row].isPaid == "0"{
                cell.lbl_Price.text = "Free"
            }
            else{
                cell.lbl_Price.text = "$\(Float(products[indexPath.row].price ?? "")?.clean ?? "")"
            }
            cell.lbl_ProductName.text = products[indexPath.row].name
        }
        else{
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            let imageString = cartItemProducts[indexPath.row].image ?? ""
            cell.img_Product.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.img_Product.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "event_img"))
            cell.lbl_ProductCount.text = "\((((cartItemProducts[indexPath.row].productQty ?? "") as NSString).integerValue))"
            let cartProductPrice = Float(cartItemProducts[indexPath.row].productPrice ?? "") ?? 0.0
            if cartProductPrice == 0{
                cell.lbl_Price.text = "Free"
            }
            else{
                cell.lbl_Price.text = "$\(cartProductPrice.clean)"
            }
            cell.lbl_ProductName.text = cartItemProducts[indexPath.row].name
        }
        cell.btn_AddProduct.tag = indexPath.row
        cell.btn_DeleteProduct.tag = indexPath.row
        cell.btn_AddProduct.addTarget(self, action: #selector(btn_AddProducts(_:)), for: .touchUpInside)
        cell.btn_DeleteProduct.addTarget(self, action: #selector(btn_RemoveProducts(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btn_AddProducts(_ sender:UIButton){
        if addToCart ?? false{
            var productPrice = Float(products[sender.tag].price ?? "") ?? 0.0
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = Float(cell.lbl_ProductCount.text ?? "") ?? 0.0
                let maxItmesCount = Float(products[sender.tag].quantity ?? "") ?? 0.0
                if count < maxItmesCount{
                    count = count + 1
                    cell.lbl_ProductCount.text = "\(Int(count))"
                    productPrice = productPrice * count
                    products[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                    productCollection(productData: products[sender.tag], count: Int(count))
                }
                else{
                    return
                }
            }
        }
        else{
            var productPrice = Float(cartItemProducts[sender.tag].productPrice ?? "") ?? 0.0
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = Float(cell.lbl_ProductCount.text ?? "") ?? 0.0
                let maxItmesCount = Float(cartItemProducts[sender.tag].quantity ?? "") ?? 0.0
                if count < maxItmesCount{
                    count = count + 1
                    cell.lbl_ProductCount.text = "\(Int(count))"
                    productPrice = productPrice * count
                    cartItemProducts[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                    productCollectionToBuyCart(productData: cartItemProducts[sender.tag], count: count)
                }
                else{
                    return
                }
            }
        }
        
    }
    @objc func btn_RemoveProducts(_ sender:UIButton){
        if addToCart ?? false{
            var productPrice = Float(products[sender.tag].price ?? "") ?? 0.0
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = Float(cell.lbl_ProductCount.text ?? "") ?? 0.0
                if count > 0{
                    count = count - 1
                    cell.lbl_ProductCount.text = "\(Int(count))"
                    productPrice = productPrice * count
                    products[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                }
                productCollection(productData: products[sender.tag], count: Int(count))
            }
        }
        else{
            var productPrice = Float(cartItemProducts[sender.tag].productPrice ?? "") ?? 0.0
            let indexpath = IndexPath.init(row: sender.tag, section: 0)
            if let cell = tableView_Products.cellForRow(at: indexpath) as? ProductTableCell{
                var count = Float(cell.lbl_ProductCount.text ?? "") ?? 0.0
                if count > 0 {
                    count = count - 1
                    cell.lbl_ProductCount.text = "\(Int(count))"
                    productPrice = productPrice * count
                    
                    cartItemProducts[sender.tag].updatedProductPrice = productPrice
                    calculateTotalProductPrice()
                }
                productCollectionToBuyCart(productData: cartItemProducts[sender.tag], count: count)
            }
        }
    }
    func productCollectionFromCart(productData:Product, count:Float){
        if !productsArray.isEmpty{
            if let index = productsArray.firstIndex (where: {(abc) -> Bool in
                abc["productID"] == productData.id
            }){
                if count > 0{
                    productsArray[index]["productQty"] = "\(count)"
                    productsArray[index]["productQtyPrice"] = "\((Float(productData.productPrice ?? "") ?? 0.0)*count)"
                }
                else{
                    productsArray.remove(at: index)
                }
            }
            else{
                let productPrice = Float(productData.productPrice ?? "") ?? 0.0
                productDict["productID"] = productData.id
                productDict["productPrice"] = "\(productPrice)"
                productDict["productQty"] = "\(Int(count))"
                productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"
                productsArray.append(productDict)
            }
        }
        else{
            let productPrice = Float(productData.productPrice ?? "") ?? 0.0
            productDict["productID"] = productData.id
            productDict["productPrice"] = "\(productPrice))"
            productDict["productQty"] = "\(Int(count))"
            productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"
            productsArray.append(productDict)
        }
    }
    func productCollectionToBuyCart(productData:Product, count:Float){
        if !productsArray.isEmpty{
            if let index = productsArray.firstIndex (where: {(abc) -> Bool in
                abc["productID"] == productData.productID
            }){
                if count > 0{
                    productsArray[index]["productQty"] = "\(count)"
                    productsArray[index]["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"
                }
                else{
                    productsArray.remove(at: index)
                }
            }
            else{
                let productPrice = Float(productData.productPrice ?? "") ?? 0.0
                productDict["productID"] = productData.productID
                productDict["productPrice"] = "\(Float(productPrice))"
                productDict["productQty"] = "\(Int(count))"
                productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"
                productsArray.append(productDict)
            }
        }
        else{
            let productPrice = Float(productData.productPrice ?? "") ?? 0.0
            productDict["productID"] = productData.productID
            productDict["productPrice"] = "\(Float(productPrice))"
            productDict["productQty"] = "\(Int(count))"
            productDict["productQtyPrice"] = "\(Float(productData.updatedProductPrice ?? 0))"
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
                    productsArray[index]["productQtyPrice"] = "\(productData.updatedProductPrice)"
                }
                else{
                    productsArray.remove(at: index)
                }
            }
            else{
                productDict["productID"] = productData.id
                productDict["productPrice"] = "\(Float(productData.price ?? "") ?? 0.0)"
                productDict["productQty"] = "\(count)"
                productDict["productQtyPrice"] = "\(productData.updatedProductPrice)"
                productsArray.append(productDict)
            }
        }
        else{
            productDict["productID"] = productData.id
            productDict["productPrice"] = "\(Float(productData.price ?? "") ?? 0.0)"
            productDict["productQty"] = "\(count)"
            productDict["productQtyPrice"] = "\(productData.updatedProductPrice)"
            productsArray.append(productDict)
        }
    }
}

extension AddToCartVC : CartCheckOutDataModelDelegate
{
    func didRecieveDataUpdate1(data: ResendOTPModel)
    {
        print("EventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
        }
    }
    
    func didFailDataUpdateWithError4(error: Error)
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
            self.eventOriginalPrice = (Float(data.data?.price ?? "") ?? 0.0)
            if eventOriginalPrice == 0{
                self.lbl_Price.text = "Free"
            }
            else{
                self.lbl_Price.text = "$\(eventOriginalPrice?.clean ?? "")"
            }
            let icon1 = UpdatedCartInfo(eventID: data.data?.id ?? "", eventUserID: data.data?.userID ?? "", eventQty: "0", eventPrice: data.data?.price ?? "", productsPrice: "", subTotal: "", discount:  "0.0", tax: "0.0", grandTotal: "", cartID: "0", paymentType: data.data?.paymentType, buyDirectly: true, products:[])
            self.updatedCartInfo = icon1
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
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

extension AddToCartVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.products = data.data ?? []
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                if data.message == "Data not found"{
                    self.products.removeAll()
                }
                print(data.message ?? "")
            }
        }
        if self.products.count == 0
        {
            self.hideProductsView.alpha = 1
            self.tableView_Height.constant = 0
        }
        else{
            self.hideProductsView.alpha = 0
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
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                view.makeToast(data.message ?? "")
            }
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
            let icon1 = UpdatedCartInfo(eventID: data.data?.eventID ?? "", eventUserID: data.data?.eventUserID ?? "", eventQty: data.data?.eventQty ?? "", eventPrice: data.data?.eventPrice ?? "", productsPrice: data.data?.productsPrice ?? "", subTotal: data.data?.subTotal ?? "", discount:  data.data?.discount ?? "", tax: data.data?.tax ?? "", grandTotal: data.data?.grandTotal ?? "", cartID: data.data?.id ?? "", paymentType: data.data?.paymentType ?? "", buyDirectly: true, products:[])
            self.updatedCartInfo = icon1
            
            self.cartEventOriginalQty = data.data?.quantity ?? ""
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
            self.lbl_Address.text = data.data?.location ?? ""
            let eventQty = ((data.data?.eventQty ?? "") as NSString).integerValue
            self.lbl_EventCount.text = "\(eventQty)"
            
            self.eventOriginalPrice = Float(data.data?.price ?? "")
            if eventOriginalPrice == 0.0{
                self.lbl_Price.text = "Free"
            }
            else{
                self.lbl_Price.text = "$\((eventOriginalPrice)?.clean ?? "")"
            }
            
            self.eventPrice = Float(data.data?.eventPrice ?? "") ?? 0.0
            self.lbl_EventPrice.text = "$\(eventPrice.clean)"
            
            self.productPrice = Float(data.data?.productsPrice ?? "") ?? 0.0
            self.lbl_ProductPrice.text = "$\(self.productPrice.clean)"
            
            self.totalPrice = Float(data.data?.grandTotal ?? "") ?? 0.0
            self.lbl_TotalPrice.text = "$\(totalPrice.clean)"
            self.cartItemProducts = data.data?.products ?? []
            if cartItemProducts.count == 0{
                self.hideProductsView.alpha = 1
                self.tableView_Height.constant = 0
            }
            else{
                self.hideProductsView.alpha = 0
                for i in 0..<cartItemProducts.count{
                    productDict["productID"] = cartItemProducts[i].productID
                    productDict["productPrice"] = cartItemProducts[i].productPrice
                    productDict["productQty"] = cartItemProducts[i].productQty
                    productDict["productQtyPrice"] = cartItemProducts[i].productQtyPrice
                    productsArray.append(productDict)
                }
                for i in 0..<cartItemProducts.count{
                    cartItemProducts[i].updatedProductPrice = Float(cartItemProducts[i].productQtyPrice ?? "")
                }
                tableView_Height.constant = CGFloat.greatestFiniteMagnitude
                tableView_Products.reloadData()
                tableView_Products.layoutIfNeeded()
                tableView_Height.constant = self.tableView_Products.contentSize.height
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            if data.isAuthorized == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .authorized
                }
            }
            else if data.isSuspended == 0{
                UserDefaults.standard.setLoggedIn(value: "0")

                if let vc = self.pushVC("LoginVC") as? LoginVC{
                    vc.statusType = .suspended
                }
            }
            else{
                self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
            }
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
