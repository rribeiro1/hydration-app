//
//  View+Shimmer.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 05.08.23.
//

import SwiftUI
import Shimmer

extension View {
    @ViewBuilder
    func loading(_ isLoading: Bool) -> some View {
        if isLoading {
            self
                .redacted(reason: .placeholder)
                .shimmering()
        } else {
            self
        }
    }
}
