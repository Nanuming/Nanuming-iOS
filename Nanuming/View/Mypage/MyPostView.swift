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
    @Environment(\.presentationMode) var presentation
    @State private var isPresentedLocationPostList = false
    @State var isOwner = true
    var body: some View {
        NavigationView {
            VStack {
                Picker("my", selection: $selectedTab) {
                    ForEach(myPostTapInfo.allCases.indices, id: \.self) { index in
                        Text(myPostTapInfo.allCases[index].rawValue).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {
                    VStack {
                        ForEach(postList, id: \.itemId) { postcell in

                            let post = Post(title: postcell.title, image: [postcell.mainItemImageUrl], category: postcell.categoryName, location: postcell.locationName)

                            // modal로 띄우기
                            Button {
                                isPresentedLocationPostList = true
                            } label: {
                                PostListCell(post: .constant(post))
                            }
                            .fullScreenCover(isPresented: $isPresentedLocationPostList) {
                                PostDetailView(isOwner: $isOwner, itemId: postcell.itemId)
                            }
                        }
                    }
                }
            }
            .onChange(of: selectedTab, initial: true) { _, idx in
                getMyPostAPI(status: postStatus[idx])
            }
            .navigationBarTitle("나의 나눔", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.textBlack)
                        .frame(width: 30, height: 30)
                }
            )
        }
    }

    func getMyPostAPI(status: String) {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        PostService().getMyPost(memberId: userId, status: status) { postListByLocation in
            self.postList = postListByLocation.memberItemOutlineDtoList
        }
    }
}

#Preview {
    MyPostView()
}
