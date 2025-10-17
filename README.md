# Portfolio Project Summary

## 1. Resume Entry

### **MobileNet Classifier Demo App (iOS/On-Device ML)**

[cite_start]Developed a native **Swift** application for **iOS** to demonstrate on-device machine learning capabilities using **Core ML**[cite: 3, 4, 54].

* [cite_start]Utilized the pre-trained **MobileNetV2** deep learning model for image classification[cite: 11, 12, 57].
* [cite_start]Implemented **Core ML Tools** and **Python** scripting to convert the **TensorFlow** model [cite: 9, 13, 48][cite_start], sourced from **Kaggle** [cite: 14][cite_start], into the Core ML **`.mlpackage`** format[cite: 9, 52].
* [cite_start]The application features a **Camera** view for image capture and an **Image Classifier** view that displays the image with a classification label from **MobileNetV2**[cite: 55, 56, 57].
* [cite_start]Handled image preprocessing (cropping and resizing to $196 \times 196$) to meet the model's input requirements[cite: 58, 61].

---

## 2. Project README File

# MobileNet Classifier Demo App

## Overview

[cite_start]This project is an **iOS** application built in **Swift** that demonstrates **on-device machine learning (ML)** using **Apple's Core ML framework**[cite: 3, 4, 54]. [cite_start]The app functions as a basic image classifier, utilizing a converted **MobileNetV2** model to provide quick object predictions directly on the device[cite: 11, 57]. [cite_start]This project showcases the complete pipeline: model sourcing, conversion, and native application integration[cite: 47].

---

## Features

* [cite_start]**Platform:** Built in **Swift** for **iOS**[cite: 54].
* [cite_start]**On-Device ML:** Uses **Core ML** to execute predictions locally on Apple devices[cite: 3, 4].
* [cite_start]**Model:** Integrates the pre-trained **MobileNetV2** model, which was trained on **ImageNet** (1001 classes)[cite: 11, 12, 15].
* [cite_start]**User Interface:** Features two main views: a **Camera** view for taking a picture and an **Image Classifier** view for displaying the image and the classification result[cite: 55, 56, 57].
* [cite_start]**Debug Output:** Prints the top five classification results along with their scores to the Xcode debugger[cite: 58].
* [cite_start]**Image Preprocessing:** Automatically handles cropping and resizing the input image to the required $196 \times 196$ dimensions for the MobileNetV2 model[cite: 61].

---

## Model Conversion Pipeline

[cite_start]The initial **TensorFlow 2** MobileNetV2 model [cite: 13] [cite_start]was converted into the **Core ML** format (`.mlpackage`) [cite: 9, 52] to enable native on-device execution. [cite_start]This process was managed using the **Python** library **`coremltools`**[cite: 48].

[cite_start]The conversion followed three primary steps[cite: 49]:

1.  [cite_start]**Import:** Import the TensorFlow model (in this case, `mobilenet_v2` from Kaggle)[cite: 50].
2.  **Convert:** Use the `ct.convert` function, specifying the source as `"tensorflow"` and the target as `"mlprogram"`. [cite_start]Define the input as an **ImageType** with shape $(1, 192, 192, 3)$ and a scale of $1/255.0$[cite: 51].
3.  [cite_start]**Save:** Save the resulting Core ML model as a `*.mlpackage` file[cite: 52].

### Python Conversion Snippet

```python
# Step 1: Import a model (mobilenet_v2)
model = tf.keras.Sequential([
    tf.keras.layers.InputLayer(input_shape=(192, 192, 3)),
    tf_hub.KerasLayer(model_path)
])
model.build([1, 192, 192, 3])

# Step 2: Convert model from source format to Core ML
mlmodel = ct.convert(
    model,
    source="tensorflow",
    convert_to="mlprogram",
    inputs=[ct.ImageType(shape=(1, 192, 192, 3), scale=1/255.0)],
)

# Step 3: Save model as a *.mlpackage file
mlmodel.save(output_path + ".mlpackage")
