//
//  MoreOptionsPopupVC.swift
//  Paypaz
//
//  Created by iOSDeveloper on 12/05/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit

protocol MoreOptionsDelegate : class {
    func hasSelectedOption(type:OptionType,eventID:String,isPublic:String,isInvitedMember:String)
}

enum OptionType {
    case edit_Event
    case edit_EventProducts
    case edit_InvitedMembers
    case delete_Event
    case share
}
class MoreOptionsPopupVC : CustomViewController {
    weak var delegate : MoreOptionsDelegate?
    var eventID = ""
    var isPublic = ""
    var isInvitedMember = ""
    //MARK:- ---- View Life Cycle ----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    // MARK: - ---- Action ----
    @IBAction func btn_Cancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Edit(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.hasSelectedOption(type: .edit_Event,eventID: self?.eventID ?? "",isPublic: self?.isPublic ?? "",isInvitedMember: self?.isInvitedMember ?? "")
        }
    }
    @IBAction func btn_EditEventProducts(_sender:UIButton){
        self.dismiss(animated: false) {[weak self] in
            self?.delegate?.hasSelectedOption(type: .edit_EventProducts,eventID: self?.eventID ?? "",isPublic: self?.isPublic ?? "",isInvitedMember: self?.isInvitedMember ?? "")
        }
    }
    @IBAction func btn_EditInvitedMembers(_sender:UIButton){
        self.dismiss(animated: false) {[weak self] in
            self?.delegate?.hasSelectedOption(type: .edit_InvitedMembers,eventID: self?.eventID ?? "",isPublic: self?.isPublic ?? "",isInvitedMember: self?.isInvitedMember ?? "")
        }
    }
    @IBAction func btn_Delete(_ sender:UIButton) {
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.hasSelectedOption(type: .delete_Event,eventID: self?.eventID ?? "",isPublic: self?.isPublic ?? "",isInvitedMember: self?.isInvitedMember ?? "")
        }
    }
    @IBAction func btn_Share(_ sender:UIButton){
        self.dismiss(animated: false) { [weak self] in
            self?.delegate?.hasSelectedOption(type: .share, eventID: self?.eventID ?? "",isPublic: self?.isPublic ?? "",isInvitedMember: self?.isInvitedMember ?? "")
        }
    }
    
}

