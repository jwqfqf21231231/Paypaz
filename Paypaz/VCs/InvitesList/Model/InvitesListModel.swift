//
//  InvitesListModel.swift
//  Paypaz
//
//  Created by MAC on 06/09/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - InvitesListModel
struct InvitesListModel: Codable {
    let data: [InvitesList]?
    let success,isAuthorized,isSuspended: Int?
    let message: String?
}

// MARK: - InvitesList
struct InvitesList: Codable {
    let id, eventID, senderID, receiverID: String?
    let message, isAccept, status, createdDate: String?
    let type,title: String?
    let updatedDate: String?
    let userProfile: String?
}
