//
//  PostImagePicker.swift
//  Nanuming
//
//  Created by 가은 on 2/4/24.
//

import PhotosUI
import SwiftUI

struct imageWrapper: Identifiable {
    let id = UUID()
    let image: Image
}

struct PostImagePicker: View {
    @Binding var post: Post
    @State var postImageDatas: [Data?] = []
    @State var selectedPhotos: [PhotosPickerItem] = []

    var postImage: [imageWrapper] {
        return postImageDatas.compactMap { imageData -> imageWrapper? in
            guard let uiImage = UIImage(data: imageData ?? Data()) else { return nil }
            return imageWrapper(image: Image(uiImage: uiImage))
        }
    }

    var body: some View {
        HStack {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10, matching: .images) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray100, lineWidth: 1)
                            .frame(width: 70, height: 70)
                            .overlay(
                                VStack(spacing: 3) {
                                    Image(systemName: "camera.fill")
                                        .frame(width: 25, height: 25)
                                    Text(String(selectedPhotos.count) + "/10")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.gray200)
                            )
                        ForEach(Array(postImage.enumerated()), id: \.1.id) { idx, imageWrapper in
                            imageWrapper.image
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(alignment: .topTrailing, content: {
                                    Button(action: {
                                        // 선택한 사진 삭제
                                        postImageDatas.remove(at: idx)
                                        selectedPhotos.remove(at: idx)
                                    }, label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(Color.gray300)
                                            .offset(CGSize(width: 5, height: -5))
                                    })
                                })
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .onChange(of: selectedPhotos, initial: false) { _, _ in
                let imageDatas: [Data] = selectedPhotos.compactMap { item in
                    var imageData: Data?
                    let semaphore = DispatchSemaphore(value: 0) // DispatchSemaphore 생성

                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            imageData = data
                        case .failure(let failure):
                            fatalError("\(failure)")
                        }
                        semaphore.signal() // 신호 보내기
                    }
                    semaphore.wait() // 신호를 받을 때까지 대기

                    return imageData
                }

                postImageDatas = imageDatas
            }
        }
    }
}

#Preview {
    PostImagePicker(post: .constant(Post()))
}
