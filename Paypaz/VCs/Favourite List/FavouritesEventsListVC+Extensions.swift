//
//  FavouritesEventsListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

extension FavouritesEventsListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell")  as? MyEventsCell
            else { return MyEventsCell() }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  _ = self.pushToVC("EventDetailVC")
        
    }
}


