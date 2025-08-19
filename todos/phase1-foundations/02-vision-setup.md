# Phase 1: Vision Framework Setup

## VisionKit Integration
- [x] Import Vision framework in project
- [x] Create VisionService.swift in Services/Camera/
- [x] Create RectangleDetector.swift for card detection
- [x] Set up VNDetectRectanglesRequest basic configuration
- [x] Add minimum aspect ratio for card detection (2.5:3.5 ratio)

## Rectangle Detection Implementation
- [x] Create method to convert CMSampleBuffer to CVPixelBuffer
- [x] Implement performRectangleDetection method
- [x] Add rectangle observation handler
- [x] Convert Vision coordinates to UIKit coordinates
- [x] Create RectangleObservation model struct

## Visual Feedback
- [x] Create RectangleOverlayView.swift
- [x] Draw LARGEST detected rectangle corners using Path (corners only)
- [x] Add green color when rectangle is stable
- [x] Add gray color when searching for rectangle
- [x] Animate rectangle appearance/disappearance

## Stability Tracking
- [x] Create RectangleStabilityTracker.swift
- [x] Store last 3 rectangle observations
- [x] Calculate position variance between frames
- [x] Define stability threshold (5% variance)
- [x] Emit stability status updates
