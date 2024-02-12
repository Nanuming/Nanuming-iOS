//
//  MyPageView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .foregroundColor(.gray200)
                    .frame(width: 35, height: 35)
                Text("닉네임")
                    .foregroundColor(.textBlack)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }
            .padding(EdgeInsets(top: 80, leading: 30, bottom: 20, trailing: 30))
            Rectangle()
                .frame(width: screenWidth, height: 15)
                .foregroundColor(.gray50)
            Spacer()
        }
    }
}

#Preview {
    MyPageView()
}
