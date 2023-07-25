//
//  InfoView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                Image(systemName: "drop")
                    .symbolVariant(.fill)
                    .foregroundColor(Theme.text)
                    .font(.system(size: 80))
                
                Image(systemName: "ruler")
                    .foregroundColor(Theme.text)
                    .font(.system(size: 60))
            }
            .padding()
            
            Text("Every day, we lose water through  our breath, perspiration, urine and bowel moviments. For our bodies to function properly, we must replenish its water supply by consuming beverages and foods that contain water. Adequate daily fluid intake is approximately:")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            VStack {
                Text("Men - 15.5 cups (3.7 L) of fluids daily")
                    .bold()
                Text("Women - 11.5 cups (2.7 L) of fluids daily")
                    .bold()
            }
            .padding()
            
            HStack(alignment: .center, spacing: 50) {
                Image(systemName: "figure.walk")
                    .foregroundColor(.orange)
                    .font(.system(size: 50))
                
                Image(systemName: "cloud.sun")
                    .symbolVariant(.fill)
                    .foregroundColor(.green)
                    .font(.system(size: 40))
                
                Image(systemName: "cross.circle")
                    .symbolVariant(.fill)
                    .foregroundColor(.red)
                    .font(.system(size: 40))
            }
            .padding()
            
            Text("Your total fluid intake may need to modified on level of exercise, the environment (i.e hot/humid weather increases sweat) and overall health.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
            
            Text("Source: Mayo")
                .font(.caption)
                .bold()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
        .background(Theme.systemBackground)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InfoView()
        }
    }
}
