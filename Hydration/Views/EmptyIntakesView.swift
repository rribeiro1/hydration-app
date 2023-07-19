//
//  EmptyIntakesView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 19.07.23.
//

import SwiftUI

struct EmptyIntakesView: View {
    var body: some View {
        VStack {
            Image("drink")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            Text("No water consumption today yet!")
            Text("Drink water and add it here")
            Image(systemName: "arrow.down")
                .padding()
        }
    }
}

struct EmptyIntakesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyIntakesView()
    }
}
