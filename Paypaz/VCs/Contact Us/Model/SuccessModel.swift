//
//  SuccessModel.swift
//  Paypaz
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation

// MARK: - SuccessModel
struct SuccessModel: Codable {
    let success,isAuthorized: Int?
    let message: String?
}
