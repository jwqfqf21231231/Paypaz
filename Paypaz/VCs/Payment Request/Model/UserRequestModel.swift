//
//  PaymentRequestModel.swift
//  Paypaz
//
//  Created by MAC on 19/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - UserRequestModel
struct UserRequestModel: Codable {
    let data: [UserRequests]?
    let success: Int?
    let message: String?
}

struct UserRequests: Codable {
    let id, senderID, receiverID, name: String?
    let phoneNumber, phoneCode, amount, datumDescription: String?
    let status, createdDate, updatedDate, firstName: String?
    let lastName, userProfile: String?

    enum CodingKeys: String, CodingKey {
        case id, senderID, receiverID, name, phoneNumber, phoneCode, amount
        case datumDescription = "description"
        case status, createdDate, updatedDate, firstName, lastName, userProfile
    }
}
