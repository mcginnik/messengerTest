//
//  Date+Extensions.swift
//  MessengerTest
//
//  Created by Kyle McGinnis on 2/20/23.
//

import Foundation

extension Date {
    
    func descriptiveString(style: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = style
        
        let daysBetween = self.daysBetween(Date())
        switch daysBetween {
        case 0:
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: self, relativeTo: Date())
        case 1:
            return "Yesterday"
        case _ where daysBetween < 5:
            let weekDayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekDayIndex]
        default:
            return formatter.string(from: self)
        }
    }
    
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day{
            return daysBetween
        }
        return 0
    }
    
}
