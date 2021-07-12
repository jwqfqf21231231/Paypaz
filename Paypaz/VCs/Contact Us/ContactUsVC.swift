//
//  ContactUsVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 21/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

class ContactUsVC : CustomViewController {
    private let dataSource = ContactUsDataModel()
    
    @IBOutlet weak var txt_Email : RoundTextField!
    @IBOutlet weak var txt_Subject : RoundTextField!
    @IBOutlet weak var txt_Message : RoundTextView!
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
    }

    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Submit(_ sender:UIButton)
    {
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource.contactAdmin()
    }
}
extension ContactUsVC : ContactUsDataModelDelegate
{
    func didRecieveDataUpdate(data: ContactUsModel)
    {
        print("ContactUsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.navigationController?.popViewController(animated: false)
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
