//
//  PhotoPicker.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import Foundation
import PhotosUI
import SwiftUI
struct PhotoPicker: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?

    @ObservedObject var model = CommentViewModel()
    var body: some View {
        VStack {
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                .onChange(of: avatarItem) { newItem in
                        Task {
                            // Retrieve selected photo from PhotosPicker
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                avatarData = data
                                avatarImage = Image(uiImage: UIImage(data: data)!)
                            }
                        }
                    }
            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            
            Button(action: {
                if let data = avatarData {
                       let comment = CreateComment(body: "hello", user_id: 6, post_id: 3, photo: data)
                       model.createComment(comment: comment) { success in
                           if success {
                               print("Comment created successfully")
                           } else {
                               print("Failed to create comment")
                           }
                       }
                   } else {
                       let comment = CreateCommentNonePhoto(body: "aaa", user_id: 6, post_id: 3)
                       model.createCommentNonePhoto(comment: comment) { success in
                           if success {
                               print("Comment created successfully")
                           } else {
                               print("Failed to create comment")
                           }
                       }
                   }
                
                   }) {
                       Text("Submit Comment")
                   }
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
