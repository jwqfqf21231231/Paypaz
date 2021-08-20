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
    @IBOutlet weak var btn_Submit : UIButton!
    @IBOutlet weak var tableView_Products       : UITableView!{
        didSet{
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_Back(_ sender:UIButton)
    {
        for vc in self.navigationController!.viewControllers as Array {
            if vc.isKind(of:HomeVC.self) {
                self.navigationController!.popToViewController(vc, animated: true)
                break
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
                    btn_Submit.setTitle("Continue", for: .normal)
                    btn_Submit.setTitleColor(.white, for: .normal)
                    btn_Submit.backgroundColor = UIColor(named: "GreenColor")
                    self.tableView_Products.reloadData()
                }
            }
        }
        /*    var products:String = ""
         for i in 0..<productIDArr.count
         {
         if(i == productIDArr.count-1)
         {
         products += "\(productIDArr[i])"
         }
         else
         {
         products += "\(productIDArr[i]),"
         }
         }
         dataSource.products = products
         if isEdit ?? false
         {
         dataSource.updateEvent()
         }
         else
         {
         dataSource.addEvent()
         }*/
    }
    @IBAction func btn_Continue(){
        if let vc = self.pushVC("InviteMembersVC") as? InviteMembersVC{
            vc.eventID = eventID
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
        return cell
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
            //products = data.data
            DispatchQueue.main.async {
                //self.tableView_Products.reloadData()
            }
        }
        else
        {
            self.showAlert(withMsg: data.message , withOKbtn: true)
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
            //  self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
