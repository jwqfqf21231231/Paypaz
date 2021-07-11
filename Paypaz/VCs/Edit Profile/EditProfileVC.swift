//
//  EditProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 26/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class EditProfileVC: CustomViewController {
    //Here i am using CreateProfileDataModel which you can find it in CreateProfile
    //Here i am using UserDetailsDataModel which you can find it in Side Drawer
    private let dataSource = CreateProfileDataModel()
    private let dataSource1 = UserDetailsDataModel()
    var datePicker:UIDatePicker!
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    
    @IBOutlet weak var img_Profile : UIImageView!
    @IBOutlet weak var txt_firstName : RoundTextField!
    @IBOutlet weak var txt_lastName  : RoundTextField!
    @IBOutlet weak var txt_PhnNum    : RoundTextField!
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
        datePicker.preferredDatePickerStyle = .wheels
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
    //MARK:- --- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView_Address.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        createDatePicker()
        dataSource.delegate = self
        dataSource1.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.setDelegate()
        self.getUserDetails()
    }
    
    private func getUserDetails()
    {
        Connection.svprogressHudShow(title: "Please Wait", view: self)
        dataSource1.getUserDetails()
        
    }
    private func setDelegate() {
        self.txt_firstName.delegate = self
        self.txt_lastName.delegate  = self
        self.txt_PhnNum.delegate    = self
        self.txt_DOB.delegate       = self
        self.txt_City.delegate      = self
        self.txt_State.delegate     = self
    }
    @IBAction func btn_Save(_ sender:UIButton) {
        
        if txt_firstName.text == ""{
            self.showAlert(withMsg: "Please enter your first name", withOKbtn: true)
        }
        else if txt_lastName.text == ""{
            self.showAlert(withMsg: "Please enter Last Name", withOKbtn: true)
        }
        else if txt_PhnNum.text == ""{
            self.showAlert(withMsg: "Please enter Phone Number", withOKbtn: true)
            _ = self.pushToVC("OTPVerificationVC")
        }
        else if txt_DOB.text == ""{
            self.showAlert(withMsg: "Please enter DateOfBirth", withOKbtn: true)
            _ = self.pushToVC("OTPVerificationVC")
        }
        else if txt_City.text == ""{
            self.showAlert(withMsg: "Please enter City", withOKbtn: true)
            _ = self.pushToVC("OTPVerificationVC")
        }
        else if txt_State.text == ""{
            self.showAlert(withMsg: "Please enter State", withOKbtn: true)
            _ = self.pushToVC("OTPVerificationVC")
        }
        else if txtView_Address.text == ""
        {
            self.showAlert(withMsg: "Please enter Address", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
            dataSource.firstName = txt_firstName.text!
            dataSource.lastName = txt_lastName.text!
            dataSource.city = txt_City.text!
            dataSource.address = txtView_Address.text!
            dataSource.dateOfBirth = txt_DOB.text!
            dataSource.phoneNumber = txt_PhnNum.text!
            dataSource.state = txt_State.text!
            dataSource.profilePic = pickedImage
            dataSource.uploadProImg()
        }
    }
    
    @IBAction func btn_ChangePic(_ sender:UIButton)
    {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.img_Profile.image = img
            self.pickedImage = img
            self.images["identity_img"] = img
        }
    }
    
    //MARK:- --- Action ----
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension EditProfileVC : UserDetailsDataModelDelegate
{
    func didRecieveDataUpdate(data: UserDetailsModel)
    {
        print("UserDetailsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                self.txt_firstName.text = data.data?.firstName
                self.txt_lastName.text = data.data?.lastName
                self.txt_PhnNum.text = data.data?.phoneNumber
                self.txt_DOB.text = data.data?.dob
                self.txt_City.text = data.data?.city
                self.txt_State.text = data.data?.state
                self.img_Profile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .USERIMAGE)
                self.img_Profile.sd_setImage(with: URL(string: url+(data.data?.userProfile ?? "")), placeholderImage: UIImage(named: "profile_c"))
                self.txtView_Address.text = data.data?.address
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

extension EditProfileVC : CreateProfileDataModelDelegate
{
    func didRecieveDataUpdate(data: CreateProfileModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            _ = self.pushToVC("SideDrawerBaseVC",animated: false)
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
