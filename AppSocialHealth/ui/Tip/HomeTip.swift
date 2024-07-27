//
//  HomeTip.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 26/7/24.
//

import Foundation
import SwiftUI
import TipKit


struct CustomTip: Tip {
    var titleText: String
    var messageText: String?
    var iconName: String

    var title: Text {
        Text(titleText)
    }

    var message: Text? {
        if let messageText = messageText {
            return Text(messageText)
        }
        return nil
    }

    var icon: Image {
        Image(systemName: iconName)
    }

    // Custom view to display the tip with icon
    var body: some View {
        VStack {
            HStack {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                title
                    .font(.headline)
            }
            if let message = message {
                message
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}
