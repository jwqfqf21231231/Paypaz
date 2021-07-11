//
//  ViewProfileVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 26/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

//MARK:-
extension ViewProfileVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell") as? DrawerCell else { return DrawerCell() }
        return cell
    }
}

//MARK:-
extension ViewProfileVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // _ = self.pushToVC("HomeEventDetailVC")
    }

}
