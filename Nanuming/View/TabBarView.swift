//
//  TabBarView.swift
//  Nanuming
//
//  Created by 가은 on 1/27/24.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var userData : UserData
    var body: some View {
        VStack {
            // 탭 뷰
            TabView {
                // 홈 탭 (지도&게시물 리스트)
                HomeView()
                    .tabItem({
                        Label("홈", systemImage: "house")
                    })
                // my 탭
                MyPageView()
                    .tabItem({
                        Label("My", systemImage: "person.circle")
                    })
            }
        }
    }
}

#Preview {
    TabBarView(userData: .constant(UserData(url: nil, name: "이름", email: "이메일")))
}
