//
//  EventReportsVC+Extensions.swift
//  Paypaz
//
//  Created by iOSDeveloper on 04/06/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//


import UIKit

extension EventReportsHistoryVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell")  as? DrawerCell
            else { return DrawerCell() }
        
          return cell
    }
}
extension EventReportsHistoryVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        _ = self.pushVC("EventReportVC")
    }
}


