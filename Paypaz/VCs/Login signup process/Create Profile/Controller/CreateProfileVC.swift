//
//  CreateProfileVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

class CreateProfileVC  : CustomViewController {
    
    private let dataSource = CreateProfileDataModel()
    var datePicker:UIDatePicker!
    var pickedImage : UIImage?
    var fontCamera  = false
    var picSelected = false
    let sharedInstance = Connection()
    
    @IBOutlet weak var img_Profile      : UIImageView!
    @IBOutlet weak var txt_firstName    : RoundTextField!
    @IBOutlet weak var txt_lastName     : RoundTextField!
    @IBOutlet weak var txt_DOB          : RoundTextField!
    @IBOutlet weak var txt_City         : RoundTextField!
    @IBOutlet weak var txt_State        : RoundTextField!
    @IBOutlet weak var txtView_Address  : RoundTextView!
    // Age of 18.
    let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -5, to: Date())!;
    
    // Age of 100.
    func createToolBar()->UIToolbar
    {
        //tool bar
        let toolBar=UIToolbar()
        toolBar.sizeToFit()
        //bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel))
        toolBar.setItems([cancel,flexible,doneBtn], animated: false)
        return toolBar
    }
    
    @objc func tapCancel() {
        self.view.endEditing(true)
    }
    
    func createDatePicker()
    {
        datePicker=UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        txt_DOB.inputView=datePicker
        txt_DOB.inputAccessoryView=createToolBar()
    }
    func validateAge(birthDate: Date) -> Bool {
        var isValid: Bool = true;
        
        if birthDate > MINIMUM_AGE  {
            isValid = false;
        }
        
        return isValid;
    }
    @objc func donePressed()
    {
        self.view.endEditing(true)
        
        let isValidAge = validateAge(birthDate: datePicker.date);
        
        if isValidAge {
            let dateFormatter=DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.txt_DOB.text=dateFormatter.string(from: datePicker.date)
        }
        else {
            self.view.makeToast("User age must be greater than 5 years.")
            self.txt_DOB.text?.removeAll()
        }
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
    
    @IBAction func btn_ChooseLocation(_ sender:UIButton)
    {
        self.view.endEditing(true)
        let placePicker = GMSAutocompleteViewController()
        if #available(iOS 13.0, *) {
            placePicker.primaryTextColor = UIColor.label
            placePicker.secondaryTextColor = UIColor.secondaryLabel
            placePicker.tableCellSeparatorColor = UIColor.separator
            placePicker.tableCellBackgroundColor = UIColor.systemBackground
        }
        placePicker.modalPresentationStyle = .fullScreen
        placePicker.delegate = self
        self.present(placePicker, animated: true, completion: nil)
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Save(_ sender:UIButton) {
        if validateFields() == true
        {
            Connection.svprogressHudShow(view: self)
            dataSource.firstName = txt_firstName.text?.trim() ?? ""
            dataSource.lastName = txt_lastName.text?.trim() ?? ""
            dataSource.city = txt_City.text?.trim() ?? ""
            dataSource.address = txtView_Address.text.trim() 
            dataSource.dateOfBirth = txt_DOB.text?.trim() ?? ""
            dataSource.state = txt_State.text?.trim() ?? ""
            dataSource.profilePic = img_Profile.image!
            dataSource.isUpdate = "1"
            dataSource.uploadProImg()
        }
    }
    
    func validateFields() -> Bool
    {
        if picSelected == false
        {
            self.view.makeToast("Please add your image")
        }
        else if txt_firstName.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter your first name")
        }
        else if txt_lastName.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter your Last Name")
        }
        else if txt_firstName.textCount() > 16{
            self.view.makeToast("Your First Name should not exceed 16 characters")
        }
        else if txt_lastName.textCount() > 16{
            self.view.makeToast("Your Last Name should not exceed 16 characters")
        }
        else if txt_DOB.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter DateOfBirth")
        }
        else if txt_City.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter City")
        }
        else if txt_State.isEmptyOrWhitespace(){
            self.view.makeToast("Please enter State")
        }
        else if txtView_Address.isEmptyOrWhitespace()
        {
            self.view.makeToast("Please enter Address")
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
            self.picSelected = true
        }
    }
}

extension CreateProfileVC: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        self.txtView_Address.text = place.formattedAddress ?? ""
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

extension CreateProfileVC : CreateProfileDataModelDelegate
{
    func didRecieveDataUpdate(data: LogInModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            UserDefaults.standard.set(data.data?.isProfile ?? "", forKey: "isProfile")
            _ = self.pushVC("CreatePasscodeVC",animated: false)
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
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
