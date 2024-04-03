from flask import Flask, request, jsonify
import cv2
import torch
import numpy as np
from werkzeug.utils import secure_filename
import os
from ultralytics import YOLO

app = Flask(__name__)

# Load YOLOv8 model
model = YOLO("C:\Users\Senal\Desktop\Github\SE76_EcoQuest\ml\model.pt")
# model.eval()

@app.route('/detect', methods=['POST'])
def detect_objects():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify({'error': 'No selected file'})
    
    if file and allowed_file(file.filename):
        if not os.path.exists('uploads'):
            os.makedirs('uploads')
        filename = secure_filename(file.filename)
        file_path = os.path.join('uploads', filename)
        file.save(file_path)
        video_bytes = file_path
        # with open(file_path, 'rb') as f:
        #     video_bytes = f.read()
        
        results = process_video(video_bytes)
        os.remove(file_path)
        return jsonify(results)
    else:
        return jsonify({'error': 'Invalid file type'})

def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'mp4', 'avi', 'mov', 'mkv'}  # Add more extensions if needed
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def process_video(video_bytes):
    cap = cv2.VideoCapture()
    
    # Read video from bytes
    cap.open(video_bytes, cv2.CAP_FFMPEG)
    # cap = cv2.VideoCapture(video_bytes, cv2.CAP_FFMPEG)
    results = []
    index = 0
    while cap.isOpened():
        ret, frame = cap.read()

        if not ret:
            break

        # Run YOLOv8 inference on the frame
        detected_objects = run_inference(frame, model)
        # For demonstration, just returning the frame number
        results.append({'frameID': index, 'objects': detected_objects})
        index+= 1

    cap.release()
    return results

def run_inference(frame, model):
    # print(model)
    # Resize frame to match input size expected by the model
    input_size = (640, 640)  # YOLOv8 input size
    resized_frame = cv2.resize(frame, input_size)

    # Convert frame to tensor and normalize
    input_tensor = torch.tensor(resized_frame / 255.0).permute(2, 0, 1).unsqueeze(0).float()

    # Run inference
    with torch.no_grad():
        outputs = model.predict(resized_frame)

    # Process outputs
    detections = postprocess(outputs[0])

    return detections

def postprocess(result):
    # Example postprocessing function
    # This function may vary depending on the output format of your YOLOv8 model
    # Here, we assume YOLOv8 outputs bounding boxes in a specific format

    # Placeholder for detected objects
  
    output = []
    for box in result.boxes:
        x1, y1, x2, y2 = [
          round(x) for x in box.xyxy[0].tolist()
        ]
        class_id = box.cls[0].item()
        prob = round(box.conf[0].item(), 2)
        output.append([
          x1, y1, x2, y2, result.names[class_id], prob
        ])

    print(output)
    return output


if __name__ == '__main__':
    app.run(debug=True,host = '0.0.0.0', port = '5000')
