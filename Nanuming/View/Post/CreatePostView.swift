//
//  CreatePostView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct CreatePostView: View {
    @State var title: String = ""
    
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
                VStack {
                    Text("사진")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textBlack)
                    
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
                            Text("장소 검색하기")
                                .font(.system(size: 16, weight: .medium))
                                .frame(height: 30)
                            Rectangle()
                                .frame(height: 0.75)
                        }
                        .foregroundColor(.gray100)
                    }
                }
                
                // 설명
            }
            .frame(width: screenWidth*0.85)
        }
    }
}

#Preview {
    CreatePostView()
}
