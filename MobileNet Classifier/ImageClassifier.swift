//
//  ImageClassifier.swift
//  MobileNet Classifier
//
//  Created by Sam Greenfield on 5/28/25.
//

import CoreML
import UIKit
import Foundation

class FastViTClassifier {
    private let model: FastViTMA36F16
//    private let labels: [String]
    
    init?() {
        guard let model = try? FastViTMA36F16(configuration: MLModelConfiguration()) else { return nil }
        self.model = model
    }
    
    func classify(image: UIImage) -> String {
        let (buffer, previewImage) = preprocess(image: image, size: CGSize(width: 256, height: 256))
        guard let pixelBuffer = buffer else {
            return "Error: Preprocessing"
        }
        
        guard let prediction = try? model.prediction(input: FastViTMA36F16Input(image: buffer!)) else { return "Error: Prediction" }
        
        var top5 = topKPredictions(from: prediction.classLabel_probs)
        for i in 0...top5.count-1 {
            var formattedProbability = String(format: "%.2f", top5[i].probability * 100)
            print("\(top5[i].label): \(formattedProbability)%")
        }
        
        if let preview = previewImage {
            UIImageWriteToSavedPhotosAlbum(preview, nil, nil, nil)
        }
        
        return prediction.classLabel
    }
    
    func topKPredictions(from logits: [String: Double], topK: Int = 5) -> [(label: String, probability: Double)] {
        // Step 1: Apply softmax to get probabilities
        let expValues = logits.mapValues { exp($0) }
        let sumExp = expValues.values.reduce(0, +)
        let probabilities = expValues.mapValues { $0 / sumExp }
        
        // Step 2: Sort by probability, descending
        let sorted = probabilities.sorted { $0.value > $1.value }
        
        // Step 3: Return top K
        return Array(sorted.prefix(topK)).map { (key, value) in
            (label: key, probability: value)
        }
    }
}


class mobileNetClassifier {
    private let model: mobilenet_v2
    private let labels: [String]
    
    init?() {
        // Load model
        guard let model = try? mobilenet_v2(configuration: MLModelConfiguration()) else { return nil }
        self.model = model
        
        // Load labels
        guard let path = Bundle.main.path(forResource: "labels", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            self.labels = []
            return nil
        }
        self.labels = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }
    
    func classify(image: UIImage) -> String {
        let (buffer, previewImage) = preprocess(image: image)
        guard let pixelBuffer = buffer else { return "Error: Preprocessing" }

//        UNCOMMENT TO SAVE TO PHOTOS APP
//        if let preview = previewImage {
//            UIImageWriteToSavedPhotosAlbum(preview, nil, nil, nil)
//        }

        guard let prediction = try? model.prediction(input_1: pixelBuffer) else { return "Error: Model" }

        let scores = prediction.Identity
        let logits = (0..<scores.count).map { scores[$0].floatValue }

        let top5 = logits.enumerated()
            .sorted(by: { $0.element > $1.element })
            .prefix(5)

        for (index, score) in top5 {
            let label = index < labels.count ? labels[index] : "Unknown"
            print("\(label): \(score)")
        }

        return top5.first.map { labels[$0.offset] } ?? "Unknown"
    }
}
