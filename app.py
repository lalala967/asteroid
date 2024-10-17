from fastapi import FastAPI
import cv2
import uvicorn
from ultralytics import YOLO
import threading

#fastapi instance
app = FastAPI()

model = YOLO('yolov8n.pt') 

is_running = False
detection_thread = None

# Function to capture video and perform detection
def capture_and_detect():
    global is_running
    is_running = True
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Error: Could not open video source")
        return

    while is_running:
        ret, frame = cap.read()
        if not ret:
            print("Failed to grab frame")
            break

        results = model.track(frame, persist=True, classes=[0,2,63])

#bounding box
        labels, boxes, confidences = [], [], []
        for r in results:
            for det in r.boxes:
                cls = int(det.cls)
                conf = float(det.conf)
                xyxy = det.xyxy[0].tolist()

                label = r.names[cls]

                labels.append(label)
                boxes.append(xyxy)
                confidences.append(conf)

        for i, box in enumerate(boxes):
            cv2.rectangle(frame, (int(box[0]), int(box[1])), (int(box[2]), int(box[3])), (0, 255, 0), 2)
            label_text = f"{labels[i]}: {confidences[i]:.2f}"
            cv2.putText(frame, label_text, (int(box[0]), int(box[1]) - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)



        cv2.imshow("YOLO Detection", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
    is_running = False


#fastapi endpoints
@app.get("/start_detection")
async def start_detection():
    global detection_thread
    if detection_thread is None or not is_running:
        detection_thread = threading.Thread(target=capture_and_detect)
        detection_thread.start()
        return {"status": "Detection started"}
    else:
        return {"status": "Detection is already running"}

@app.get("/stop_detection")
async def stop_detection():
    global is_running
    is_running = False
    if detection_thread is not None:
        detection_thread.join()  
    return {"status": "Detection stopped"}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
