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
    let postService = PostService()
    var postContent: Post?

    func fetchPostDetail(itemId: String, completion: @escaping (Post?) -> Void) {
        postService.showDetail(itemId: itemId) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    let post = Post(
                        publisher: UserDefaults.standard.string(forKey: "userNickname"),
                        createdDate: self?.postDetail?.createAt,
                        title: "abcd",
                        image: self?.postDetail?.itemImageUrlList ?? [],
                        category: self?.postDetail?.category,
                        location: self?.postDetail?.location,
                        contents: self?.postDetail?.description,
                        likeNum: 1,
                        isMyPost: self?.postDetail?.owner ?? false
                    )
                    completion(post)
                } else {
                    print(message)
                    completion(nil)
                }
            }
        }
    }

}


