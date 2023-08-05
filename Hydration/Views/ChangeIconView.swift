//
//  ChangeIconView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 05.08.23.
//

import SwiftUI

enum IconType: String, CaseIterable {
    case original = "Original"
    case coffee = "Coffee"
    case juice = "Juice"
}

struct ChangeIconView: View {
    @AppStorage(UserDefaultKeys.activeIcon)
    var activeAppIcon: String = IconType.original.rawValue

    var body: some View {
        VStack {
            List {
                ForEach(IconType.allCases, id: \.self) { iconType in
                    HStack {
                        if let uiImage = UIImage(named: iconType.rawValue) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(15)
                        }
                        HStack {
                            Text(iconType.rawValue)
                                .tag(iconType)
                                .padding(.horizontal, 10)
                            Spacer()
                            if iconType.rawValue == activeAppIcon {
                                Image(systemName: "checkmark")
                                    .symbolVariant(.circle)
                                    .symbolVariant(.fill)
                                    .font(.system(size: 20))
                                    .foregroundColor(Theme.primary)
                            }
                        }
                    }
                    .onTapGesture {
                        activeAppIcon = iconType.rawValue
                        UIApplication.shared.setAlternateIconName(iconType.rawValue)
                    }
                }
            }
            .navigationTitle("App Icon")
        }
    }
}

struct ChangeIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChangeIconView()
        }
    }
}
