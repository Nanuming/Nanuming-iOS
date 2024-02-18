//
//  PostListView.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI

struct PostListView: View {
    @State var placeName: String
    @State var postList: [PostCellByLocation]
    @State private var isPresentedLocationPostList = false
    @Environment(\.presentationMode) var presentation
    var body: some View {
        NavigationView {
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
                            PostDetailView(itemId: postcell.itemId)
                        }
                    }
                }
            }
            .navigationBarTitle("\(placeName)에 있는 물품", displayMode: .inline)
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
}

#Preview {
    PostListView(placeName: "ㅌㅌ", postList: [PostCellByLocation(itemId: 1, mainItemImageUrl: "", title: "gh", locationName: "광진 어린이집", categoryName: "cate"), PostCellByLocation(itemId: 1, mainItemImageUrl: "", title: "gh", locationName: "sadfs", categoryName: "cate")])
}
