//
//  CreateProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Alamofire
class CreateProfileVC  : CustomViewController {
    
    private let dataSource = CreateProfileDataModel()
    var datePicker:UIDatePicker!
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    var picSelected = false
    let sharedInstance = Connection()
    
    @IBOutlet weak var img_Profile : UIImageView!
    @IBOutlet weak var txt_firstName : RoundTextField!
    @IBOutlet weak var txt_lastName  : RoundTextField!
    @IBOutlet weak var txt_DOB       : RoundTextField!
    @IBOutlet weak var txt_City      : RoundTextField!
    @IBOutlet weak var txt_State     : RoundTextField!
    @IBOutlet weak var txtView_Address : RoundTextView!
    
    func createToolBar()->UIToolbar
    {
        //tool bar
        let toolBar=UIToolbar()
        toolBar.sizeToFit()
        //bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        return toolBar
    }
    
    func createDatePicker()
    {
        datePicker=UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = .date
        txt_DOB.inputView=datePicker
        txt_DOB.inputAccessoryView=createToolBar()
    }
    @objc func donePressed()
    {
        let dateFormatter=DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.txt_DOB.text=dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView_Address.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        createDatePicker()
        dataSource.delegate = self
        hideKeyboardWhenTappedArround()
        self.setDelegate()
        
    }
    
    private func setDelegate() {
        self.txt_firstName.delegate = self
        self.txt_lastName.delegate  = self
        self.txt_DOB.delegate       = self
        self.txt_City.delegate      = self
        self.txt_State.delegate     = self
        self.txtView_Address.delegate = self
    }
    
    // MARK: - --- Action ----
    
    @IBAction func btn_Save(_ sender:UIButton) {
        if validateFields() == true
        {
            Connection.svprogressHudShow(view: self)
            dataSource.firstName = txt_firstName.text!
            dataSource.lastName = txt_lastName.text!
            dataSource.city = txt_City.text!
            dataSource.address = txtView_Address.text!
            dataSource.dateOfBirth = txt_DOB.text!
            dataSource.state = txt_State.text!
            dataSource.profilePic = pickedImage
            dataSource.isUpdate = "1"
            dataSource.uploadProImg()
        }
    }
    func validateFields() -> Bool
    {
        if picSelected == false
        {
            self.showAlert(withMsg: "Please add your image", withOKbtn: true)
        }
        else if txt_firstName.text?.trim().count == 0{
            self.showAlert(withMsg: "Please enter your first name", withOKbtn: true)
        }
        else if txt_lastName.text?.trim().count == 0{
            self.showAlert(withMsg: "Please enter Last Name", withOKbtn: true)
        }
        else if txt_DOB.text?.trim().count == 0{
            self.showAlert(withMsg: "Please enter DateOfBirth", withOKbtn: true)
        }
        else if txt_City.text?.trim().count == 0{
            self.showAlert(withMsg: "Please enter City", withOKbtn: true)
        }
        else if txt_State.text?.trim().count == 0{
            self.showAlert(withMsg: "Please enter State", withOKbtn: true)
        }
        else if txtView_Address.text.trim().count == 0
        {
            self.showAlert(withMsg: "Please enter Address", withOKbtn: true)
        }
        else
        {
            return true
        }
        return false
    }
    @IBAction func btn_ChangePic(_ sender:UIButton)
    {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.img_Profile.image = img
            self.pickedImage = img
            self.images["identity_img"] = img
            self.picSelected = true
        }
    }
}
extension CreateProfileVC : CreateProfileDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        UserDefaults.standard.set(data.data?.isProfile, forKey: "isProfile")
        if data.success == 1
        {
            _ = self.pushToVC("CreatePasscodeVC",animated: false)
        }
        else
        {
            self.showAlert(withMsg: data.messages ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError1(error: Error)
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
