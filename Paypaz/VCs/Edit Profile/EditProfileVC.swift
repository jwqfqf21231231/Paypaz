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
import GooglePlaces

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
    @IBOutlet weak var txt_email : RoundTextField!
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
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
       
        datePicker.datePickerMode = .date
        txt_DOB.inputView=datePicker
        txt_DOB.inputAccessoryView=createToolBar()
    }
    @IBAction func btn_ChooseLocation(_ sender:UIButton)
    {
        self.view.endEditing(true)
        let placePicker = GMSAutocompleteViewController()
        if #available(iOS 13.0, *) {
            placePicker.primaryTextColor = UIColor.label
            placePicker.secondaryTextColor = UIColor.secondaryLabel
            placePicker.tableCellSeparatorColor = UIColor.separator
            placePicker.tableCellBackgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        
        placePicker.modalPresentationStyle = .fullScreen
        placePicker.delegate = self
        self.present(placePicker, animated: true, completion: nil)
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
        hideKeyboardWhenTappedArround()
        self.setDelegate()
        self.getUserDetails()
    }
    
    private func getUserDetails()
    {
        Connection.svprogressHudShow(view: self)
        dataSource1.getUserDetails()
        
    }
    private func setDelegate() {
        self.txt_firstName.delegate = self
        self.txt_lastName.delegate  = self
        self.txt_DOB.delegate       = self
        self.txt_City.delegate      = self
        self.txt_State.delegate     = self
        self.txtView_Address.delegate = self
    }
    @IBAction func btn_Save(_ sender:UIButton) {
        
        if txt_firstName.text?.trim().count == 0{
            view.makeToast("Please enter your first name")
        }
        else if txt_lastName.text?.trim().count == 0{
            view.makeToast("Please enter last Name")
        }
        else if txt_email.text?.trim().count == 0
        {
            view.makeToast("Please enter email")
        }
        else if txt_DOB.text?.trim().count == 0{
            view.makeToast("Please enter date of birth")
        }
        else if txt_City.text?.trim().count == 0{
            view.makeToast("Please enter city")
        }
        else if txt_State.text?.trim().count == 0{
            view.makeToast("Please enter state")
        }
        else if txtView_Address.text.trim().count == 0
        {
            view.makeToast("Please enter address")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.firstName = txt_firstName.text ?? ""
            dataSource.lastName = txt_lastName.text ?? ""
            dataSource.email = txt_email.text ?? ""
            dataSource.city = txt_City.text ?? ""
            dataSource.address = txtView_Address.text ?? ""
            dataSource.dateOfBirth = txt_DOB.text ?? ""
            dataSource.state = txt_State.text ?? ""
            dataSource.profilePic = img_Profile.image
            dataSource.isUpdate = "0"
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
extension EditProfileVC: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        self.txtView_Address.text = place.name ?? ""
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                self.txt_email.text = data.data?.email
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
    func didRecieveDataUpdate(data: LogInModel)
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
