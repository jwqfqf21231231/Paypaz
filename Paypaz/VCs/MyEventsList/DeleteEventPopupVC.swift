//
//  DeleteEventPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 27/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

protocol DeleteEventDelegate : class {
    func deleteEventData(eventID :String)
}
class DeleteEventPopupVC : CustomViewController {

    weak var updateEventDelegate : DeleteEventDelegate?
    var eventID = ""
    private let dataSource = DeleteEventDataModel()

    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    

   // MARK: - --- Action ----
    @IBAction func btn_Yes(_ sender:UIButton) {
        Connection.svprogressHudShow(view: self)
        dataSource.eventID = self.eventID
        dataSource.deleteEvent() 
    }
    @IBAction func btn_No(_ sender:UIButton) {
        self.dismiss(animated: false)
        
    }
   
    
}
extension DeleteEventPopupVC : DeleteEventDataModelDelegate
{
    func didRecieveDataUpdate(data: SignUpModel)
    {
        print("DeleteEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.dismiss(animated: false) {[weak self] in
                self?.updateEventDelegate?.deleteEventData(eventID: self?.eventID ?? "")
              //  self?.delegate?.isClickedButton()
            }
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}

