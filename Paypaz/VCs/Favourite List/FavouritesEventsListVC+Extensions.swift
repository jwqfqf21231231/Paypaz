//
//  FavouritesEventsListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
extension FavouritesEventsListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell")  as? FavouriteCell
        else { return MyEventsCell() }
        cell.selectionStyle = .none
        cell.txt_EventName.text = favEvents[indexPath.row].name
        cell.txt_EventDate.text = (favEvents[indexPath.row].startDate ?? "")+" "+(favEvents[indexPath.row].endDate ?? "")
        cell.txt_Location.text = favEvents[indexPath.row].location
        cell.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
        cell.img_EventPic.sd_setImage(with: URL(string: url+(favEvents[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "terms_img"))
        //cell.btn_delete.addTarget(self, action: #selector(deleteEvent(_:)), for: .touchUpInside)
        return cell
    }
    
    //    @objc func deleteEvent(_ sender:UIButton){
    //        if let deletePopup = self.presentPopUpVC("DeleteEventPopupVC", animated: false) as? DeleteEventPopupVC {
    //            deletePopup.delegate  = self
    //        }
    //    }
    
}
extension FavouritesEventsListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = self.pushToVC("EventDetailVC") as? EventDetailVC{
            vc.eventID = favEvents[indexPath.row].id ?? ""
        }
        //  _ = self.pushToVC("EventDetailVC")
        
    }
    
}


