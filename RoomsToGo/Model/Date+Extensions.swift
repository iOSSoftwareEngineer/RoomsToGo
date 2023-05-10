//
//  Date+Extensions.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation


extension Date {
    
    // Formats a date as a string using the "M/dd/yyyy" format.
    func customFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        return formatter.string(from: self)
    }
}
