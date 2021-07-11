//
//  HostEventVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 16/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import SDWebImage
class HostEventVC : CustomViewController {
    
    var isEdit : Bool? //The value for isEdit comes from MyEventsListVC+Extensions (60th line)
    var eventID = ""
    private let dataSource2 = MyPostedEventDataModel()
    var products = [MyProducts]()
    
    var pickedImage : UIImage?
    var fontCamera  = false
    var images      = [String:Any]()
    var picker:UIDatePicker!
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var paymentType = ""
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
    @IBOutlet weak var btn_clickToAdd           : RoundButton!
    @IBOutlet weak var tableView_Products       : UITableView!{
        didSet{
            tableView_Products.dataSource = self
            tableView_Products.delegate   = self
        }
    }
    @IBOutlet weak var tableView_ProductsHeight : NSLayoutConstraint!
    @IBOutlet weak var tableView_Members        : UITableView!{
        didSet{
            tableView_Members.dataSource = self
            tableView_Members.delegate   = self
        }
    }
    @IBOutlet weak var tableView_MembersHeight  : NSLayoutConstraint!
    @IBOutlet weak var btn_Paypaz               : RoundButton!
    @IBOutlet weak var btn_bankAcc              : RoundButton!
    
    
    //MARK:- ---- View Life Cycle ---
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        if self.eventID != ""
        {
            Connection.svprogressHudShow(title: "Please Wait", view: self)
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
        self.hideKeyboardWhenTappedAround()
        dataSource.delegate = self
        self.view_addNewBtn.isHidden = true
        self.tableView_ProductsHeight.constant = 0.0
        
    }
    private func setTitle()
    {
        if isEdit ?? false
        {
            lbl_Title.text = "Edit Event"
        }
        else
        {
            lbl_Title.text = "Host Event"
        }
    }
    @objc func onSwitchValueChange(swtch:UISwitch)
    {
        switch swtch.tag{
        case 0:
            if(swtch.isOn == true)
            {
                self.isPublicStatus = "1"
            }
            else
            {
                self.isPublicStatus = "0"
            }
        default:
            if(swtch.isOn == true)
            {
                self.tableView_Members.isHidden = false
                self.isInviteMemberStatus = "1"
            }
            else
            {
                self.tableView_Members.isHidden = true
                self.isInviteMemberStatus = "0"
            }
            
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
            self.btn_StartDate.setTitleColor(.black, for: .normal)
            self.btn_StartDate.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        case 1:
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: picker.date)
            self.endDate = dateString
            self.btn_EndDate.setTitleColor(.black, for: .normal)
            self.btn_EndDate.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        case 2:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.startTime = dateString
            self.btn_StartTime.setTitleColor(.black, for: .normal)
            self.btn_StartTime.setTitle(dateString, for: .normal)
            self.view.endEditing(true)
        default:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let dateString = dateFormatter.string(from:picker.date)
            self.endTime = dateString
            self.btn_EndTime.setTitleColor(.black, for: .normal)
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
        toolBar.setItems([doneBtn], animated: true)
        return toolBar
    }
    @objc func callDatePicker(field:UITextField)
    {
        picker=UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        fieldTag = field.tag
        switch field.tag  {
        case 0:
            picker.datePickerMode = .date
            txt_StartDate.inputView = picker
            txt_StartDate.inputAccessoryView = createToolBar()
        case 1:
            
            picker.datePickerMode = .date
            txt_EndDate.inputView = picker
            txt_EndDate.inputAccessoryView = createToolBar()
        case 2:
            picker.datePickerMode = .time
            txt_StartTime.inputView = picker
            txt_StartTime.inputAccessoryView = createToolBar()
        default:
            picker.datePickerMode = .time
            txt_EndTime.inputView = picker
            txt_EndTime.inputAccessoryView = createToolBar()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView_MembersHeight.constant = self.tableView_Members.contentSize.height
        if self.btn_clickToAdd.isHidden {
            self.tableView_ProductsHeight.constant = self.tableView_Products.contentSize.height
        }
    }
    //MARK:- ---- Action ---
    
    
    
    @IBAction func btn_AddPic(_ sender:UIButton)
    {
        ImagePickerController.init().pickImage(self, isCamraFront:fontCamera) { (img) in
            self.img_EventPic.image = img
            self.pickedImage = img
            self.images["identity_img"] = img
        }
    }
    
    @IBAction func btn_SelectEvent(_ sender:UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChooseEventTypeVC") as? ChooseEventTypeVC
        vc?.selectedEventData = { [weak self] (eventName,selectedID) in
            guard let self = self else {return}
            self.btn_EventTitle.setTitleColor(.black, for: .normal)
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
    @IBAction func btn_addNewProduct(_ sender:UIButton) {
        if let addProduct = self.presentPopUpVC("AddProductVC", animated: true) as? AddProductVC {
            addProduct.delegate = self
            
            addProduct.callback = { item in
                self.productArr.append(["image" : item["productImage"]!,"price" : item["productPrice"]!,"name" : item["productName"]!,"description" : item["productDescription"]!])
                self.productIDArr.append(item["productID"] as! String)
                self.btn_clickToAdd.isHidden = true
                self.view_addNewBtn.isHidden = false
                DispatchQueue.main.async {
                    self.tableView_ProductsHeight.constant = CGFloat(self.productArr.count * 60)
                    self.tableView_Products.reloadData()
                }
            }
            
            
        }
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
            Connection.svprogressHudShow(title: "Please wait", view: self)
            dataSource.eventImg = img_EventPic.image
            dataSource.name = txt_EventName.text ?? ""
            dataSource.typeId = selectedEventId ?? ""
            dataSource.price = txt_Price.text ?? ""
            dataSource.location = "Ongole, Andhra Pradesh"
            dataSource.startDate = startDate
            dataSource.endDate = endDate
            dataSource.startTime = startTime
            dataSource.endTime = endTime
            dataSource.paymentType = paymentType
            dataSource.isPublic = isPublicStatus
            dataSource.isInviteMember = isInviteMemberStatus
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
            dataSource.addEvent()
        }
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
            
            if let popup = self.presentPopUpVC("SuccessPopupVC", animated: false) as? SuccessPopupVC {
                popup.selectedPopupType = .eventCreatedSuccess
                popup.delegate = self
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
                self.btn_Price.setTitle(data.data?.price, for: .normal)
                self.btn_Price.setTitleColor(.black, for: .normal)
                self.btn_ChooseLocation.setTitle(data.data?.location, for: .normal)
                self.btn_ChooseLocation.setTitleColor(.black, for: .normal)
                self.btn_StartDate.setTitle(data.data?.startDate, for: .normal)
                self.btn_StartDate.setTitleColor(.black, for: .normal)
                self.btn_EndDate.setTitle(data.data?.endDate, for: .normal)
                self.btn_EndDate.setTitleColor(.black, for: .normal)
                self.btn_StartTime.setTitle(data.data?.startTime, for: .normal)
                self.btn_StartTime.setTitleColor(.black, for: .normal)
                self.btn_EndTime.setTitle(data.data?.endTime, for: .normal)
                self.btn_EndTime.setTitleColor(.black, for: .normal)
                self.img_EventPic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                let url =  APIList().getUrlString(url: .UPLOADEDEVENTIMAGE)
                self.img_EventPic.sd_setImage(with: URL(string: url+(data.data?.image ?? "")), placeholderImage: UIImage(named: "profile_c"))
                self.isPublicStatus = data.data?.ispublic ?? ""
                self.isPublicStatus == "1" ? self.isPublic.setOn(true, animated: false) : self.isPublic.setOn(false, animated: false)
                self.isInviteMemberStatus = data.data?.isinviteMember ?? ""
                self.isInviteMemberStatus == "1" ? self.isInviteMember.setOn(true, animated: false) : self.isInviteMember.setOn(false, animated: false)
                self.paymentType = data.data?.paymentType ?? ""
                self.paymentType == "0" ? (self.btn_Paypaz.border_Color = UIColor(named:"GreenColor")) : (self.btn_bankAcc.border_Color = UIColor(named: "GreenColor"))
                 
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
            self.tableView_ProductsHeight.constant = CGFloat((self.products.count) * 60)
            DispatchQueue.main.async {
                self.btn_clickToAdd.isHidden = true
                self.view_addNewBtn.isHidden = false
                
                self.tableView_Products.reloadData()
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
            self.showAlert(withMsg: error.localizedDescription, withOKbtn: true)
        }
    }
}
