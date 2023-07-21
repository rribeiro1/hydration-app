//
//  DateManager.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 13.07.23.
//

import SwiftUI

final class DateFormatterManager {
    static let shared = DateFormatterManager()

    private let dateFormatter = DateFormatter()

    init() {}

    func fullDate(date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    func time(date: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
