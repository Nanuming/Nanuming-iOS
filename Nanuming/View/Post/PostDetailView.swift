//
//  PostDetailView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct PostDetailView: View {
    @Binding var post: Post
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // 이미지
                        TabView {
                            // TODO: url을 사용하기 위해서는 변경 작업 필요
                            ForEach(post.image, id: \.self) { url in
                                Image(url ?? "")
                                    .resizable()
                                    .background(.gray100)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                        .frame(width: screenWidth, height: screenWidth*0.85)

                        // 게시 정보
                        HStack(spacing: 5) {
                            // 게시자
                            Text(post.publisher ?? "")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.textBlack)
                            Text("님")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                            // 생성일자
                            Text(post.createdDate ?? "")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.gray200)
                        .frame(height: 50)
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .background(.gray50)

                        // 게시물 상세
                        VStack(alignment: .leading, spacing: 15) {
                            // 타이틀
                            Text(post.title ?? "")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.textBlack)
                            HStack(spacing: 10) {
                                // 카테고리
                                Text("#" + (post.category ?? ""))
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .background(.greenSelected)
                                    .cornerRadius(14)
                                // 장소
                                Button {
                                    // TODO: 지도 연결
                                } label: {
                                    HStack(spacing: 3) {
                                        Image("post_cell_map")
                                            .frame(width: 17, height: 17)
                                        Text(post.location ?? "")
                                            .foregroundColor(.gray300)
                                    }
                                }
                            }
                            Divider()
                            // 내용
                            Text(post.contents ?? "")
                                .foregroundColor(.textBlack)
                                .lineSpacing(5)
                        }
                        .padding(EdgeInsets(top: 25, leading: 15, bottom: 70, trailing: 15))
                        .frame(width: screenWidth)
                        .font(.system(size: 15, weight: .medium))
                    }
                }
                Button {
                    // 게시물 생성 페이지로 이동
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenWidth * 0.9, height: 50)
                        .overlay(
                            Text("나눔받기")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        // 뒤로가기
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward.circle.fill")
                    }
                    .foregroundColor(.gray300)
                    .frame(width: 30, height: 30)
                    
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        // 찜
                    } label: {
                        Image(systemName: "heart")
                    }
                    .foregroundColor(.gray300)
                    .frame(width: 30, height: 30)
                }
            }
        }
    }
}

#Preview {
    PostDetailView(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "google_logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔나눔나눔\n상태 good이에요", isMyPost: false)))
}
