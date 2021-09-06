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
protocol EditEventDelegate : class {
    func editEventData(data : MyEvent?, eventID : String)
    
}
class HostEventVC : UIViewController {
    
    var isEdit : Bool?
    var eventID = ""
    private let dataSource2 = MyPostedEventDataModel()
    weak var editEventDelegate : EditEventDelegate?
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
    var paymentStatus = "0"
    
    
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
    @IBOutlet weak var view_PaymentMethod : UIView!
    @IBOutlet weak var view_Height : NSLayoutConstraint!
    @IBOutlet weak var btn_Free : UIButton!
    @IBOutlet weak var btn_Paid : UIButton!
    var toolBar:UIToolbar!
    
    //MARK:- ---- View Life Cycle ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.paymentType = "0"
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
            btn_CreateEvent.setTitle("Save", for: .normal)
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
            self.sDate = picker.date
            self.startTime = ""
            self.endDate = ""
            self.endTime = ""
            self.txt_EndDate.text?.removeAll()
            self.txt_StartTime.text?.removeAll()
            self.txt_EndTime.text?.removeAll()
            self.view.endEditing(true)
            
        case 20:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.endDate = dateString
            self.txt_EndDate.text = dateString
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
            self.sTime = picker.date
            if startDate == endDate{
                self.endTime = ""
                self.txt_EndTime.text?.removeAll()
            }
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
        //Tool bar
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        //Bar button item
        let doneBtn=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: false)
        return toolBar
    }
    @objc func callDatePicker(field:UITextField)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
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
                picker.minimumDate = sDate
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
                if startDate == currentDate
                {
                    picker.minimumDate = Date()
                }
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
                if startDate == endDate
                {
                    picker.minimumDate = sTime
                }
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
    @IBAction func btn_DoPayment(_ sender:UIButton){
        paymentStatus = "\(sender.tag)"
        if sender.tag == 0{
            btn_Paid.setImage(UIImage(named: "blue_tick"), for: .normal)
            btn_Free.setImage(UIImage(named: "white_circle"), for: .normal)
        }
        else{
            btn_Free.setImage(UIImage(named: "blue_tick"), for: .normal)
            btn_Paid.setImage(UIImage(named: "white_circle"), for: .normal)
        }
        if paymentStatus == "0"{
            view_PaymentMethod.isHidden = false
            view_Height.constant = 125.5
            txt_Price.isHidden = false
        }
        else{
            view_PaymentMethod.isHidden = true
            view_Height.constant = 0
            txt_Price.isHidden = true
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
        else if paymentStatus == "0" && (txt_Price.text?.trim().count == 0)
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
            var sD = startDate + " " + startTime
            var eD = endDate + " " + endTime
            sD = sD.localToUTC(incomingFormat: "yyyy-MM-dd hh:mm a", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
            eD = eD.localToUTC(incomingFormat: "yyyy-MM-dd hh:mm a", outGoingFormat: "yyyy-MM-dd HH:mm:ss")
            
            dataSource.typeId = selectedEventId ?? ""
            dataSource.name = txt_EventName.text ?? ""
            dataSource.eventDescription = txt_Description.text ?? ""
            dataSource.location = self.location
            dataSource.startDate = sD
            dataSource.endDate = eD
            if paymentStatus == "0" || paymentStatus == "1"{
                dataSource.paymentType = paymentType ?? ""
                dataSource.price = txt_Price.text ?? ""
            }
            else{
                dataSource.paymentType = "2"
            }
            dataSource.latitude = self.latitude
            dataSource.longitude = self.longitude
            dataSource.eventImg = img_EventPic.image
            dataSource.eventQuantity = txt_EventQuantity.text ?? ""
            Connection.svprogressHudShow(view: self)
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
                self.editEventDelegate?.editEventData(data: data.data, eventID: data.data?.id ?? "")
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
                self.btn_EventTitle.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
                self.btn_EventTitle.setTitle(data.data?.typeName, for: .normal)
                self.selectedEventId = data.data?.typeID
                self.txt_EventQuantity.text = data.data?.quantity
                
                var sDate = data.data?.startDate ?? ""
                sDate = sDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
                var eDate = data.data?.endDate ?? ""
                eDate = eDate.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm a")
                self.startDate = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "yyyy-MM-dd")
                self.endDate = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "yyyy-MM-dd")
                self.startTime = self.getFormattedDate(strDate: sDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
                self.endTime = self.getFormattedDate(strDate: eDate, currentFomat: "yyyy-MM-dd hh:mm a", expectedFromat: "hh:mm a")
                self.txt_StartDate.text = self.startDate
                self.txt_EndDate.text = self.endDate
                self.txt_StartTime.text = self.startTime
                self.txt_EndTime.text = self.endTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.sDate = dateFormatter.date(from: self.startDate)!
                self.eDate = dateFormatter.date(from: self.endDate)!
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                self.sTime = dateFormatter.date(from: data.data?.startDate ?? "")!
                
                
                self.lbl_ChooseLocation.text = data.data?.location
                self.lbl_ChooseLocation.textColor = UIColor(named: "BlueColor")
                self.location = data.data?.location ?? ""
                self.latitude = data.data?.latitude ?? ""
                self.longitude = data.data?.longitude ?? ""
                
                
                self.txt_Description.text = data.data?.dataDescription
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                self.img_EventPic.sd_setImage(with: URL(string: url+(data.data?.image ?? "")), placeholderImage: UIImage(named: "profile_c"))
                self.view_Dashed.isHidden = true
                self.paymentStatus = data.data?.paymentType ?? ""
                if data.data?.paymentType == "2"{
                    self.btn_Free.setImage(UIImage(named: "blue_tick"), for: .normal)
                    self.btn_Paid.setImage(UIImage(named: "white_circle"), for: .normal)
                    self.view_PaymentMethod.isHidden = true
                    self.view_Height.constant = 0
                    self.txt_Price.isHidden = true
                }
                else{
                    self.btn_Paid.setImage(UIImage(named: "blue_tick"), for: .normal)
                    self.btn_Free.setImage(UIImage(named: "white_circle"), for: .normal)
                    self.txt_Price.text = "\(((data.data?.price)! as NSString).integerValue)"
                    self.paymentType = data.data?.paymentType ?? " "
                }
                
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
