//
//  SideDrawerListVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

extension SideDrawerListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Menu?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell")  as? DrawerCell
            else { return DrawerCell() }
        
        cell.lbl_title.text  = self.arr_Menu?[indexPath.row]
        cell.img_icons.image = UIImage(named: self.arr_imgs?[indexPath.row] ?? "")
        return cell
    }
}
extension SideDrawerListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.sideMenuController?.hideLeftView()
        
        switch indexPath.row {
        case 0: self.pushToChildVC("HomeVC")
        case 1:
            _ = self.pushToChildVC("WalletVC")
        case 2:
            _ = self.pushToChildVC("MyTicketsVC")
        case 3:
            _ = self.pushToChildVC("SettingsVC")
        case 4:
            _ = self.pushToChildVC("MyEventsListVC")
        case 5:
            _ = self.pushToChildVC("FavouritesEventsListVC")
        case 6:
            _ = self.pushToChildVC("InvitesListVC")
        case 7:
            _ = self.pushToChildVC("EventReportsHistoryVC")
        case 8:
            UserDefaults.standard.setLoggedIn(value: false)
            _ = self.pushToChildVC("LoginVC")
            #warning("--->>Change this during functionality in case of logout")
        default:
            print("....")
        }
        
    }
}
