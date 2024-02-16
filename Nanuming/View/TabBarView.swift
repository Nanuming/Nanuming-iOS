//
//  TabBarView.swift
//  Nanuming
//
//  Created by 가은 on 1/27/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        VStack {
            // 탭 뷰
            TabView {
                // 홈 탭 (지도&게시물 리스트)
                HomeView(post: Post(publisher: "가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false))
                    .tabItem({
                        Label("홈", systemImage: "house")
                    })
                // my 탭
//                MyPageView()
//                ConnectBoxView(itemId: "1")
                PhotoAuthView()
                    .tabItem({
                        Label("My", systemImage: "person.circle")
                    })
            }
        }
    }
}

#Preview {
    TabBarView()
}
