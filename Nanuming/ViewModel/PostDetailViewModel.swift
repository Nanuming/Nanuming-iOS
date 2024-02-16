//
//  PostDetailViewModel.swift
//  Nanuming
//
//  Created by byeoungjik on 2/15/24.
//

import Foundation
import SwiftUI

class PostDetailViewModel: ObservableObject {
    @Published var postDetail: PostDetail?
    @Published var postContent: Post? 

    let postService = PostService()
    
    func fetchPostDetail(itemId: String) {
        postService.showDetail(itemId: itemId) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    guard let detail = self?.postDetail else { return }
                    
                    let post = Post(
                        publisher: detail.nickname,  // UserDefaults에서 가져오는 대신 PostDetail의 nickname 사용
                        createdDate: detail.createAt,
                        title: "루피 인형 나눔합니다",  // 예시로 고정된 값 사용
                        image: detail.itemImageUrlList,
                        category: detail.category,
                        location: detail.location,
                        contents: detail.description,
                        likeNum: 0,  // 예시로 고정된 값 사용
                        isMyPost: detail.owner
                    )
                    self?.postContent = post // 할당
                } else {
                    print(message)
                    self?.postContent = nil
                }
            }
        }
    }
}



