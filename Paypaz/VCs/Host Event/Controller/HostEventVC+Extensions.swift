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
extension HostEventVC : PopupDelegate {
    
    func isClickedButton() {
      self.navigationController?.popViewController(animated: false)
        self.delegate?.passEventID?(eventID: self.eventID)
        
        
    }
}
//MARK:-
//extension HostEventVC : AddProductDelegate {
//    
//    func isAddedProduct() {
//        self.view.layoutIfNeeded()
//        self.btn_clickToAdd.isHidden = true
//        self.view_addNewBtn.isHidden = false
//
//    }
//}
