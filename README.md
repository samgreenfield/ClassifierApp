# MobileNet Classifier Demo App (iOS)

## Overview

The classifier application is developed in Swift and showcases*on-device machine learning (ML) capabilities using Apple's Core ML framework. The app allows users to capture an image with the device's camera and instantly classifies the objects present using the [MobileNet Classifier](https://www.kaggle.com/models/google/mobilenet-v2?select=saved_model.pb).

## Example Classification

The application provides a primary label (as seen on the device screen) and detailed scores for the top five predictions (available in the Xcode console):

<img width="1088" height="494" alt="Screenshot 2025-10-16 at 8 24 06 PM" src="https://github.com/user-attachments/assets/a7deba3f-dc42-45d7-a1ea-250d693d3420" />

## Technology Stack

* **App Development:** Swift, iOS SDK
* **Machine Learning Framework:** Core ML
* **Model:** MobileNetV2 (Pre-trained object detection/classification model, translated to CoreML .mlpackage)
