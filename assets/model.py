import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense
from tensorflow.keras.utils import to_categorical
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from PIL import Image
import os

# Function to load and preprocess images
def load_images(base_path):
    images = []
    labels = []
    for label_dir in os.listdir(base_path):
        for image_file in os.listdir(os.path.join(base_path, label_dir)):
            image_path = os.path.join(base_path, label_dir, image_file)
            with Image.open(image_path) as img:
                img = img.convert('L').resize((64, 64))  # Convert to grayscale and resize
                images.append(np.array(img))
                labels.append(label_dir)  # Assuming folder names are labels
    return np.array(images), labels

# Load images
base_path = 'C:/Users/reemf/Downloads'  # Path where your images are stored
images, labels = load_images(base_path)

# Encode labels
label_encoder = LabelEncoder()
encoded_labels = label_encoder.fit_transform(labels)
categorical_labels = to_categorical(encoded_labels)

# Prepare data for training
X = images.reshape(-1, 64, 64, 1)  # Add a channel dimension
Y = categorical_labels

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

# Define model
model = Sequential([
    Conv2D(32, (3, 3), activation='relu', input_shape=(64, 64, 1)),
    MaxPooling2D(2, 2),
    Conv2D(64, (3, 3), activation='relu'),
    MaxPooling2D(2, 2),
    Flatten(),
    Dense(64, activation='relu'),
    Dense(len(label_encoder.classes_), activation='softmax')
])

# Compile model
model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# Train model
model.fit(X_train, y_train, epochs=10, validation_data=(X_test, y_test))
