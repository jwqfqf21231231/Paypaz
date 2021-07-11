//
//  OtherUserProfileVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 20/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit

extension OtherUserProfileVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell")  as? DrawerCell
            else { return DrawerCell() }
        
          return cell
    }
}
extension OtherUserProfileVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //_ = self.pushToVC("ProductDetailVC")
    }
}


