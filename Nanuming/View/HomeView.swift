//
//  HomeView.swift
//  Nanuming
//
//  Created by 가은 on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                // 리스트 이동 버튼
                VStack {
                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 22, height: 15)
                    Text("목록")
                        .font(.system(size: 9, weight: .medium))
                }
                .foregroundColor(.greenMain)
                // 검색
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 20, height: 20)
                    TextField("검색", text: $searchText)
                        .foregroundColor(.textBlack)
                }
                .foregroundColor(.gray200)
                .padding(.leading, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray100, lineWidth: 0.5)
                        .frame(height: 45)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HomeView()
}
