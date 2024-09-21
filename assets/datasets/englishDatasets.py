import os
import cv2  # OpenCV to handle image processing
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.utils import to_categorical

# Load your dataset from the Excel file
file_path = (r'C:\Users\reemf\AndroidStudioProjects\signlanguage-app\assets\datasets\english_words'
             r'.xlsx')
data = pd.read_excel(file_path)

# Assuming your dataset has the file paths and corresponding labels
file_paths = data['File Path']
labels = data['Label']

# Base directory where the gesture images are located
base_directory = r'C:\Users\reemf\Downloads'

# Update file paths to include the full path to the images
full_file_paths = [os.path.join(base_directory, os.path.basename(path)) for path in file_paths]

# Define image dimensions
IMG_HEIGHT = 64
IMG_WIDTH = 64
NUM_CLASSES = len(set(labels))  # The number of unique gestures

# Prepare the data: loading images, resizing, and normalizing
def load_images(file_paths):
    images = []
    for path in file_paths:
        # Load the image
        img = cv2.imread(path)
        if img is not None:
            # Resize the image to a fixed size
            img = cv2.resize(img, (IMG_WIDTH, IMG_HEIGHT))
            # Normalize pixel values (0-1)
            img = img / 255.0
            images.append(img)
        else:
            print(f"Error loading image: {path}")
    return np.array(images)

# Convert text labels into numeric categories
from sklearn.preprocessing import LabelEncoder
label_encoder = LabelEncoder()
encoded_labels = label_encoder.fit_transform(labels)

# One-hot encode the labels
encoded_labels = to_categorical(encoded_labels, num_classes=NUM_CLASSES)

# Load images
X = load_images(full_file_paths)
y = encoded_labels

# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Define a simple CNN model
model = Sequential([
    Conv2D(32, kernel_size=(3, 3), activation='relu', input_shape=(IMG_HEIGHT, IMG_WIDTH, 3)),
    MaxPooling2D(pool_size=(2, 2)),
    Conv2D(64, kernel_size=(3, 3), activation='relu'),
    MaxPooling2D(pool_size=(2, 2)),
    Flatten(),
    Dense(128, activation='relu'),
    Dropout(0.5),
    Dense(NUM_CLASSES, activation='softmax')
])

# Compile the model
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# Train the model
model.fit(X_train, y_train, epochs=10, batch_size=32, validation_data=(X_test, y_test))

# Evaluate the model
loss, accuracy = model.evaluate(X_test, y_test)
print(f'Test Accuracy: {accuracy * 100:.2f}%')

# Save the trained model
model.save('gesture_recognition_model.h5')

# Convert predictions back to labels
predicted_classes = np.argmax(model.predict(X_test), axis=-1)
true_classes = np.argmax(y_test, axis=-1)

# Convert numeric predictions back to original label names
predicted_labels = label_encoder.inverse_transform(predicted_classes)
true_labels = label_encoder.inverse_transform(true_classes)

# Display the accuracy and results
print(f'True Labels: {true_labels}')
print(f'Predicted Labels: {predicted_labels}')
