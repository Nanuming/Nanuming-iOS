//
//  PostImagePicker.swift
//  Nanuming
//
//  Created by 가은 on 2/4/24.
//

import PhotosUI
import SwiftUI

struct PostImagePicker: View {
    @Binding var post: Post
    @State var selectedPhotos: [PhotosPickerItem] = []

    var body: some View {
        HStack {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10, matching: .images) {
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
            }
            .onChange(of: selectedPhotos, initial: false) { _, _ in
                guard let item = selectedPhotos.first else { return }
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            print(data)
                        } else {
                            print("data is nil")
                        }
                    case .failure(let failure):
                        fatalError("\(failure)")
                    }
                }
            }
        }
    }
}

#Preview {
    PostImagePicker(post: .constant(Post()))
}
