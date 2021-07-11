//
//  MyPostedEventModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - MyPostedEventModel
struct MyPostedEventModel: Codable {
    let data: MyEvent?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct MyEvent: Codable {
    let id, userID, typeID, name: String?
    let location, latitude, longitude, price: String?
    let image, startDate, endDate, startTime: String?
    let endTime, ispublic, isinviteMember, paymentType: String?
    let memberID, status, createdDate, updatedDate: String?
}
