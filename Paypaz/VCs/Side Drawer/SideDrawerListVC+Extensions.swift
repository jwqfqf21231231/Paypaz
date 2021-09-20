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
        case 0:
            _ = self.pushToChildVC("HomeVC",animated: false)
        case 1:
            _ = self.pushToChildVC("WalletVC",animated: false)
        case 2:
            _ = self.pushToChildVC("MyTicketsVC",animated: false)
        case 3:
            _ = self.pushToChildVC("SettingsVC",animated: false)
        case 4:
            _ = self.pushToChildVC("MyEventsListVC",animated: false)
        case 5:
            _ = self.pushToChildVC("FavouritesEventsListVC",animated: false)
        case 6:
            _ = self.pushToChildVC("InvitesListVC",animated: false)
        case 7:
            _ = self.pushToChildVC("EventReportsHistoryVC",animated: false)
        case 8:
            if let vc = self.presentPopUpVC("LogOutVC", animated: false) as? LogOutVC{
                vc.delegate = self
            }
            #warning("--->>Change this during functionality in case of logout")
        default:
            print("....")
        }
        
    }
}

