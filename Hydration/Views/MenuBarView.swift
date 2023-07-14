//
//  MenuView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct MenuBarView: View {
    @State var showInfo: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            Image(systemName: "info.bubble")
                .foregroundColor(Theme.text)
                .scaleEffect(1.5)
                .onTapGesture {
                    showInfo.toggle()
                }

            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.blue)

                    HStack {
                        Text("Add Intake")
                            .foregroundColor(.white)
                        
                        Image(systemName: "plus.app")
                            .foregroundColor(.white)
                    }
                }
            }

            Image(systemName: "gearshape")
                .foregroundColor(Theme.text)
                .scaleEffect(1.5)
        }
        .padding(.horizontal, 40)
        .frame(height: 60)
        .sheet(isPresented: $showInfo) {
            InfoView()
        }
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
