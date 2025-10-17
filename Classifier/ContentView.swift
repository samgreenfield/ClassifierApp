//
//  ContentView.swift
//  MobileNet Classifier
//
//  Created by Sam Greenfield on 5/28/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented: Bool = true
    @State private var predictedLabel: String? = nil
    
//    let classifier = mobileNetClassifier()
    let classifier = FastViTClassifier()
    
    var body: some View {
        ZStack {
            if capturedImage != nil {
                Image(uiImage: capturedImage!)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if let label = predictedLabel {
                    Text(label)
                        .font(.largeTitle)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                
            } else {
                Color(UIColor.systemBackground)
            }
            
            VStack {
                Spacer()
                Button(
                    action: {
                        isCustomCameraViewPresented.toggle()
                    },
                    label: {
                        Image(systemName: "camera.fill")
                            .font(.largeTitle)
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                )
                .padding(.bottom)
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    CustomCameraView(capturedImage: $capturedImage)
                }
                )
            }
            .onChange(of: capturedImage) {
                if let img = capturedImage {
                    predictedLabel = classifier?.classify(image: img)
                }
            }
        }
    }
}
