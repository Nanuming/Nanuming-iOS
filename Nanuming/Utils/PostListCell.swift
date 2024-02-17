//
//  PostListCell.swift
//  Nanuming
//
//  Created by 가은 on 2/2/24.
//

import SwiftUI
import URLImage

struct PostListCell: View {
    @Binding var post: Post

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                // 이미지
                if let imageURL = URL(string: post.image[0] ?? "") {
                    URLImage(imageURL) { image in
                        image
                            .resizable()
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                    }
                } else {
                    // imageURL이 nil인 경우에 대한 처리
                    Image("")
                        .resizable()
                        .background(.gray)
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 3) {
                        // 카테고리
                        Text("#"+(post.category ?? ""))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 3, leading: 7, bottom: 3, trailing: 7))
                            .background(.greenSelected)
                            .cornerRadius(14.5)
                        // 타이틀
                        Text(post.title ?? "")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.textBlack)
                        // 찜 수
//                        Text(String(post.likeNum ?? 0)+"명이 찜하고 있어요")
//                            .font(.system(size: 12, weight: .medium))
//                            .foregroundColor(.redMain)
                    }
                    Spacer()
                    // 위치
                    HStack(spacing: 2) {
                        Image("post_cell_map")
                            .resizable()
                            .frame(width: 17, height: 17)
                        Text(post.location ?? "")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(.gray300)
                }
                .padding(.vertical, 10)
                .frame(height: 120)
                Spacer()
            }
            .padding(15)
            Rectangle()
                .frame(width: screenWidth, height: 5)
                .foregroundColor(.gray50)
        }
    }
}

#Preview {
    PostListCell(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
}
