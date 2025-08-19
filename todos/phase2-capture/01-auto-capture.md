# Phase 2: Auto-Capture Implementation
*Prerequisites: Complete Phase 1 Vision Setup (02-vision-setup.md) and CoreML Setup (03-coreml-setup.md)*

## Motion Detection
- [ ] Import CoreMotion framework
- [ ] Create MotionManager.swift in Services/Camera/
- [ ] Set up CMMotionManager instance
- [ ] Start device motion updates
- [ ] Calculate device stability from accelerometer data

## Capture Conditions (Using Phase 1 Components)
- [ ] Create CaptureConditionsChecker.swift
- [ ] Use RectangleDetector from Phase 1 for card detection
- [ ] Use MLCardClassifier from Phase 1 for card validation
- [ ] Check rectangle is stable (from RectangleStabilityTracker)
- [ ] Check device is stable (minimal motion)
- [ ] Check card classification confidence > 0.8

## Visual Detection Feedback
- [ ] Keep rectangle overlay from Phase 1 visible
- [ ] Change corner brackets color: grey (searching) → green (detected) → green and thick (ready)
    - [ ] The corner brackets animate inward when card detected
- [ ] Show confidence percentage near rectangle
- [ ] Pulse rectangle border when ready to capture

## Auto-Capture Logic
- [ ] Create AutoCaptureManager.swift
- [ ] Monitor all capture conditions
- [ ] Animate corner brackets to thicker when conditions met
- [ ] Reset corner brackets if card moves or conditions lost

## Capture Animation
- [ ] Shrink corner brackets slightly (95%) when capturing
- [ ] Flash white overlay at 0.3 opacity
- [ ] Freeze the rectangle overlay in place
- [ ] Show circular progress indicator during processing
- [ ] Animate checkmark when capture successful

## Capture Execution
- [ ] Create capturePhoto method in CameraView
- [ ] Configure AVCapturePhotoSettings
- [ ] Implement AVCapturePhotoCaptureDelegate
- [ ] Keep rectangle visible during capture
- [ ] Store captured image with rectangle coordinates

## Capture Feedback
- [ ] Add subtle capture sound effect
- [ ] Trigger medium haptic feedback (UIImpactFeedbackGenerator)
- [ ] Show "Processing..." text during image processing
- [ ] Smooth transition to image review screen
- [ ] Pass rectangle coordinates to review screen
