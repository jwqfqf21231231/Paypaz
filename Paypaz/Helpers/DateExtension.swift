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
    // Returns the number of years
    func yearsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the number of months
    func monthsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the number of weeks
    func weeksCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    // Returns the number of days
    func daysCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the number of hours
    func hoursCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the number of minutes
    func minutesCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the number of seconds
    func secondsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns time ago by checking if the time differences between two dates are in year or months or weeks or days or hours or minutes or seconds
    func timeAgo(from date: Date) -> String {
        if yearsCount(from: date)   > 0 { return "\(yearsCount(from: date)) years ago"   }
        if monthsCount(from: date)  > 0 { return "\(monthsCount(from: date)) months ago"  }
        if weeksCount(from: date)   > 0 { return "\(weeksCount(from: date)) weeks ago"   }
        if daysCount(from: date)    > 0 { return "\(daysCount(from: date)) days ago"    }
        if hoursCount(from: date)   > 0 { return "\(hoursCount(from: date)) hours ago"   }
        if minutesCount(from: date) > 0 { return "\(minutesCount(from: date)) minutes ago" }
        if secondsCount(from: date) > 0 { return "\(secondsCount(from: date)) seconds ago" }
        return ""
    }
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
