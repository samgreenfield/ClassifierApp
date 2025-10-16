//
//  CustomCameraView.swift
//  MobileNet Classifier
//
//  Created by Sam Greenfield on 5/28/25.
//

import SwiftUI

struct CustomCameraView: View {
    
    let cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let image):
                    if let data = image.fileDataRepresentation() {
                        capturedImage = UIImage(data: data)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Failed to convert photo to data.")
                    }
                    
                case .failure(let error):
                    print("Error capturing image: \(error)")
                }
            }
            
            GeometryReader { geometry in
                let length = min(geometry.size.width, geometry.size.height)
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.white.opacity(0.7), lineWidth: 2)
                    .frame(width: length, height: length)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            
            VStack {
                Spacer()
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                })
                .padding(.bottom)
            }
        }
    }
}
