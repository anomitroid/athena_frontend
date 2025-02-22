from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/image', methods=['POST'])
def check_image():
    if 'image' not in request.files:
        return jsonify({"message": "No image received"}), 400
    
    image = request.files['image']
    
    if image.filename == '':
        return jsonify({"message": "No image selected"}), 400

    return jsonify({"message": "Image received successfully"}), 200

@app.route('/text', methods=['POST'])
def check_text():
    data = request.get_json()
    if not data or 'text' not in data:
        return jsonify({"message": "No text received"}), 400
    
    text = data['text'].strip()
    if not text:
        return jsonify({"message": "Text is empty"}), 400

    return jsonify({"message": "Text received successfully", "text": text}), 200

if __name__ == '__main__':
    app.run(port=3000, debug=True)
