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
    let data: [MyEvent]?
    let success: Int?
    let message: String?
}
