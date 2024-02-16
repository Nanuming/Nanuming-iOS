//
//  PhotoAuthView.swift
//  Nanuming
//
//  Created by byeoungjik on 2/16/24.
//

import SwiftUI
import UIKit

// UIImagePickerController를 SwiftUI에서 사용하기 위한 래퍼 뷰
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// 사진 촬영 및 재촬영, 확인 버튼을 포함하는 SwiftUI 뷰
struct PhotoAuthView: View {
    @State private var image: UIImage?
       @State private var showingImagePicker = false
       @State private var isConfirmed = false

       var body: some View {
           NavigationView {
               VStack {
                   Spacer()
                   
                   if let image = image {
                       Image(uiImage: image)
                           .resizable()
                           .scaledToFit()
                   } else {
                       Text("사진")
                           .font(.largeTitle)
                           .foregroundColor(.gray)
                   }
                   
                   Spacer()
                   
                   HStack {
                       Button(action: {
                           self.showingImagePicker = true
                       }) {
                           RoundedRectangle(cornerRadius: 10)
                               .stroke()
                               .foregroundColor(.greenMain)
                               .frame(height: 50)
                               .overlay(content: {
                                   Text("촬영")
                                       .foregroundColor(.greenMain)
                                       .frame(minWidth: 0, maxWidth: .infinity)
                                       .padding()
                                       .cornerRadius(10)
                               })
                       }

                       Button(action: {
                           self.isConfirmed = true
                           // TODO: API 연결 필요
                       }) {
                           Text("확인")
                               .foregroundColor(.white)
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .padding()
                               .background(isConfirmed ? Color.green : Color.gray)
                               .cornerRadius(10)
                       }.disabled(image == nil)
                   }
                   .padding()
               }
               .navigationBarTitle("사진 촬영", displayMode: .inline)
               .sheet(isPresented: $showingImagePicker) {
                   ImagePickerView(image: self.$image)
               }
           }
       }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoAuthView()
    }
}
