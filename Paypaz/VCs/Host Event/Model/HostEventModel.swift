//
//  HostEventModel.swift
//  Paypaz
//
//  Created by MACOSX on 02/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - HostEventModel
struct HostEventModel: Codable {
    let data: DataClass6?
    let success: Int?
    let message: String?
}

// MARK: - DataClass
struct DataClass6: Codable {
    let id, userID, typeID, name: String?
    let location, latitude, longitude, price: String?
    let image, startDate, endDate, startTime: String?
    let endTime, ispublic, isinviteMember, paymentType: String?
    let memberID, status, createdDate, updatedDate: String?
}