//
//  InvitedPeopleVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 22/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
//MARK:-
extension InvitedPeopleVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as? DrawerCell else { return DrawerCell() }
        let url =  APIList().getUrlString(url: .USERIMAGE)
        let imageString = contacts[indexPath.row].userProfile ?? ""
        cell.img_icons.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_icons.sd_setImage(with: URL(string: url+imageString), placeholderImage: UIImage(named: "place_holder"))
        cell.lbl_title.text = contacts[indexPath.row].name
        cell.lbl_PhoneNo.text = "+\((contacts[indexPath.row].phoneCode!) + " " + (contacts[indexPath.row].phoneNumber!))"
        return cell
    }
}

//MARK:-
extension InvitedPeopleVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // _ = self.pushToVC("HomeEventDetailVC")
    }
   
}

