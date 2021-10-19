//
//  InviteMembersVC.swift
//  Paypaz
//
//  Created by MAC on 18/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
import Contacts
import libPhoneNumber_iOS
protocol EditInviteMemberDelegate : class {
    func editInviteData(data : [String:String]?, eventID : String)
    
}
class InviteMembersVC: CustomViewController {
    
    var img = UIImage()
    var contactDetails = [ContactInfo]()
    var isPublicStatus = "0"
    var isInviteMemberStatus = "0"
    var eventID = ""
    var isEdit : Bool? = false
    var invitedContacts = [InvitedContacts]()
    var contactDict = [String:String]()
    var contactArray = [[String:String]]()
    private let dataSource = InviteMemberDataModel()
    private let dataSource1 = MyPostedEventDataModel()
    weak var editInviteMemberDelegate : EditInviteMemberDelegate?

    @IBOutlet weak var isPublic : UISwitch!
    @IBOutlet weak var isInviteMember : UISwitch!
    @IBOutlet weak var tableView_Members        : UITableView!{
        didSet{
            tableView_Members.separatorStyle = .none
            tableView_Members.dataSource = self
            tableView_Members.delegate   = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchContacts()
        dataSource.delegate = self
        self.isPublic.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
        self.isInviteMember.addTarget(self, action: #selector(onSwitchValueChange(swtch:)), for: .valueChanged)
    }
    private func sortContacts(){
        for i in 0..<contactDetails.count{
            for j in 0..<invitedContacts.count{
                if contactDetails[i].phoneNumber?.trimCharactersFromString(characters: ["+","-"]).removingWhitespaceAndNewlines() == (invitedContacts[j].phoneCode!)+(invitedContacts[j].phoneNumber!){
                    contactDetails[i].isInvited = true
                }
            }
        }
        tableView_Members.reloadData()
//        var filteredContacts = [ContactInfo]()
//        for m in contactDetails where invitedContacts.contains(where: { $0.phoneNumber == m.phoneNumber?.removingWhitespaceAndNewlines()}) {
//            m.isInvited = true
//        }
//        contactDetails = filteredContacts
//        tableView_Members.reloadData()
    }
    private func getInvitees()
    {
        if isPublicStatus == "0"{
            isPublic.setOn(false, animated: false)
        }
        else{
            isPublic.setOn(true, animated: false)
        }
        if isInviteMemberStatus == "0"{
            isInviteMember.setOn(false, animated: false)
        }
        else{
            isInviteMember.setOn(true, animated: false)
            isInviteMember.isUserInteractionEnabled = false
            Connection.svprogressHudShow(view: self)
            dataSource1.eventID = self.eventID
            dataSource1.getContacts()
        }
        
    }
    func fetchContacts(completion: @escaping (_ result: [CNContact]) -> Void){
        DispatchQueue.main.async {
            var results = [CNContact]()
            let keys = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactMiddleNameKey,CNContactEmailAddressesKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey,CNContactUrlAddressesKey,CNContactPostalAddressesKey] as [CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
            fetchRequest.sortOrder = CNContactSortOrder.userDefault
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: {(grant,error) in
                if grant{
                    do {
                        try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                            results.append(contact)
                        })
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                    completion(results)
                    
                }else{
                    print("Error \(error?.localizedDescription ?? "")")
                }
                if self.isEdit ?? false{
                    self.dataSource1.delegate3 = self
                    self.getInvitees()
                }
            })
        }
        
    }
    func fetchContacts()
    {
        fetchContacts(completion: {contacts in
            contacts.forEach({print("Name: \($0.givenName), number: \($0.phoneNumbers.first?.value.stringValue ?? "nil"), CountryCode: \($0.postalAddresses.first?.value.isoCountryCode ?? "nil")")
                
                if $0.thumbnailImageData != nil
                {
                    self.img = UIImage.init(data: $0.thumbnailImageData!)!
                    
                }
                else{
                    self.img = UIImage(named: "place_holder")!
                }
                if ((($0.phoneNumbers.first?.value.stringValue ?? "nil")?.contains("+")) == true){
                    
                    let phoneNumber = "\($0.phoneNumbers.first?.value.stringValue ?? "nil")"
                    let contactDetail = ContactInfo(firstName: $0.givenName, lastName: $0.familyName, phoneNumber:phoneNumber, profilePic:self.img, isInvited: false)
                    self.contactDetails.append(contactDetail)
                }
            })
        })
    }
    @objc func onSwitchValueChange(swtch:UISwitch)
    {
        switch swtch.tag{
        case 0:
            if(swtch.isOn)
            {
                self.isPublicStatus = "1"
            }
            else
            {
                self.isPublicStatus = "0"
            }
        default:
            if(swtch.isOn)
            {
                self.isInviteMemberStatus = "1"
            }
            else
            {
                self.isInviteMemberStatus = "0"
            }
            self.tableView_Members.reloadData()
        }
    }
    @IBAction func btn_Back(_ sender:UIButton){
        if isEdit ?? false{
            self.navigationController?.popViewController(animated: false)
        }
        else{
            for vc in self.navigationController!.viewControllers as Array {
                if vc.isKind(of:EventVC.self) {
                    self.navigationController!.popToViewController(vc, animated: false)
                    break
                }
            }
        }
    }
    @IBAction func btn_Done(_ sender:UIButton)
    {
        dataSource.eventID = eventID
        dataSource.isPublic = isPublicStatus
        dataSource.isInviteMember = isInviteMemberStatus
        if isInviteMemberStatus == "1"{
            if contactArray.count == 0
            {
                view.makeToast("Please select atleast one member from contacts list to invite members")
            }
            else{
                let jsonData = try! JSONSerialization.data(withJSONObject:contactArray)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                print(jsonString!)
                dataSource.contacts = jsonString!
                Connection.svprogressHudShow(view: self)
                dataSource.inviteMembers()
            }
        }
        else{
            Connection.svprogressHudShow(view: self)
            dataSource.inviteMembers()
        }
    }
    
}
extension InviteMembersVC : MyPostedContactsDataModelDelegate
{
    func didRecieveDataUpdate3(data: MyPostedContactsModel)
    {
        print("MyPostedContactsModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            self.invitedContacts = data.data ?? []
            if self.invitedContacts.count > 0{
                self.sortContacts()
            }
        }
        else
        {
            print(data.message ?? "")
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
            self.view.makeToast(error.localizedDescription, duration: 3, position: .bottom)
        }
    }
}

