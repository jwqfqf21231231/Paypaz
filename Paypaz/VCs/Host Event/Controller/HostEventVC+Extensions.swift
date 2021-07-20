//
//  HostEventVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
//MARK:-
extension HostEventVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 10 {
            return productIDArr.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 10 {
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
            
        } else {
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as? MemberCell else { return MemberCell() }
            if indexPath.row == 0 {
                cell.btn_tick.isSelected = false
            } else {
                cell.btn_tick.isSelected = true
            }
            return cell
            
        }
    }
}

//MARK:-
extension HostEventVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //_ = self.pushToVC("HomeEventDetailVC")
    }
    
}

//MARK:-
extension HostEventVC : PopupDelegate {
    
    func isClickedButton() {
      self.navigationController?.popViewController(animated: false)
        self.delegate?.passEventID?(eventID: self.eventID)
        
        
    }
}
//MARK:-
extension HostEventVC : AddProductDelegate {
    
    func isAddedProduct() {
        self.tableView_ProductsHeight.constant = self.tableView_Products.contentSize.height
        self.view.layoutIfNeeded()
        self.btn_clickToAdd.isHidden = true
        self.view_addNewBtn.isHidden = false
        
    }
}
