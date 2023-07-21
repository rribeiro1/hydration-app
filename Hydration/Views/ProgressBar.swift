//
//  ProgressBar.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                        .font(.largeTitle)
                        .bold()
                    
                    Image(systemName: "drop.fill")
                        .foregroundColor(Theme.primary)
                        .font(.title)
                }
                Text("of your daily goal")
                    .font(.caption2)
            }
            
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Theme.primary)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Theme.primary)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear(duration: 1.0), value: progress)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.9)
    }
}
