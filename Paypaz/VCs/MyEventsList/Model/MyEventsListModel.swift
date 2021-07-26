//
//  MyEventsListModel.swift
//  Paypaz
//
//  Created by MACOSX on 08/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - MyEventsListModel
struct MyEventsListModel: Codable {
    let data: [Event]?
    let success: Int?
    let message: String?
}

// MARK: - Datum
struct Event: Codable {
    let id, userID, typeID, name: String?
    let location, latitude, longitude, price: String?
    let image, startDate, endDate, startTime: String?
    let endTime, ispublic, isinviteMember, paymentType: String?
    let memberID, status, createdDate, updatedDate: String?
    let firstName, lastName, userLatitude, userLongitude: String?
}
