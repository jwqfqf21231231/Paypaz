//
//  Date+Extension.swift
//  FITPIN
//
//  Created by paras on 26/02/21.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var commentDateConverter : String {
        
        //2021-02-26 00:19:04
        let serverDateStr = self.UTCToLocal(incomingFormat: "yyyy-MM-dd HH:mm:ss", outGoingFormat: "yyyy-MM-dd hh:mm:ss")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if let serverDate   = dateFormatter.date(from: serverDateStr) {
            let currentStr = dateFormatter.string(from: Date())
            return serverDate.formatRelativeString(date: dateFormatter.date(from: currentStr)!.toLocalTime())
        }
        else {
            return ""
        }
    }
    
    func UTC_To_localDate(utcDateFormat:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = utcDateFormat
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        if let dt = dateFormater.date(from: self) {
            dateFormater.timeZone = TimeZone.current
            return dateFormater.string(from: dt)
        }
        else {
            return ""
        }
    }
    
    func convertUTCToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func formatRelativeString(date:Date) -> String {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let calendar = NSCalendar.current
        // if calendar.isDateInToday(self) {
        let timediff = calendar.dateComponents([.hour,.minute,.second], from: self, to: date)
        if timediff.hour ?? 0 != 0 {
            return "\(timediff.hour ?? 0) hour ago"
        }
        else if timediff.minute ?? 0 != 0 {
            return "\(timediff.minute ?? 0) min ago"
        }
        if timediff.second ?? 0 != 0 {
            return "\(timediff.second ?? 0) sec ago"
        }
        //  }
        return dateFormatter.string(from: self) + " at \(timeFormater.string(from: self))"
    }
    
    func today(format : String = "YYYY-MM-dd'T'HH:mm:ss.SSS") -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    
    
}
