//
//  HostEventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 16/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
import GooglePlaces
class HostEventVC : CustomViewController {
    
    var isEdit : Bool? //The value for isEdit comes from MyEventsListVC+Extensions (60th line)
    var eventID = ""
    private let dataSource2 = MyPostedEventDataModel()
    
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    var picker:UIDatePicker!
    var location = ""
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var paymentType : String?{
        didSet{
            if paymentType == "0"
            {
                self.btn_Paypaz.border_Color   = UIColor(named: "GreenColor")
                self.btn_bankAcc.border_Color  = UIColor.lightGray
                self.btn_Paypaz.setImage(UIImage(named: "pay"), for: .normal)
                self.btn_bankAcc.setImage(UIImage(named: "surface_icons"), for: .normal)
            }
            else
            {
                self.btn_bankAcc.border_Color = UIColor(named: "GreenColor")
                self.btn_Paypaz.border_Color  = UIColor.lightGray
                self.btn_Paypaz.setImage(UIImage(named: "paypaz_green"), for: .normal)
                self.btn_bankAcc.setImage(UIImage(named: "green_account"), for: .normal)
            }
        }
    }
   
    weak var delegate : PopupDelegate?
    private let dataSource = HostEventDataModel()
    
    var selectedEventId : String?
    var btn_Title:String?
    var fieldTag:Int?
    
    
    
