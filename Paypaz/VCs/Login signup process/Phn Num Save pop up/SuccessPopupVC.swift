//
//  SuccessPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 19/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

@objc protocol PopupDelegate : class {
    func isClickedButton()
    @objc optional func passEventID(eventID : String)
}

protocol AcceptOrRejectInviteDelegate : class{
    func acceptOrReject(inviteID : String)
}

enum PopupType {
    case InviteAccept
    case InviteReject
    case PhoneSaved
    case EventAmountPaid
    case PaymentRequestSent
    case PayMoneyToContacts
    case eventCreatedSuccess
}

class SuccessPopupVC : CustomViewController {
    
    weak var delegate : PopupDelegate?
    var selectedPopupType : PopupType?
    weak var acceptOrRejectDelegate : AcceptOrRejectInviteDelegate?
    
    @IBOutlet weak var lbl_Title   : UILabel!
    @IBOutlet weak var lbl_message : UILabel!
    @IBOutlet weak var imgIcon     : UIImageView!
    
    var inviteID = ""
    private let dataSource = IsAcceptEventInviteDataModel()
    
    // MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if let type = self.selectedPopupType {
            switch type {
            
            case .InviteAccept:
                self.lbl_Title.text   = "Invitation Accepted"
                self.lbl_message.text = "You Have Accepted The Invitation"
                self.imgIcon.image = UIImage(named: "invi_accept")
                
                dataSource.delegate = self
                dataSource.inviteID = self.inviteID
                dataSource.isAccept = "1"
                dataSource.acceptOrInvite()
                Connection.svprogressHudShow(view: self)
                
            case .InviteReject:
                self.lbl_Title.text   = "Invitation Rejected"
                self.lbl_message.text = "You Have Rejected The Invitation"
                let redclr = UIColor(red: 0.94, green: 0.26, blue: 0.26, alpha: 1.00)
                self.lbl_Title.textColor = redclr
                self.imgIcon.image    = UIImage(named: "invi_reject")
                
                dataSource.delegate = self
                dataSource.inviteID = self.inviteID
                dataSource.isAccept = "2"
                dataSource.acceptOrInvite()
                Connection.svprogressHudShow(view: self)
                
            case .EventAmountPaid:
                self.lbl_Title.text   = "Amount Paid Successfully"
                //   self.lbl_message.text = "$ 840 has been paid for event name to John Deo bank a/c 03213543467567"
                self.setAttributed(for: "$ 840 has been paid for event name to John Deo bank account 03213543467567")
                
            case .PaymentRequestSent:
                self.lbl_Title.text   = "Payment Request Sent"
                //self.lbl_message.text = "$ 840 to john deo Mobile no. +1 9323848308"
                self.setAttributed(for: "$ 840 to John Deo Mobile no. +1 9323848308")
                self.imgIcon.image    = UIImage(named: "receive_icons")
                
            case .PayMoneyToContacts:
                self.lbl_Title.text   = "Amount Paid Successfully"
                //self.lbl_message.text = "$ 840 has been paid to event name to john deo"
                self.setAttributed(for: "$ 840 has been paid to event name to John Deo")
                
            case .eventCreatedSuccess:
                self.lbl_Title.textColor = UIColor(named: "BlueColor")
                self.lbl_Title.text   = "Event Created Successfully"
                self.lbl_message.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit In dui enim, ornare"
                
                self.imgIcon.image = UIImage(named: "event_created_icons")
            default:
                print("...")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    
    private func setAttributed(for txt:String) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: txt)
        attributedString.setColor(color: UIColor.darkGray.withAlphaComponent(0.6), forText: txt)
        attributedString.setColor(color: UIColor(named: "BlueColor") ?? .blue, forText: "$ 840")
        attributedString.setColor(color: UIColor(named: "BlueColor") ?? .blue, forText: "event name")
        attributedString.setColor(color: UIColor(named: "BlueColor") ?? .blue, forText: "John Deo")
        attributedString.setColor(color: UIColor(named: "BlueColor") ?? .blue, forText: "bank account 03213543467567")
        attributedString.setColor(color: UIColor(named: "BlueColor") ?? .blue, forText: "Mobile no. +1 9323848308")
        
        //  let attrs = [NSAttributedString.Key.font : UIFont(name: "seguisb", size: 16.0) ?? UIFont.boldSystemFont(ofSize: 15)]//]
        //let boldString = NSMutableAttributedString(string: " Mad Anthony Mud Run ", attributes:attrs)
        
        // attributedString.append(boldString)
        
        // let attrs1 = [NSAttributedString.Key.foregroundColor : UIColor.black]
        //  attributedString.append(NSMutableAttributedString(string: "Event.", attributes:attrs1))
        self.lbl_message.attributedText = attributedString
    }
    
    // MARK: - --- Action ----
    @IBAction func btn_Continue(_ sender:UIButton) {
        if let type = self.selectedPopupType{
            switch type {
            case .eventCreatedSuccess:
                self.dismiss(animated: false) { [weak self] in
                    self?.delegate?.isClickedButton()
                }
            case .InviteAccept:
                self.dismiss(animated: false) { [weak self] in
                    self?.acceptOrRejectDelegate?.acceptOrReject(inviteID: self?.inviteID ?? "")
                }
            case .PhoneSaved:
                self.dismiss(animated: false) {[weak self] in
                    self?.delegate?.isClickedButton()
                }
            default: return
            }
        }
    }
}

extension SuccessPopupVC : IsAcceptEventInviteDataModelDelegate {
    func didRecieveDataUpdate(data: ResendOTPModel) {
        print("MyPostedEventModelData = ",data)
        Connection.svprogressHudDismiss(view: self)
        if data.success == 1
        {
            
        }
        else
        {
            self.showAlert(withMsg: data.message ?? "", withOKbtn: true)
        }
    }
    func didFailDataUpdateWithError(error: Error){
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
