//
//  HomeView.swift
//  Nanuming
//
//  Created by 가은 on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var mapVM: MapViewModel = .init()
    @State private var isMapButtonClicked = false
    @State var searchText: String = ""
    @State private var isPresentedPostDetail = false
    @State private var isPresentedCreatePost = false
    @State var relocateButtonTapped = false
    @State var placeList: [PlaceLocation] = [PlaceLocation(locationId: 1, latitude: 37.566535, longitude: 126.967969), PlaceLocation(locationId: 2, latitude: 37.566535, longitude: 126.977969)]
    @State var postList: [PostCellByLocation] = [PostCellByLocation(itemId: 1, mainItemImageUrl: "", title: "gh", locationName: "sadfs", categoryName: "cate"), PostCellByLocation(itemId: 1, mainItemImageUrl: "", title: "gh", locationName: "sadfs", categoryName: "cate")]
    
    let category: [String] = ["전체", "장난감", "도서", "의류", "육아용품", "기타"]
    @State var selectedCategoryId: Int = 0
//    @State var isPresentedPlace: Bool = false
//    @State var locationId: Int = 0
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 15) {
                // 리스트 이동 버튼
                Button {
                    isMapButtonClicked.toggle()
                } label: {
                    VStack {
                        Image(systemName: isMapButtonClicked ? "list.bullet" : "map")
                            .resizable()
                            .frame(width: 22, height: 16)
                        Text(isMapButtonClicked ? "목록" : "지도")
                            .font(.system(size: 9, weight: .medium))
                    }
                    .foregroundColor(.greenMain)
                }
                
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
            .padding(EdgeInsets(top: 15, leading: 15, bottom: 10, trailing: 15))
            
            // map
            if isMapButtonClicked {
                ZStack(alignment: .top) {
                    MapView(mapVM: mapVM, placeList: placeList)
                    VStack(spacing: 5) {
                        categoryFilter()
                            .padding(.top, 5)
                        Button {
                            // 재검색
                            self.relocateButtonTapped.toggle()
                        } label: {
                            Text("이 지역 검색")
                                .padding(EdgeInsets(top: 7, leading: 12, bottom: 7, trailing: 12))
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textBlack)
                                .background(.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                        }
                        Spacer()
                        if mapVM.isPresentedPlace {
                            placeInfoView()
                                .padding(.bottom, 80)
                        }
                    }
                }
            }
            // list
            else {
                // 카테고리 필터
                categoryFilter()
                    .padding(.top, 5)
                
                // 구분선
                Rectangle()
                    .frame(width: screenWidth, height: 13)
                    .foregroundColor(.gray50)
                
                ZStack(alignment: .bottomTrailing) {
                    // post list
                    ScrollView {
                        VStack {
                            ForEach(postList, id: \.itemId) { postcell in
                                
                                let post = Post(title: postcell.title, category: postcell.categoryName, location: postcell.locationName)
                                
                                // modal로 띄우기
                                Button {
                                    isPresentedPostDetail = true
                                } label: {
                                    PostListCell(post: .constant(post))
                                }
                                .fullScreenCover(isPresented: $isPresentedPostDetail) {
                                    PostDetailView(itemId: postcell.itemId)
                                }
                            }
                            
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
                    .frame(width: 50, height: 50)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 15))
                    .fullScreenCover(isPresented: $isPresentedCreatePost) {
                        CreatePostView()
                    }
                }
            }
        }
        .onAppear(
            perform: {
                getPostAPI()
            }
            
        )
    }
    
    func getPostAPI() {
        LocationService().getPostList(mapVM.userLocation.latitude, mapVM.userLocation.longitude, mapVM.deltaLocation.latitude, mapVM.deltaLocation.longitude) { postListByLocation in
            self.placeList = postListByLocation.locationInfoDtoList
            self.postList = postListByLocation.itemOutlineDtoList
        }
    }
    
    @ViewBuilder
    func categoryFilter() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0 ..< category.count) { idx in
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
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
        }
    }
    
    @ViewBuilder
    func placeInfoView() -> some View {
        HStack(spacing: 10) {
            VStack {
                Text("병아리어린이집")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textBlack)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 13, height: 20)
                    .foregroundColor(.textBlack)
            }
        }
        .padding()
        .frame(width: screenWidth*0.85, height: 120)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
    }
}

// #Preview {
//     HomeView(isPresentedPlace: .constant(false))
// }
