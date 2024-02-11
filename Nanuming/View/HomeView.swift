//
//  HomeView.swift
//  Nanuming
//
//  Created by 가은 on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    @State var post: Post
    @State private var isPresentedPostDetail = false
    @State private var isPresentedCreatePost = false
    
    let category: [String] = ["전체", "장난감", "도서", "의류", "육아용품", "기타"]
    @State var selectedCategoryId: Int = 0
    
    var body: some View {
        VStack(spacing: 10) {
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
            .frame(height: 45)
            
            // 카테고리 필터
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<category.count) { idx in
                        Button {
                            selectedCategoryId = idx
                        } label: {
                            Text(category[idx])
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(selectedCategoryId == idx ? .white : .greenMain)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background(selectedCategoryId == idx ? .greenMain : .white)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(.greenMain, lineWidth: 1)
                                )
                                
                        }
                    }
                }
                .padding(5)
            }
            
            Rectangle()
                .frame(width: screenWidth, height: 13)
                .foregroundColor(.gray50)
            
            ZStack(alignment: .bottomTrailing) {
                // post list
                ScrollView {
                    VStack {
                        // modal로 띄우기
                        Button {
                            isPresentedPostDetail = true
                        } label: {
                            PostListCell(post: $post)
                        }
                        .fullScreenCover(isPresented: $isPresentedPostDetail) {
                            PostDetailView(post: $post)
                        }
                        
                        PostListCell(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
                        PostListCell(post: .constant(Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false)))
                    }
                }
                
                // 게시물 생성 + 버튼
                Button {
                    isPresentedCreatePost = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        )
                }
                .frame(width: 60, height: 60)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
                .fullScreenCover(isPresented: $isPresentedCreatePost) {
                    CreatePostView()
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    HomeView(post: Post(publisher: "유가은", createdDate: "2024.01.31", title: "루피 인형 나눔", image: ["Logo", "Logo"], category: "장난감", location: "자양4동 어린이집", contents: "나눔나눔", isMyPost: false))
}
