# Phase 1: Basic Data Models

## Core Models
- [ ] Create Models/Card.swift with basic structure:
  ```swift
  struct Card {
      let id: String
      let title: String
      let set: String
      let number: String
      let rarity: String
      let imageUrl: String?
  }
  ```

- [ ] Create Models/CapturedImage.swift:
  ```swift
  struct CapturedImage {
      let image: UIImage
      let timestamp: Date
      let rectangleObservation: VNRectangleObservation?
  }
  ```

- [ ] Create Models/DetectionResult.swift:
  ```swift
  struct DetectionResult {
      let isCard: Bool
      let confidence: Float
      let rectangle: CGRect
  }
  ```

## Enum Definitions
- [ ] Create CaptureState enum (idle, detecting, ready, captured)
- [ ] Create DetectionError enum for error handling
- [ ] Create CardRarity enum (common, uncommon, rare, etc.)
- [ ] Create ImageQuality enum (low, medium, high)

## Configuration Models
- [ ] Create CameraConfiguration struct with default settings
- [ ] Create DetectionSettings with thresholds
- [ ] Create AppConfiguration for global settings