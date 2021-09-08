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
        setDelegates()
        self.txt_Message.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        dataSource.delegate = self
    }
    private func setDelegates()
    {
        
        txt_Email.delegate = self
        txt_Subject.delegate = self
        txt_Message.delegate = self
        
    }
    //MARK:- --- Action ----
    @IBAction func btn_Back(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Submit(_ sender:UIButton)
    {
        if txt_Email.isEmptyOrWhitespace(){
            view.makeToast("Please enter your email id")
        }
        else if !txt_Email.isEmailValid()
        {
            view.makeToast("Please enter valid email id")
        }
        else if txt_Subject.isEmptyOrWhitespace()
        {
            view.makeToast("Please enter subject")
        }
        else if txt_Message.isEmptyOrWhitespace()
        {
            view.makeToast("please enter message")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.email = txt_Email.text ?? ""
            dataSource.subject = txt_Subject.text ?? ""
            dataSource.message = txt_Message.text
            dataSource.contactAdmin()
        }
    }
}
extension ContactUsVC : ContactUsDataModelDelegate
{
    func didRecieveDataUpdate(data: SuccessModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            view.makeToast(data.message ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: false)
            }
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
