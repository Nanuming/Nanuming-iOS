//
//  CreatePostView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct CreatePostView: View {
    @State var title: String = ""
    @State var contents: String = ""
    @Environment(\.presentationMode) var presentation
    @State var postImageDatas: [Data?] = []
    @State private var showPostDetailModal = false
    @State private var itemId: Int = 0
    let category: [String] = ["장난감", "도서", "의류", "육아용품", "기타"]
    @State var categoryId: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 30) {
                        // 제목
                        VStack(alignment: .leading) {
                            Text("제목")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textBlack)
                            ZStack(alignment: .bottom) {
                                TextField("제목", text: $title)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.textBlack)
                                    .frame(height: 30)
                                Rectangle()
                                    .frame(height: 0.75)
                            }
                            .foregroundColor(.gray100)
                        }
                        
                        // 카테고리
                        VStack(alignment: .leading) {
                            Text("카테고리")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textBlack)
                            categoryFilter()
                        }
                        
                        // 사진
                        VStack(alignment: .leading) {
                            Text("사진")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textBlack)
                            PostImagePicker(post: .constant(Post()), postImageDatas: $postImageDatas)
                        }
                        
                        // 설명
                        VStack(alignment: .leading) {
                            Text("설명")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textBlack)
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(.gray100)
                                .frame(height: 150)
                                .overlay(alignment: .top, content: {
                                    TextField("물품에 대한 자세한 설명을 적어주세요!", text: $contents, axis: .vertical)
                                        .font(.system(size: 16, weight: .medium))
                                        .padding()
                                })
                        }
                    }
                    .padding(.bottom, 70)
                }
                Button {
                    // 게시물 예비 등록
                    PostService().writePost(title: title, categoryId: categoryId+1, description: contents, imageList: postImageDatas) { id in
                        print("write post sucess/ postId: ", id)
                        self.itemId = id
                        
                        // 창 닫기
//                        presentation.wrappedValue.isPresented
                        showPostDetailModal = true
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenWidth * 0.9, height: 50)
                        .overlay(
                            Text("예비 등록하기")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                .fullScreenCover(isPresented: $showPostDetailModal) {
                    PostDetailView(itemId: itemId)
                }
            }
            .frame(width: screenWidth*0.85)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        // 창 닫기
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundColor(.textBlack)
                    .frame(width: 30, height: 30)
                }
                ToolbarItemGroup(placement: .principal) {
                   Text("게시물 등록")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
    
    @ViewBuilder
    func categoryFilter() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0 ..< category.count) { idx in
                    Button {
                        categoryId = idx
                    } label: {
                        Text(category[idx])
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(categoryId == idx ? .white : .gray200)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(categoryId == idx ? .greenMain : .white)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(categoryId == idx ? .clear : .gray200, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(EdgeInsets(top: 5, leading: 1, bottom: 5, trailing: 1))
        }
    }
}

#Preview {
    CreatePostView()
}
