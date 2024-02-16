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
                HomeView(mapVM: MapViewModel())
                    .tabItem({
                        Label("홈", systemImage: "house")
                    })
                // my 탭
                MyPageView()
//                ConnectBoxView()
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
