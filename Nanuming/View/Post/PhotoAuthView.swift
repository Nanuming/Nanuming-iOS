//
//  PhotoAuthView.swift
//  Nanuming
//
//  Created by byeoungjik on 2/16/24.
//

import SwiftUI
import UIKit

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

struct PhotoAuthView: View {
    @State var confirmItemImageId: Int? = 0
    @State private var image: UIImage?
    @State private var showingImagePicker = false
    @State private var isConfirmed = false
    @State var hasImage = false
    @State var isAssignedPicture = false
    var itemId: Int = 0
    var memberId: Int = 0
    
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
                        self.isConfirmed = true
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
                        if let safeImage = image {
                            PostService().uploadImage(safeImage, itemId: itemId) { success, message  in
                                DispatchQueue.main.async {
                                    if success {
                                        print("success: \(success), message: \(message)")
                                        isAssignedPicture = true
                                    } else {
                                        print("success: \(success), message: \(message)")
                                    }
                                }
                            }
                        }
                        else {
                            hasImage = true
                        }
                        
                    }) {
                        Text("확인")
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(isConfirmed ? .greenMain : Color.gray)
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
        .alert(LocalizedStringKey("등록한 물품의 인증이 필요해요."), isPresented: $hasImage, actions: {
            Button(action: {
                hasImage = false
            }, label: {
                Text("확인")
            })
        }, message: {
            Text("사진을 찍어 인증해주세요.")
        })
        .fullScreenCover(isPresented: $isAssignedPicture, content: {
            TabBarView()
        })
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoAuthView()
    }
}
