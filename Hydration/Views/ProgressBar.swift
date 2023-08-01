//
//  ProgressBar.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float
    var goal: Int
    var intakeAmmount: Int

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(String(format: "%.0f%%", min(progress, 1.0) * 100.0))
                        .font(.largeTitle)
                        .bold()
                    
                    Image(systemName: "drop.fill")
                        .foregroundColor(Theme.primary)
                        .font(.title)
                }
                Text("of your daily goal")
                    .font(.caption2)

                Text("\(intakeAmmount) mL / \(goal) mL")
                    .font(.caption)
                    .padding(.vertical, 3)
            }
            
            Circle()
                .stroke(lineWidth: 13)
                .opacity(0.3)
                .foregroundColor(Theme.primary)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(Theme.primary)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeOut(duration: 0.25), value: progress)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.9, goal: 3000, intakeAmmount: 2500)
    }
}
