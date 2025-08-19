# Phase 1: CoreML Integration

## Model Setup
- [ ] Add existing CoreML model file to project
- [ ] Ensure model is added to app target
- [ ] Create MLCardClassifier.swift in Services/ML/
- [ ] Import CoreML and Vision frameworks
- [ ] Initialize model in MLCardClassifier

## Classification Pipeline
- [ ] Create method to crop detected rectangle from frame
- [ ] Resize cropped image to model input size
- [ ] Create VNCoreMLRequest with the model
- [ ] Handle classification results
- [ ] Define confidence threshold (0.8)

## Model Integration with Camera
- [ ] Add MLCardClassifier property to CameraView
- [ ] Call classification only when rectangle is stable
- [ ] Process classification on background queue
- [ ] Update UI on main queue with results
- [ ] Add isCard boolean state variable

## Classification Feedback
- [ ] Show "Card Detected" label when confident
- [ ] Show confidence percentage in debug mode
- [ ] Change rectangle color based on classification
- [ ] Add haptic feedback when card detected
- [ ] Throttle classification to once per second