extension InviteMembersVC : InviteMemberDataModelDelegate
{
    func didRecieveDataUpdate(data: ResendOTPModel)
    {
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            if isEdit ?? false{
                self.navigationController?.popViewController(animated: false)
                self.editInviteMemberDelegate?.editInviteData(data:["isPublic":isPublicStatus,"isInviteMember":isInviteMemberStatus],eventID:self.eventID)
            }
            else{
                for vc in self.navigationController!.viewControllers as Array {
                    if vc.isKind(of:EventVC.self) {
                        self.navigationController!.popToViewController(vc, animated: false)
                        break
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("getEventID"), object:nil, userInfo: ["eventID":self.eventID])
            }
            
        }
        else
        {
            view.makeToast(data.message ?? "")
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
extension InviteMembersVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInviteMemberStatus == "1"
        {
            return contactDetails.count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as? MemberCell else { return MemberCell() }
        cell.contactName_lbl.text = contactDetails[
            indexPath.row].firstName
        cell.contactNo_lbl.text = contactDetails[indexPath.row].phoneNumber
        cell.contactPic_img.image = contactDetails[indexPath.row].profilePic
        if contactDetails[indexPath.row].isInvited == true{
            cell.btn_tick.isSelected = true
            cell.btn_tick.isUserInteractionEnabled = false
        }
        else{
            let _ = contactDetails[indexPath.row].isSelected ?? false ? (cell.btn_tick.isSelected = true) : (cell.btn_tick.isSelected = false)
            cell.btn_tick.isUserInteractionEnabled = true
            cell.btn_tick.tag = indexPath.row
            cell.btn_tick.addTarget(self, action: #selector(btn_Selected(_:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func btn_Selected(_ sender:UIButton)
    {
        if sender.isSelected == true{
            sender.isSelected = false
            contactDetails[sender.tag].isSelected = false
            let flag = contactArray.contains(where:  { (abc) -> Bool in
                return abc["contactID"] ?? "" == "\(sender.tag)"
            })
            if flag{
                self.contactArray.removeAll(where: { (abc) -> Bool in
                    return abc["contactID"] ?? "" == "\(sender.tag)"
                })
            }
        }else{
            sender.isSelected = true
            contactDetails[sender.tag].isSelected = true
            contactDict["contactID"] = "\(sender.tag)"
            contactDict["name"] = contactDetails[sender.tag].firstName
            guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else {
                return
            }
            do {
                let numberProto: NBPhoneNumber = try phoneUtil.parse(contactDetails[sender.tag].phoneNumber, defaultRegion: "IN")
                let countryCode = numberProto.countryCode!
                let phoneNumber = numberProto.nationalNumber!
                contactDict["phoneCode"] = "\(countryCode)"
                contactDict["phoneNumber"] = "\(phoneNumber)"
                contactArray.append(contactDict)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
}
