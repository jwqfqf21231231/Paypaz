//
//  AddEventProducts.swift
//  Paypaz
//
//  Created by MAC on 18/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class AddEventProductsVC: CustomViewController {
    
    var productIDArr = [String]()
    var productArr = [[String:Any]]()
    var eventID = ""
    var isEdit : Bool?
    private let dataSource = ProductDetailsDataModel()
    private let productsDataSource = MyPostedEventDataModel()
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var btn_Submit : UIButton!
    @IBOutlet weak var tableView_Products       : UITableView!{
        didSet{
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate2 = self
        productsDataSource.delegate2 = self
        if isEdit ?? false{
            self.lbl_Title.text = "Edit Event Products"
            self.btn_Submit.setTitle("Save", for: .normal)
            self.btn_Submit.setTitleColor(.white, for: .normal)
            self.btn_Submit.backgroundColor = UIColor(named: "GreenColor")
            getProducts()
        }
        // Do any additional setup after loading the view.
    }
    private func getProducts(){
        Connection.svprogressHudShow(view: self)
        productsDataSource.eventID = eventID
        productsDataSource.pageNo = "0"
        //self.currentPage = 1
        productsDataSource.getProducts()
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        if isEdit ?? false{
            self.navigationController?.popViewController(animated: false)
        }
        else{
            for vc in self.navigationController!.viewControllers as Array {
                if vc.isKind(of:EventVC.self) {
                    self.navigationController!.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    @IBAction func btn_addProducts(_ sender:UIButton)
    {
        if let addProduct = self.presentPopUpVC("AddProductVC", animated: false) as? AddProductVC {
            //addProduct.delegate = self
            addProduct.eventID = eventID
            addProduct.callback = { [self] item in
                self.productArr.append(["image" : item["productImage"]!,"price" : item["productPrice"]!,"name" : item["productName"]!,"description" : item["productDescription"]!,"fromServer" : false])
                
                self.productIDArr.append(item["productID"] as! String)
                DispatchQueue.main.async {
                    self.btn_Submit.setTitle("Continue", for: .normal)
                    self.btn_Submit.setTitleColor(.white, for: .normal)
                    self.btn_Submit.backgroundColor = UIColor(named: "GreenColor")
                    self.tableView_Products.reloadData()
                }
            }
        }
    }
    @IBAction func btn_Continue(){
        if isEdit ?? false{
            self.navigationController?.popViewController(animated: false)
        }
        else{
            if let vc = self.pushVC("InviteMembersVC") as? InviteMembersVC{
                vc.eventID = eventID
            }
        }
    }
}
extension AddEventProductsVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productIDArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell") as? ProductTableCell else { return ProductTableCell() }
        if (productArr[indexPath.row]["fromServer"] as? Bool ?? false)
        {
            cell.img_Product.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url =  APIList().getUrlString(url: .UPLOADEDPRODUCTIMAGE)
            cell.img_Product.sd_setImage(with: URL(string: url+(productArr[indexPath.row]["image"] as! String)))
        }
        else
        {
            cell.img_Product.image = productArr[indexPath.row]["image"] as? UIImage
        }
        cell.lbl_ProductName.text = productArr[indexPath.row]["name"] as? String
        cell.lbl_Description.text = productArr[indexPath.row]["description"] as? String
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(deleteProduct(button:)), for: .touchUpInside)
        return cell
    }
    @objc func deleteProduct(button : UIButton)
    {
        Connection.svprogressHudShow(view: self)
        dataSource.productID = productIDArr[button.tag]
        dataSource.eventID = self.eventID
        productIDArr.remove(at: button.tag)
        productArr.remove(at: button.tag)
        dataSource.type = "0"
        dataSource.deleteProduct()
    }
}
extension AddEventProductsVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            let products = data.data ?? []
            for i in 0..<products.count{
                productArr.append(["image" : products[i].image ?? "","price" : products[i].price ?? "","name" : products[i].name ?? "","description" : products[i].dataDescription ?? "","fromServer" : true])
                productIDArr.append(products[i].id ?? "")
            }
            tableView_Products.reloadData()
        }
        else
        {
            self.view.makeToast(data.message ?? "", duration: 1, position: .center)
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
            self.view.makeToast("No Products Data", duration: 3, position: .bottom)
        }
    }
}
extension AddEventProductsVC : DeleteProductDataModelDelegate
{
    func didRecieveDataUpdate(data: SuccessModel)
    {
        print("DeleteProductModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            
            tableView_Products.reloadData()
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
