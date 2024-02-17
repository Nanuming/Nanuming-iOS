//
//  MyPostView.swift
//  Nanuming
//
//  Created by 가은 on 2/17/24.
//

import SwiftUI

enum myPostTapInfo: String, CaseIterable {
    case temporary = "등록 대기"
    case available = "나눔 중"
    case reserved = "예약 중"
    case shared = "나눔 완료"
}

struct MyPostView: View {
    @State private var selectedTab: Int = 0
    @State private var postList: [PostCellByLocation] = []
    let postStatus = ["temporary", "available", "reserved", "shared"]

    var body: some View {
        Picker("my", selection: $selectedTab) {
            ForEach(myPostTapInfo.allCases.indices, id: \.self) { index in
                Text(myPostTapInfo.allCases[index].rawValue).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .onReceive([self.selectedTab].publisher.first()) { idx in
            getMyPostAPI(status: postStatus[idx])
        }
        
        showPostList()
        
        Spacer()
    }
    
    func getMyPostAPI(status: String) {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        PostService().getMyPost(memberId: userId, status: status) { postListByLocation in
            self.postList = postListByLocation.memberItemOutlineDtoList
        }
    }
    
    @ViewBuilder
    func showPostList() -> some View {
        List {
            ForEach(postList, id: \.itemId) { post in
                let post = Post(title: post.title, image: [post.mainItemImageUrl], category: post.categoryName, location: post.locationName)
                PostListCell(post: .constant(post))
            }
        }
    }
}

#Preview {
    MyPostView()
}
