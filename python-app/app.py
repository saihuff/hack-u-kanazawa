from flask import Flask, request, jsonify
import cv2
import numpy as np
import dlib
from scipy.spatial import distance as dist

app = Flask(__name__)

# EAR (Eye Aspect Ratio) を計算する関数
def eye_aspect_ratio(eye):
    A = dist.euclidean(eye[1], eye[5])
    B = dist.euclidean(eye[2], eye[4])
    C = dist.euclidean(eye[0], eye[3])
    ear = (A + B) / (2.0 * C)
    return ear

# dlib の準備
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file:
        # 画像を読み込む
        in_memory_file = file.read()
        np_img = np.frombuffer(in_memory_file, np.uint8)
        img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)
        
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        rects = detector(gray, 0)

        for rect in rects:
            shape = predictor(gray, rect)
            shape = [(shape.part(i).x, shape.part(i).y) for i in range(68)]

            leftEye = shape[42:48]
            rightEye = shape[36:42]

            leftEAR = eye_aspect_ratio(leftEye)
            rightEAR = eye_aspect_ratio(rightEye)

            ear = (leftEAR + rightEAR) / 2.0

            # EAR がしきい値より小さければ「asleep」と判定
            if ear < 0.25:
                return jsonify({'status': 'asleep'})

        return jsonify({'status': 'awake'})

if __name__ == '__main__':
    app.run(debug=True)

