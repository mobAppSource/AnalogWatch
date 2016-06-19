//
//  Utility.swift
//  ArcWatch
//
//  Created by LandCruiser on 2/18/16.
//  Copyright © 2016 LandCruiser. All rights reserved.
//
import Foundation
import UIKit


extension String {
    struct Date {
        static let formatter = NSDateFormatter()
    }
    func toDateFormattedWith(format:String)-> NSDate? {
        Date.formatter.dateFormat = format
        return Date.formatter.dateFromString(self)
    }
}
extension NSDate {
    struct Date {
        static let formatterCustom: NSDateFormatter = {
            let formatter = NSDateFormatter()
            return formatter
        }()
        static let formatterDate:NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        static let formatterTime:NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        static let formatterWeekday:NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter
        }()
        static let formatterMonth:NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "LLLL"
            return formatter
        }()
    }
    var date: String {
        return Date.formatterDate.stringFromDate(self)
    }
    var time: String {
        return Date.formatterTime.stringFromDate(self)
    }
    var weekdayName: String {
        return Date.formatterWeekday.stringFromDate(self)
    }
    var monthName: String {
        return Date.formatterMonth.stringFromDate(self)
    }
    func formatted(format:String) -> String {
        Date.formatterCustom.dateFormat = format
        return Date.formatterCustom.stringFromDate(self)
    }
}

func NSDate2IntArray(time: NSDate) -> [String]{
    let timeStr = time.time
    let timeArray = timeStr.componentsSeparatedByString(":")
    return timeArray
}