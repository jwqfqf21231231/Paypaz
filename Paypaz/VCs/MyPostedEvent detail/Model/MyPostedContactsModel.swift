//
//  MyPostedContactsModel.swift
//  Paypaz
//
//  Created by MAC on 23/08/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - MyPostedContactsModel
struct MyPostedContactsModel: Codable {
    let data: [InvitedContacts]?
    let success,isAuthorized,isSuspended: Int?
    let message: String?
}

// MARK: - Datum
struct InvitedContacts: Codable {
    let id, userID, eventID, contactID: String?
    let name, phoneNumber, phoneCode, parentID: String?
    let status, createdDate, updatedDate, userProfile: String?
}
