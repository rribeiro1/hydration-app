//
//  DateManager.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 13.07.23.
//

import SwiftUI

class DateHelper {

    static func formatFullDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    static func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
