//
//  MLMultiArray+Helpers.swift
//  MobileNet Classifier
//
//  Created by Sam Greenfield on 5/28/25.
//

import Foundation
import CoreML

extension MLMultiArray {
    func argmax() -> Int {
        var maxIndex = 0
        var maxValue = self[0].floatValue
        for i in 1..<self.count {
            let val = self[i].floatValue
            if val > maxValue {
                maxValue = val
                maxIndex = i
            }
        }
        return maxIndex
    }
}
