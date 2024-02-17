//
//  MyPostView.swift
//  Nanuming
//
//  Created by 가은 on 2/17/24.
//

import SwiftUI

enum myPostTapInfo: String, CaseIterable {
    case beforeCreate = "등록 대기"
    case waiting = "나눔 중"
    case reserving = "예약 중"
    case complete = "나눔 완료"
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
        
//        switch selectedTab {
//            case 0:
//            showPostList(status: "")
//                
//            case 1:
//                Text("2 번째 탭의 내용")
//            case 2:
//                Text("3 번째 탭의 내용")
//            default:
//                Text("4 번째 탭의 내용")
//        }
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
