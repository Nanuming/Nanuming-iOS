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
    var postImage = PostImagePicker(post: .constant(Post()))
    
    var body: some View {
        NavigationView {
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
                
                // 사진
                VStack(alignment: .leading) {
                    Text("사진")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textBlack)
                    postImage
                }
                
                // 장소
                VStack(alignment: .leading) {
                    Text("장소")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textBlack)
                    Button {
                        // 장소 검색 화면으로 이동
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            TextField("장소 검색하기", text: $title)
                                .font(.system(size: 16, weight: .medium))
                                .multilineTextAlignment(.leading)
                                .disabled(true)
                                .frame(height: 30)
                            Rectangle()
                                .frame(height: 0.75)
                        }
                        .foregroundColor(.gray100)
                    }
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
            .frame(width: screenWidth*0.85)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        // 창 닫기
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
}

#Preview {
    CreatePostView()
}
