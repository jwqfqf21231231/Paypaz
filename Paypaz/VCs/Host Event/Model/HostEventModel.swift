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
    let dataDescription, location, latitude, longitude: String?
    let price, quantity, image, startDate: String?
    let endDate, startTime, endTime, ispublic: String?
    let isinviteMember, paymentType, memberID, status: String?
    let createdDate, updatedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, userID, typeID, name
        case dataDescription = "description"
        case location, latitude, longitude, price, quantity, image, startDate, endDate, startTime, endTime, ispublic, isinviteMember, paymentType, memberID, status, createdDate, updatedDate
    }
}
