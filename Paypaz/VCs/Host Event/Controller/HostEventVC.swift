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
    var products = [MyProducts](){
        didSet{
            for i in 0..<self.products.count
            {
                self.productIDArr.append(self.products[i].id)
                self.productArr.append(["image" : products[i].image,"price" : products[i].price,"name" : products[i].name,"description" : products[i].datumDescription,"fromServer" : true])
            }
        }
    }
    
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
    var isPublicStatus = ""
    var isInviteMemberStatus = ""
    var productIDArr = [String]()
    var productArr = [[String:Any]]()
    weak var delegate : PopupDelegate?
    private let dataSource = HostEventDataModel()
    
    var selectedEventId : String?
    var btn_Title:String?
    var fieldTag:Int?
    
    
    
    //MARK:- ----
    @IBOutlet weak var view_Dashed : UIView!
    @IBOutlet weak var lbl_Title : UILabel!
    @IBOutlet weak var img_EventPic : UIImageView!
    @IBOutlet weak var txt_EventName : UITextField!
    @IBOutlet weak var btn_ChooseLocation : UIButton!
    @IBOutlet weak var btn_Price : UIButton!
    @IBOutlet weak var txt_Price : UITextField!
    @IBOutlet weak var btn_StartDate : UIButton!
    @IBOutlet weak var txt_StartDate : UITextField!
    @IBOutlet weak var btn_EndDate : UIButton!
    @IBOutlet weak var txt_EndDate : UITextField!
    @IBOutlet weak var btn_StartTime : UIButton!
    @IBOutlet weak var txt_StartTime : UITextField!
    @IBOutlet weak var btn_EndTime : UIButton!
    @IBOutlet weak var txt_EndTime : UITextField!
    @IBOutlet weak var btn_EventTitle           : UIButton!
    @IBOutlet weak var isPublic : UISwitch!
    @IBOutlet weak var isInviteMember : UISwitch!
    @IBOutlet weak var view_addNewBtn           : UIView!
    @IBOutlet weak var btn_CreateEvent : UIButton!
    @IBOutlet weak var btn_Paypaz               : RoundButton!
    @IBOutlet weak var btn_bankAcc              : RoundButton!
    
    
    //MARK:- ---- View Life Cycle ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        if self.eventID != ""
        {
            Connection.svprogressHudShow(view: self)
            dataSource2.delegate = self
            dataSource2.delegate2 = self
            dataSource2.eventID = self.eventID
            dataSource2.getEvent()
            dataSource2.getProducts()
            
        }
        self.txt_StartDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndDate.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_StartTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_EndTime.addTarget(self, action: #selector(callDatePicker(field:)), for: .editingDidBegin)
        self.txt_Price.addTarget(self, action: #selector(givePrice), for: .editingDidBegin)
        self.isPublic.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
        self.isInviteMember.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
        hideKeyboardWhenTappedArround()
        dataSource.delegate = self
        self.view_addNewBtn.isHidden = true
        dataSource.isEdit = self.isEdit
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedContactsInfo(notification:)), name: Notification.Name("MessageReceived"), object: nil)
    }
    @objc func fetchedContactsInfo(notification:Notification)
    {
        if let contactInfo: ContactInfo = notification.object as? ContactInfo {
            let contactNames = contactInfo.firstName
            print(contactNames ?? "")
        }
        
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
    @objc func givePrice()
    {
        self.btn_Price.setTitle("", for: .normal)
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
            //self.btn_StartDate.setTitleColor(.black, for: .normal)
            self.btn_StartDate.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        case 1:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.endDate = dateString
            //self.btn_EndDate.setTitleColor(.black, for: .normal)
            self.btn_EndDate.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        case 2:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.startTime = dateString
            //self.btn_StartTime.setTitleColor(.black, for: .normal)
            self.btn_StartTime.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        default:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.endTime = dateString
            //self.btn_EndTime.setTitleColor(.black, for: .normal)
            self.btn_EndTime.setTitle(dateString, for: .normal)
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
            showAlert(withMsg: "Give Event Image", withOKbtn: true)
        }
        else if(txt_EventName.text == "")
        {
            showAlert(withMsg: "Enter Event Name", withOKbtn: true)
        }
        else if(selectedEventId == "")
        {
            showAlert(withMsg: "Select Event Type", withOKbtn: true)
        }
        else if(txt_Price.text == "")
        {
            showAlert(withMsg: "Enter Price", withOKbtn: true)
        }
        else if(location == "")
        {
            showAlert(withMsg: "Add Location", withOKbtn: true)
        }
        else if(startDate == "")
        {
            showAlert(withMsg: "Enter Start Date", withOKbtn: true)
        }
        else if(endDate == "")
        {
            showAlert(withMsg: "Enter End Date", withOKbtn: true)
        }
        else if(startTime == "")
        {
            showAlert(withMsg: "Enter Start Time", withOKbtn: true)
        }
        else if(endTime == "")
        {
            showAlert(withMsg: "Enter End Time", withOKbtn: true)
        }
        else
        {
            Connection.svprogressHudShow(view: self)
            dataSource.eventImg = img_EventPic.image
            dataSource.name = txt_EventName.text ?? ""
            dataSource.typeId = selectedEventId ?? ""
            dataSource.price = txt_Price.text ?? ""
            dataSource.location = self.location
            dataSource.startDate = startDate
            dataSource.endDate = endDate
            dataSource.startTime = startTime
            dataSource.endTime = endTime
            dataSource.paymentType = paymentType ?? ""
            dataSource.isInviteMember = isInviteMemberStatus
            dataSource.eventID = self.eventID
            var products:String = ""
            for i in 0..<productIDArr.count
            {
                if(i == productIDArr.count-1)
                {
                    products += "\(productIDArr[i])"
                }
                else
                {
                    products += "\(productIDArr[i]),"
                }
            }
            dataSource.products = products
            if isEdit ?? false
            {
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
                eventID = data.data?.id ?? ""
                if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                    popup.selectedPopupType = .eventCreatedSuccess
                    popup.delegate = self
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
                self.btn_Price.setTitle("", for: .normal)
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
                self.isPublicStatus = data.data?.ispublic ?? ""
                self.isPublicStatus == "1" ? self.isPublic.setOn(true, animated: false) : self.isPublic.setOn(false, animated: false)
                self.isInviteMemberStatus = data.data?.isinviteMember ?? ""
                self.isInviteMemberStatus == "1" ? self.isInviteMember.setOn(true, animated: false) : self.isInviteMember.setOn(false, animated: false)
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

extension HostEventVC : MyPostedProductsDataModelDelegate
{
    func didRecieveDataUpdate(data: MyPostedProductsModel)
    {
        print("MyPostedProductsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            products = data.data
            DispatchQueue.main.async {
                //self.tableView_Products.reloadData()
            }
        }
        else
        {
            self.showAlert(withMsg: data.message , withOKbtn: true)
        }
    }
    
    func didFailDataUpdateWithError2(error: Error)
    {
        Connection.svprogressHudDismiss(view: self)
        if error.localizedDescription == "Check Internet Connection"
        {
            self.showAlert(withMsg: "Please Check Your Internet Connection", withOKbtn: true)
        }
        else
        {
            self.view.makeToast("No Products Data", duration: 3, position: .bottom)
            //  self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
