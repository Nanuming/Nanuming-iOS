//
//  PostListCell.swift
//  Nanuming
//
//  Created by 가은 on 2/2/24.
//

import SwiftUI

struct PostListCell: View {
    @Binding var post: Post

    var body: some View {
        HStack(spacing: 15) {
            // 이미지
            Image(post.image[0])
                .resizable()
                .frame(width: 120, height: 120)
                .background(.gray100) // TODO: 추후에 삭제할 부분
                .cornerRadius(10)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 3) {
                    // 카테고리
                    Text("#"+post.category)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 7, bottom: 3, trailing: 7))
                        .background(.greenSelected)
                        .cornerRadius(14.5)
                    // 타이틀
                    Text(post.title)
                        .font(.system(size: 17, weight: .bold))
                    // 찜 수
                    Text(String(post.likeNum)+"명이 찜하고 있어요")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.redMain)
                }
                Spacer()
                // 위치
                HStack(spacing: 2) {
                    Image("post_cell_map")
                        .resizable()
                        .frame(width: 17, height: 17)
                    Text(post.location)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.gray300)
            }
            .padding(.vertical, 10)
            .frame(width: .infinity, height: 120)
            Spacer()
        }
        .padding(15)
    }
}

#Preview {
    PostListCell(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
}
