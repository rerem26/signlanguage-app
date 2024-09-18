from flask import Flask, request, jsonify
import joblib

# Load the saved model and vectorizer
model = joblib.load('translation_model.pkl')
vectorizer = joblib.load('vectorizer.pkl')

app = Flask(__name__)

@app.route('/translate', methods=['POST'])
def translate():
    # Parse the input gesture from the request body
    data = request.json
    if 'gesture' not in data:
        return jsonify({'error': 'No gesture provided'}), 400

    gesture = data['gesture']

    # Vectorize the input gesture
    gesture_vector = vectorizer.transform([gesture])

    # Get the translation from the model
    translation = model.predict(gesture_vector)[0]

    return jsonify({'translation': translation})

if __name__ == '__main__':
    app.run(debug=True)
