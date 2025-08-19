# Phase 2: Image Processing Pipeline

## Perspective Correction
- [ ] Create ImageProcessor.swift in Services/ImageProcessing/
- [ ] Extract rectangle corners from VNRectangleObservation
- [ ] Create CIPerspectiveCorrection filter
- [ ] Apply perspective transform to captured image
- [ ] Handle edge cases (partial rectangles)

## Image Cropping
- [ ] Calculate crop rectangle with small padding
- [ ] Crop image using CGImage APIs
- [ ] Maintain original image aspect ratio
- [ ] Handle different card orientations
- [ ] Save both original and cropped versions

## Background Removal
- [ ] Create BackgroundRemover.swift
- [ ] Use CIFilter for initial edge detection
- [ ] Apply threshold to create mask
- [ ] Clean up mask edges
- [ ] Composite card on white background

## Image Enhancement
- [ ] Create ImageEnhancer.swift
- [ ] Auto-adjust brightness using CIFilter
- [ ] Auto-adjust contrast
- [ ] Apply slight sharpening filter
- [ ] Reduce noise if needed

## Quality Validation
- [ ] Check image resolution (minimum 1024px)
- [ ] Detect blur using Laplacian variance
- [ ] Check for proper lighting
- [ ] Validate crop contains full card
- [ ] Return quality score