//
//  PostDetailView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct PostDetailView: View {
    @Binding var post: Post

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                // 이미지
                TabView {
                    // TODO: url을 사용하기 위해서는 변경 작업 필요
                    ForEach(post.image, id: \.self) { url in
                        Image(url)
                            .resizable()
                            .background(.gray100)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .frame(width: screenWidth, height: screenWidth)
            }
        }
    }
}

#Preview {
    PostDetailView(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "google_logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
}
