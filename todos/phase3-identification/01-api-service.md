# Phase 3: API Service Layer

## Network Manager Setup
- [ ] Create NetworkManager.swift in Services/API/
- [ ] Define base Azure Functions URL
- [ ] Create URLSession configuration
- [ ] Add timeout settings (30 seconds)
- [ ] Add retry count property

## API Models
- [ ] Create CardMatch.swift model:
  ```swift
  struct CardMatch {
      let cardId: String
      let confidence: Float
      let title: String
      let imageUrl: String
  }
  ```

- [ ] Create APIError enum for error handling
- [ ] Create APIResponse wrapper struct
- [ ] Create PricingData model struct
- [ ] Create CardDetails model for full card info

## Card Identification Service
- [ ] Create CardIdentificationService.swift
- [ ] Method to convert UIImage to base64
- [ ] Method to prepare identification request
- [ ] Send image + OCR text to API
- [ ] Parse identification response

## Request Building
- [ ] Create APIRequest builder class
- [ ] Add method to create multipart/form-data
- [ ] Add image compression (JPEG, 0.8 quality)
- [ ] Include OCR results in request body
- [ ] Add request headers (auth token placeholder)

## Response Handling
- [ ] Parse JSON response to CardMatch array
- [ ] Handle multiple match results
- [ ] Sort matches by confidence
- [ ] Cache successful responses
- [ ] Handle API errors gracefully