# translate.py

import joblib

# Load the saved model and vectorizer
model = joblib.load('translation_model.pkl')
vectorizer = joblib.load('vectorizer.pkl')

# Function to translate an English word to Filipino
def translate_english_to_filipino(word):
    word_vector = vectorizer.transform([word])  # Convert the word to a vector
    prediction = model.predict(word_vector)  # Predict the Filipino translation
    return prediction[0]

# Test the translation function
if __name__ == "__main__":
    sample_word = input("Enter an English word to translate: ").upper()
    translation = translate_english_to_filipino(sample_word)
    print(f"The Filipino translation of '{sample_word}' is '{translation}'")
