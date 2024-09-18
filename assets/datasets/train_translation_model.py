# train_translation_model.py

import random
from english import english_words
from filipino import filipino_words
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import joblib

# 1. Ensure that both the English and Filipino lists are the same length
assert len(english_words) == len(filipino_words), "The word lists must be of the same length."

# 2. Pair the English and Filipino words and shuffle the data
data = list(zip(english_words, filipino_words))
random.shuffle(data)

# 3. Split the data into inputs (English words) and outputs (Filipino words)
english_input = [pair[0] for pair in data]
filipino_output = [pair[1] for pair in data]

# 4. Vectorize the English words using TF-IDF
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(english_input)

# 5. Split the data into training and testing sets (80% training, 20% testing)
X_train, X_test, y_train, y_test = train_test_split(X, filipino_output, test_size=0.2, random_state=42)

# 6. Train a logistic regression model
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

# 7. Test the model and print the accuracy
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Model Accuracy: {accuracy * 100:.2f}%")

# 8. Save the model and the vectorizer for later use
joblib.dump(model, 'translation_model.pkl')
joblib.dump(vectorizer, 'vectorizer.pkl')

print("Model and vectorizer saved successfully.")
