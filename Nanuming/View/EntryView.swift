//
//  EntryView.swift
//  Nanuming
//
//  Created by 가은 on 1/28/24.
//

import SwiftUI

var screenWidth = UIScreen.main.bounds.size.width
var screenHeight = UIScreen.main.bounds.size.height

struct EntryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .resizable()
                    .frame(width: screenWidth*0.8,height: screenWidth*0.75)
                Button(action: {}) {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: screenWidth*0.85, height: 50)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                        .overlay(
                            HStack {
                                Image("google_logo")
                                    .frame(width: 30, height: 30)
                                Text("Sign in with Google")
                                    .foregroundStyle(Color.textBlack)
                                    .font(.system(size: 17, weight: .semibold))
                            }
                        )
                }
            }
        }
    }
}

#Preview {
    EntryView()
}
