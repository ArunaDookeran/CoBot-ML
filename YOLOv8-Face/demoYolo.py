import cv2
import numpy as np
from time import time
import torch.backends.cudnn as cudnn
import torch
import numpy as np
from ultralytics import YOLO
import cv2
from detection import detect_faces
from PIL import Image

def get_model(weights):
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    device = 'mps' if torch.backends.mps.is_available() else device
    
    if device == 'cuda': cudnn.benchmark = True
    
    print(f"Using device: {device}\n")
    
    model = YOLO(weights)                
    model.to(device)
    return model

# Added to help with 'cold start'
# Warm up CUDA
import gc
print("Waring up GPU...")
try:
    # Allocate and free a small tensor to initiate CUDA
    dummy = torch.zeros(1).cuda()
    torch.cuda.synchronize()
    del dummy
    torch.cuda.empty_cache()
    gc.collect()  
    print("GPU warmed up successfully!")
except Exception as e:
    print(f"GPU warmup failed: {e}")
    print("Retrying...")
    # Try again
    dummy = torch.zeros(1).cuda()
    del dummy
    torch.cuda.empty_cache()
    
# Initialize YOLO on GPU device.
detector = get_model('yolov8n_100e.pt')
total = []
first_time =  time()
cap = cv2.VideoCapture(0)
while cap.isOpened():
    success, image = cap.read()
    
    start_time = time()
    # Detect face boxes on image.
    crops, boxes, scores, cls = detect_faces(detector, [Image.fromarray(image)], box_format='xywh',th=0.4)
    
    fps = 1/(time() - start_time)
    total.append(fps)

    # Draw detected faces on image.
    for (left, top, right, bottom), score in zip(boxes[0], scores[0]):
        cv2.rectangle(image, (int(left), int(top)), (int(left+right), int(top+bottom)), (255, 0, 0), 2)
        cv2.putText(image, f"FPS: {fps:.2f}", (10, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
        cv2.putText(image, f'Avg. FPS: {np.mean(total):.2f}', (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
        cv2.putText(image, f'Max. FPS: {max(total):.2f}', (10, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
        cv2.putText(image, f'Min. FPS: {min(total):.2f}', (10, 80), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
        cv2.putText(image, f"Face {score:.2f}",(int(left), int(top) - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)
    
    
    cv2.putText(image, f'{time()-first_time:.2f}s', (10, 100), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)
    
    cv2.imshow('YOLO DEMO', image)

    if cv2.waitKey(5) & 0xFF == ord('q'):
        break
    
cap.release()
cv2.destroyAllWindows()
