//
//  UserTicketsModel.swift
//  Paypaz
//
//  Created by MAC on 04/10/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - UserTicketsModel
struct UserTicketsModel: Codable {
    let data: [Tickets]?
    let success,isAuthorized: Int?
    let message: String?
}

// MARK: - Datum
struct Tickets: Codable {
    let orderNumber, id, name, datumDescription: String?
    let endDate, image: String?

    enum CodingKeys: String, CodingKey {
        case orderNumber, id, name
        case datumDescription = "description"
        case endDate, image
    }
}
