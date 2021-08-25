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
class HostEventVC : UIViewController {
    
    var isEdit : Bool? //The value for isEdit comes from MyEventsListVC+Extensions (60th line)
    var eventID = ""
    private let dataSource2 = MyPostedEventDataModel()
    
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    var picker:UIDatePicker!
    var location = ""
    var latitude = ""
    var longitude = ""
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var sDate = Date()
    var sTime = Date()
    var eDate = Date()
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
    
    
    
    //MARK:- ---- Outlets ----
    @IBOutlet weak var view_Dashed : UIView!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var txt_EventName : RoundTextField!
    @IBOutlet weak var txt_EventQuantity : RoundTextField!
    @IBOutlet weak var view_ChooseLocation : UIView!
    @IBOutlet weak var lbl_ChooseLocation : UILabel!
    @IBOutlet weak var txt_Price : RoundTextField!
    @IBOutlet weak var txt_StartDate : RoundTextField!
    @IBOutlet weak var txt_EndDate : RoundTextField!
    @IBOutlet weak var txt_StartTime : RoundTextField!
    @IBOutlet weak var txt_EndTime : RoundTextField!
    @IBOutlet weak var btn_EventTitle : RoundButton!
    @IBOutlet weak var btn_CreateEvent : RoundButton!
    @IBOutlet weak var btn_Paypaz : RoundButton!
    @IBOutlet weak var btn_bankAcc : RoundButton!
    @IBOutlet weak var txt_Description : RoundTextView!
    var toolBar:UIToolbar!
    
