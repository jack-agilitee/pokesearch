# Phase 1: Vision Framework Setup

## VisionKit Integration
- [ ] Import Vision framework in project
- [ ] Create VisionService.swift in Services/Camera/
- [ ] Create RectangleDetector.swift for card detection
- [ ] Set up VNDetectRectanglesRequest basic configuration
- [ ] Add minimum aspect ratio for card detection (2.5:3.5 ratio)

## Rectangle Detection Implementation
- [ ] Create method to convert CMSampleBuffer to CVPixelBuffer
- [ ] Implement performRectangleDetection method
- [ ] Add rectangle observation handler
- [ ] Convert Vision coordinates to UIKit coordinates
- [ ] Create RectangleObservation model struct

## Visual Feedback
- [ ] Create RectangleOverlayView.swift
- [ ] Draw LARGEST detected rectangle corners using Path (corners only)
- [ ] Add green color when rectangle is stable
- [ ] Add greay color when searching for rectangle
- [ ] Animate rectangle appearance/disappearance

## Stability Tracking
- [ ] Create RectangleStabilityTracker.swift
- [ ] Store last 3 rectangle observations
- [ ] Calculate position variance between frames
- [ ] Define stability threshold (5% variance)
- [ ] Emit stability status updates
