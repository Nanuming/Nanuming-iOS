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
                Text(UserDefaults.standard.string(forKey: "userNickname") ?? "")
                    .foregroundColor(.textBlack)
                    .font(.system(size: 22, weight: .semibold))
                Spacer()
            }
            .padding(EdgeInsets(top: 80, leading: 30, bottom: 20, trailing: 30))
            Rectangle()
                .frame(width: screenWidth, height: 15)
                .foregroundColor(.gray50)
            
            VStack(alignment: .leading, spacing: 20) {
                buttonBuilder(imageName: "heart", text: "나의 나눔")
                Divider()
                buttonBuilder(imageName: "info.circle", text: "버전 정보")
                Divider()
                buttonBuilder(imageName: "book.pages", text: "이용약관")
                Divider()
                buttonBuilder(imageName: "globe", text: "언어 설정")
            }
            .padding(EdgeInsets(top: 50, leading: 30, bottom: 0, trailing: 30))
            Spacer()
        }
        
    }
    
    @ViewBuilder
    func buttonBuilder(imageName: String, text: String) -> some View {
        Button {
            
        } label: {
            HStack(spacing: 15) {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(text)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.textBlack)
        }
    }
}

#Preview {
    MyPageView()
}