    //MARK:- ---- View Life Cycle ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentType = "0"
        self.txt_Description.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 15)
        setTitle()
        if self.eventID != ""
        {
            Connection.svprogressHudShow(view: self)
            dataSource2.delegate = self
            dataSource2.eventID = self.eventID
            dataSource2.getEvent()
            
            
        }
        self.txt_StartDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_StartTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        hideKeyboardWhenTappedArround()
        dataSource.delegate = self
        dataSource.isEdit = self.isEdit
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(chooseLocation))
        view_ChooseLocation.addGestureRecognizer(tapGesture)
    }
    @objc func chooseLocation() {
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
        case 10:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateString = dateFormatter.string(from: picker.date)
            self.startDate = dateString
            self.txt_StartDate.text = dateString
            self.txt_StartDate.textColor = UIColor(named: "BlueColor")
            // Modification
            self.sDate = picker.date
            self.startTime = ""
            self.endDate = ""
            self.endTime = ""
            self.txt_EndDate.text?.removeAll()
            self.txt_StartTime.text?.removeAll()
            self.txt_EndTime.text?.removeAll()
            // upto here
            self.view.endEditing(true)
        case 20:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.endDate = dateString
            self.txt_EndDate.text = dateString
            // Modifications
            self.eDate = picker.date
            self.endTime = ""
            self.txt_EndTime.text?.removeAll()
            self.view.endEditing(true)
        case 30:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.startTime = dateString
            self.txt_StartTime.text = dateString
            // Modification
            self.sTime = picker.date
            if startDate == endDate{
                self.endTime = ""
                self.txt_EndTime.text?.removeAll()
            }
            // upto here
            self.view.endEditing(true)
        case 40:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.endTime = dateString
            self.txt_EndTime.text = dateString
            self.view.endEditing(true)
        default:
            return
        }
        
    }
    func createToolBar()->UIToolbar
    {
        //tool bar
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: false)
        return toolBar
    }
    @objc func callDatePicker(field:UITextField)
    {
        
        //Modification
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        //upto here
        if picker != nil{
            self.picker.removeFromSuperview()
            self.picker = nil
        }
        if toolBar != nil{
            self.toolBar.removeFromSuperview()
            self.toolBar = nil
        }
        switch field.tag  {
        case 10:
            picker=UIDatePicker()
            if #available(iOS 13.4, *) {
                picker.preferredDatePickerStyle = .wheels
                
            }
            picker.datePickerMode = .date
            picker.minimumDate = Date()
            txt_StartDate.inputView = picker
            txt_StartDate.inputAccessoryView = createToolBar()
            fieldTag = field.tag
        case 20:
            
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                self.view.endEditing(true)
                txt_EndDate.resignFirstResponder()
                break
            }
            else
            {
                picker=UIDatePicker()
                if #available(iOS 13.4, *) {
                    picker.preferredDatePickerStyle = .wheels
                    
                }
                picker.datePickerMode = .date
                //Modification
                picker.minimumDate = sDate //upto here
                txt_EndDate.inputView = picker
                txt_EndDate.inputAccessoryView = createToolBar()
                fieldTag = field.tag
            }
        case 30:
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                txt_StartTime.resignFirstResponder()
                break
            }
            else
            {
                picker=UIDatePicker()
                if #available(iOS 13.4, *) {
                    picker.preferredDatePickerStyle = .wheels
                    
                }
                picker.datePickerMode = .time
                //Modifications
                if startDate == currentDate
                {
                    picker.minimumDate = Date()
                }//upto here
                txt_StartTime.inputView = picker
                txt_StartTime.inputAccessoryView = createToolBar()
                fieldTag = field.tag
            }
        case 40:
            if startDate == ""
            {
                self.view.makeToast("First Enter Start Date", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            if endDate == ""
            {
                self.view.makeToast("First Enter End Date", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            if startDate == endDate && startTime == ""
            {
                self.view.makeToast("First Enter Start Time", duration: 1, position: .center)
                txt_EndTime.resignFirstResponder()
                break
            }
            else
            {
                picker=UIDatePicker()
                if #available(iOS 13.4, *) {
                    picker.preferredDatePickerStyle = .wheels
                    
                }
                picker.datePickerMode = .time
                //Modification
                if startDate == endDate
                {
                    picker.minimumDate = sTime
                }//upto here
                txt_EndTime.inputView = picker
                txt_EndTime.inputAccessoryView = createToolBar()
                fieldTag = field.tag
            }
        default:
            return
        }
    }
    //MARK:- ---- Action ---
   
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
            dataSource.latitude = self.latitude
            dataSource.longitude = self.longitude
            
            var sD = startDate + " " + startTime
            var eD = endDate + " " + endTime
            sD = sD.localToUTC(incomingFormat: "yyyy-MM-dd hh:mm a", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
            eD = eD.localToUTC(incomingFormat: "yyyy-MM-dd hh:mm a", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
            
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
        self.location = place.formattedAddress ?? ""
        self.lbl_ChooseLocation.textColor = UIColor(named: "BlueColor")
        self.lbl_ChooseLocation.text = place.formattedAddress
        self.latitude = "\(place.coordinate.latitude)"
        self.longitude = "\(place.coordinate.longitude)"
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
                self.eventID = data.data?.id ?? ""
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessPopupVC") as? SuccessPopupVC
                {
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.selectedPopupType = .eventCreatedSuccess
                    vc.delegate = self
                    self.present(vc, animated: false, completion: nil)
                }
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
                self.btn_EventTitle.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
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
                self.txt_EventQuantity.text = data.data?.quantity
                self.startDate = data.data?.startDate ?? ""
                self.endDate = data.data?.endDate ?? ""
                self.startTime = data.data?.startTime ?? ""
                self.endTime = data.data?.endTime ?? ""
                self.lbl_ChooseLocation.text = data.data?.location
                self.lbl_ChooseLocation.textColor = UIColor(named: "BlueColor")
                self.txt_StartDate.text = self.startDate
                self.txt_EndDate.text = self.endDate
                self.txt_StartTime.text = self.startTime
                self.txt_EndTime.text = self.endTime
                self.txt_Description.text = data.data?.dataDescription
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
extension HostEventVC : PopupDelegate {
    
    func isClickedButton() {
        if let vc = self.pushVC("AddEventProductsVC",animated: false) as? AddEventProductsVC{
            vc.eventID = self.eventID
        }
    }
}
