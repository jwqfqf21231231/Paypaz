//
//  ChooseEventModel.swift
//  Paypaz
//
//  Created by MACOSX on 06/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - ChooseEventModel
struct ChooseEventModel: Codable {
    let data: [Events]?
    let success: Int?
    let isAuthorized:Int?
    let isSuspended:Int?
    let message: String?
}

// MARK: - Datum
struct Events: Codable {
    let id, name, icon, status: String?
    let createdDate: String?
}


