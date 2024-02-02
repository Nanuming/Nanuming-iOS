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
            VStack(spacing: 0) {
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
                
                // 게시자 정보
                HStack(spacing: 5) {
                    Text(post.publisher)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textBlack)
                    Text("님")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Text(post.createdDate)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.gray200)
                .frame(height: 50)
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                .background(.gray50)
            }
        }
    }
}

#Preview {
    PostDetailView(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "google_logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
}