    //MARK:- ----
    @IBOutlet weak var view_Dashed : UIView!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var txt_EventName : RoundTextField!
    @IBOutlet weak var txt_EventQuantity : RoundTextField!
    @IBOutlet weak var btn_ChooseLocation : UIButton!
    @IBOutlet weak var txt_Price : RoundTextField!
    @IBOutlet weak var btn_StartDate : UIButton!
    @IBOutlet weak var txt_StartDate : UITextField!
    @IBOutlet weak var btn_EndDate : UIButton!
    @IBOutlet weak var txt_EndDate : UITextField!
    @IBOutlet weak var btn_StartTime : UIButton!
    @IBOutlet weak var txt_StartTime : UITextField!
    @IBOutlet weak var btn_EndTime : UIButton!
    @IBOutlet weak var txt_EndTime : UITextField!
    @IBOutlet weak var btn_EventTitle : UIButton!
    @IBOutlet weak var btn_CreateEvent : UIButton!
    @IBOutlet weak var btn_Paypaz : RoundButton!
    @IBOutlet weak var btn_bankAcc : RoundButton!
    @IBOutlet weak var txt_Description : RoundTextView!
    
    
    //MARK:- ---- View Life Cycle ---
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentType = "0"
        self.txt_Description.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 15)
        setTitle()
        if self.eventID != ""
        {
            Connection.svprogressHudShow(view: self)
            dataSource2.delegate = self
            dataSource2.eventID = self.eventID
            dataSource2.getEvent()
            dataSource2.getProducts()
            
        }
        self.txt_StartDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_StartTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        hideKeyboardWhenTappedArround()
        dataSource.delegate = self
        dataSource.isEdit = self.isEdit
    }
   
    private func setTitle()
    {
        if isEdit ?? false
        {
            lbl_Title.text = "Edit Event"
            btn_CreateEvent.setTitle("Update Event", for: .normal)
        }
        else
        {
            lbl_Title.text = "Host Event"
            btn_CreateEvent.setTitle("Create Event", for: .normal)
        }
    }
   
    @objc func donePressed()
    {
        let dateFormatter=DateFormatter()
        switch fieldTag {
        case 0:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateString = dateFormatter.string(from: picker.date)
            self.startDate = dateString
            self.btn_StartDate.setTitle(dateString, for: .normal)
            self.btn_StartDate.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            self.view.endEditing(true)
        case 1:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.endDate = dateString
            self.btn_EndDate.setTitle(dateString, for: .normal)
            self.btn_EndDate.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            self.view.endEditing(true)
        case 2:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm:ss"
            let dateString = dateFormatter.string(from:picker.date)
            self.startTime = dateString
            dateFormatter.dateFormat = "hh:mm"
            let btnTitle = dateFormatter.string(from: picker.date)
            self.btn_StartTime.setTitle(btnTitle, for: .normal)
            self.btn_StartTime.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            self.view.endEditing(true)
        default:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm:ss"
            let dateString = dateFormatter.string(from:picker.date)
            self.endTime = dateString
            dateFormatter.dateFormat = "hh:mm"
            let btnTitle = dateFormatter.string(from: picker.date)
            self.btn_EndTime.setTitle(btnTitle, for: .normal)
            self.btn_EndTime.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            self.view.endEditing(true)
        }
        
    }
    func createToolBar()->UIToolbar
    {
        //tool bar
        let toolBar=UIToolbar()
        toolBar.sizeToFit()
        //bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: false)
        return toolBar
    }
    @objc func callDatePicker(field:UITextField)
    {
        picker=UIDatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
            
        } else {
            // Fallback on earlier versions
        }
        
        fieldTag = field.tag
        switch field.tag  {
        case 0:
            picker.datePickerMode = .date
            picker.minimumDate = Date()
            txt_StartDate.inputView = picker
            txt_StartDate.inputAccessoryView = createToolBar()
        case 1:
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                txt_EndDate.resignFirstResponder()
                break
            }
            else
            {
                picker.datePickerMode = .date
                txt_EndDate.inputView = picker
                txt_EndDate.inputAccessoryView = createToolBar()
            }
        case 2:
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                txt_StartTime.resignFirstResponder()
                break
            }
            if endDate == ""
            {
                self.view.makeToast("First Enter End Date", duration: 1, position: .center)
                txt_StartTime.resignFirstResponder()
                break
            }
            if startDate == "" && endDate == ""
            {
                self.view.makeToast("First Enter Start Date and End Date", duration: 1, position: .center)
                txt_StartTime.resignFirstResponder()
                break
            }
            else
            {
                picker.datePickerMode = .time
                txt_StartTime.inputView = picker
                txt_StartTime.inputAccessoryView = createToolBar()
            }
        default:
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            if startDate == "" && endDate == ""
            {
                self.view.makeToast("First Enter Start Date and End Date", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            if startTime == ""
            {
                self.view.makeToast("First Enter Start Time", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            else
            {
                picker.datePickerMode = .time
                txt_EndTime.inputView = picker
                txt_EndTime.inputAccessoryView = createToolBar()
            }
        }
        
    }
    //MARK:- ---- Action ---
    
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
    
    @IBAction func btn_AddPic(_ sender:UIButton)
    {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.img_EventPic.image = img
            self.view_Dashed.isHidden = true
            self.pickedImage = img
            self.images["identity_img"] = img
        }
    }
    
    @IBAction func btn_SelectEvent(_ sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseEventTypeVC") as? ChooseEventTypeVC
        vc?.selectedEventData = { [weak self] (eventName,selectedID) in
            guard let self = self else {return}
            self.btn_EventTitle.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            self.btn_EventTitle.setTitle(eventName, for: .normal)
            self.selectedEventId = selectedID
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btn_back(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_Paypaz(_ sender:UIButton) {
        self.paymentType = "0"
        self.btn_Paypaz.border_Color   = UIColor(named: "GreenColor")
        self.btn_bankAcc.border_Color  = UIColor.lightGray
        self.btn_Paypaz.setImage(UIImage(named: "pay"), for: .normal)
        self.btn_bankAcc.setImage(UIImage(named: "surface_icons"), for: .normal)
    }
    @IBAction func btn_bankAccount(_ sender:UIButton) {
        self.paymentType = "1"
        self.btn_bankAcc.border_Color = UIColor(named: "GreenColor")
        self.btn_Paypaz.border_Color  = UIColor.lightGray
        self.btn_Paypaz.setImage(UIImage(named: "paypaz_green"), for: .normal)
        self.btn_bankAcc.setImage(UIImage(named: "green_account"), for: .normal)
    }
    func convertToUTC(dateToConvert:String) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
         let convertedDate = formatter.date(from: dateToConvert)
         formatter.timeZone = TimeZone(identifier: "UTC")
         return formatter.string(from: convertedDate!)
            
        }
    @IBAction func btn_CreateEvent(_ sender:UIButton) {
        
        if(img_EventPic.image == nil)
        {
            self.view.makeToast("Add Event Image")
        }
        else if(txt_EventName.text?.trim().count == 0)
        {
            self.view.makeToast("Enter Event Name")
        }
        else if(selectedEventId?.trim().count == 0)
        {
            self.view.makeToast("Select Event Type")
        }
        else if(txt_Price.text?.trim().count == 0)
        {
            self.view.makeToast("Enter Price")
        }
        else if(txt_EventQuantity.text?.trim().count == 0)
        {
            self.view.makeToast("Enter Event Quantity")
        }
        else if(location.trim().count == 0)
        {
            self.view.makeToast("Add Location")
        }
        else if(startDate.trim().count == 0)
        {
            self.view.makeToast("Enter Start Date")
        }
        else if(endDate.trim().count == 0)
        {
            self.view.makeToast("Enter End Date")
        }
        else if(startTime.trim().count == 0)
        {
            self.view.makeToast("Enter Start Time")
        }
        else if(endTime.trim().count == 0)
        {
            self.view.makeToast("Enter End Time")
        }
        else if(txt_Description.text.trim().count == 0)
        {
            self.view.makeToast("Enter Description")
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.eventImg = img_EventPic.image
            dataSource.name = txt_EventName.text ?? ""
            dataSource.typeId = selectedEventId ?? ""
            dataSource.price = txt_Price.text ?? ""
            dataSource.eventQuantity = txt_EventQuantity.text ?? ""
            dataSource.location = self.location
            var sD = startDate + " " + startTime
            var eD = endDate + " " + endTime
            sD = convertToUTC(dateToConvert: sD)
            eD = convertToUTC(dateToConvert: eD)
            dataSource.startDate = sD
            dataSource.endDate = eD
            dataSource.eventDescription = txt_Description.text ?? ""
            dataSource.paymentType = paymentType ?? ""
           
            if isEdit ?? false
            {
                dataSource.eventID = self.eventID
                dataSource.updateEvent()
            }
            else
            {
                dataSource.addEvent()
            }
        }
    }
}
extension HostEventVC: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name ?? "")")
        print("Place address: \(place.formattedAddress ?? "")")
        //print("Place attributions: \(place.attributions!)")
        self.location = place.name ?? ""
        self.btn_ChooseLocation.setTitle(place.name ?? "", for: .normal)
        self.btn_ChooseLocation.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
        // let loc1 = (place.name ?? "")
        //let loc2 = (place.formattedAddress ?? "")
        //self.location_txt.text = loc1
        //print(self.location_txt.text)
        // let lat = place.coordinate.latitude
        // self.event_latitude = lat
        //  print("Place Latitude: \(self.event_latitude)")
        //let long = place.coordinate.longitude
        // self.event_longitude = long
        // print("Place Longitude: \(self.event_longitude)")
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
extension HostEventVC : HostEventDataModelDelegate
{
    func didRecieveDataUpdate(data: HostEventModel)
    {
        print("HostEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if isEdit ?? false
            {
                self.navigationController?.popViewController(animated: false)
            }
            else
            {
                _ = self.pushVC("AddEventProductsVC")
                if let vc = self.pushVC("AddEventProductsVC") as? AddEventProductsVC{
                    vc.eventID = data.data?.id ?? ""
                }
//                eventID = data.data?.id ?? ""
//                if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
//                    popup.selectedPopupType = .eventCreatedSuccess
//                    popup.delegate = self
//                }
            }
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError3(error: Error)
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
extension HostEventVC : MyPostedEventDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedEventModel)
    {
        print("MyPostedEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            DispatchQueue.main.async {
                self.txt_EventName.text = data.data?.name
                self.txt_Price.text = data.data?.price
                switch data.data?.typeID
                {
                case "1" : self.btn_EventTitle.setTitle("Sports & Fitness", for: .normal)
                    self.selectedEventId = "1"
                case "2" : self.btn_EventTitle.setTitle("Music", for: .normal)
                    self.selectedEventId = "2"
                case "3" : self.btn_EventTitle.setTitle("Festival", for: .normal)
                    self.selectedEventId = "3"
                case "4" : self.btn_EventTitle.setTitle("Charity & Causes", for: .normal)
                    self.selectedEventId = "4"
                case "5" : self.btn_EventTitle.setTitle("Seminar", for: .normal)
                    self.selectedEventId = "5"
                case "6" : self.btn_EventTitle.setTitle("Neighbour", for: .normal)
                    self.selectedEventId = "6"
                case "7" : self.btn_EventTitle.setTitle("Education", for: .normal)
                    self.selectedEventId = "7"
                default : self.btn_EventTitle.setTitle("Other", for: .normal)
                    self.selectedEventId = "8"
                }
                self.startDate = data.data?.startDate ?? ""
                self.endDate = data.data?.endDate ?? ""
                self.startTime = data.data?.startTime ?? ""
                self.endTime = data.data?.endTime ?? ""
                
                self.btn_ChooseLocation.setTitle(data.data?.location, for: .normal)
                self.btn_StartDate.setTitle(self.startDate, for: .normal)
                self.btn_EndDate.setTitle(self.endDate, for: .normal)
                self.btn_StartTime.setTitle(self.startTime, for: .normal)
                self.btn_EndTime.setTitle(self.endTime, for: .normal)
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                self.img_EventPic.sd_setImage(with: URL(string: url+(data.data?.image ?? "")), placeholderImage: UIImage(named: "profile_c"))
                self.view_Dashed.isHidden = true
                self.paymentType = data.data?.paymentType ?? " "
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

