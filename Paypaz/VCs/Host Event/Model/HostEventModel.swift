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
    let data: MyEvent?
    let success: Int?
    let isAuthorized:Int?
    let isSuspended:Int?
    let message: String?
}
