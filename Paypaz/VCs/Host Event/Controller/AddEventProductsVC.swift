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
    @IBAction func btn_addProducts(_ sender:UIButton)
    {
        if let addProduct = self.presentPopUpVC("AddProductVC", animated: false) as? AddProductVC {
            //addProduct.delegate = self
            
            addProduct.callback = { [self] item in
                self.productArr.append(["image" : item["productImage"]!,"price" : item["productPrice"]!,"name" : item["productName"]!,"description" : item["productDescription"]!,"fromServer" : false])
                
                self.productIDArr.append(item["productID"] as! String)
                DispatchQueue.main.async {
                    
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
