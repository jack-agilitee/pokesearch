# =� iOS Pok�mon Card Scanner  Project Plan

## Project Overview
An iOS application that uses computer vision to scan, identify, and catalog Pok�mon cards with real-time pricing and collection management features.

## Tech Stack
- **iOS**: Swift, SwiftUI, VisionKit, CoreML, Vision OCR
- **Backend**: Node.js with Azure Functions (Serverless)
- **Database**: MongoDB Atlas with Vector Search
- **Storage**: Azure Blob Storage for images
- **Auth**: Sign in with Apple
- **APIs**: Pok�mon TCG API, TCGPlayer API

---

## Phase 1: Foundations & Setup
**Timeline**: 2-3 weeks  
**Goal**: Establish core infrastructure and basic card detection

### iOS Environment Setup
- [ ] Create new Xcode project with SwiftUI
- [ ] Configure project structure per CLAUDE.md guidelines
- [ ] Integrate VisionKit for rectangle detection (VNDetectRectanglesRequest)
- [ ] Import existing CoreML model for card classification
- [ ] Implement basic camera preview interface

### Backend Infrastructure
- [ ] **Azure Setup**
  - [ ] Create Azure resource group
  - [ ] Set up Azure Functions (Node.js runtime)
  - [ ] Configure Azure Blob Storage for card images
  - [ ] Set up Azure API Management for rate limiting
  
- [ ] **MongoDB Atlas Configuration**
  - [ ] Provision MongoDB Atlas M10+ cluster (for vector search)
  - [ ] Create database schema:
    ```javascript
    {
      cardId: String,
      title: String,
      set: String,
      series: String,
      rarity: String,
      imageUrl: String,  // Azure Blob Storage URL
      vectorEmbedding: Array,  // For similarity search
      metadata: Object,
      pricing: {
        market: Number,
        low: Number,
        mid: Number,
        high: Number,
        lastUpdated: Date
      }
    }
    ```
  - [ ] Configure Atlas Search indexes
  - [ ] Enable Vector Search capabilities

### API Development (Azure Functions)
- [ ] **Core Functions**:
  ```javascript
  // Card lookup function
  /api/cards/search
  
  // Vector similarity search
  /api/cards/similar
  
  // Text search fallback
  /api/cards/text-search
  
  // Card details by ID
  /api/cards/{id}
  ```

### Data Pipeline
- [ ] **Azure Timer Function** for data sync:
  - [ ] Fetch from Pok�mon TCG API
  - [ ] Fetch pricing from TCGPlayer API
  - [ ] Store in MongoDB Atlas
  - [ ] Generate vector embeddings
  - [ ] Schedule: Every 6 hours

###  **Deliverable**
- Working rectangle detection in camera view
- Card vs non-card classification
- Backend with populated card database
- Basic API endpoints functional

---

## Phase 2: Card Capture & Cleanup
**Timeline**: 2-3 weeks  
**Goal**: Automated card capture with image processing

### Auto-Capture Implementation
- [ ] **Stability Detection**
  - [ ] Monitor device motion (CoreMotion)
  - [ ] Track rectangle stability over 3 frames
  - [ ] Confidence threshold: 95%
  
- [ ] **Capture Trigger** (Two-stage validation)
  - [ ] Stage 1: VisionKit rectangle detection (VNDetectRectanglesRequest)
  - [ ] Stage 2: CoreML model classification (using existing model)
  - [ ] Auto-capture when: rectangle detected + CoreML confirms it's a card
  - [ ] Haptic feedback on capture
  - [ ] Visual feedback (flash animation)

### Image Processing Pipeline
- [ ] **Perspective Correction**
  ```swift
  // Using Vision framework
  VNImageRectangleDetectionRequest
  CIPerspectiveCorrection filter
  ```
  
- [ ] **Background Removal**
  - [ ] Use Vision person segmentation as base
  - [ ] Adapt for card detection
  - [ ] Clean edges with Core Image filters
  
- [ ] **Image Enhancement**
  - [ ] Auto-contrast adjustment
  - [ ] Denoise filter
  - [ ] Sharpness enhancement

### OCR Implementation
- [ ] **Text Extraction**
  - [ ] Use Vision.VNRecognizeTextRequest
  - [ ] Extract card title (top of card)
  - [ ] Extract set info (bottom of card)
  - [ ] Extract card number
  - [ ] Store confidence scores

###  **Deliverable**
- Automatic card capture when detected
- Cleaned, perspective-corrected card images
- Extracted text metadata with confidence scores

---

## Phase 3: Card Identification & Info Retrieval
**Timeline**: 3-4 weeks  
**Goal**: Accurate card identification with full metadata

### iOS Integration
- [ ] **API Service Layer**
  ```swift
  class CardIdentificationService {
    func identifyCard(image: UIImage, 
                      ocrText: OCRResult) async -> CardMatch
  }
  ```

### Azure Function Enhancements
- [ ] **Hybrid Search Function**
  ```javascript
  // /api/cards/identify
  // 1. Generate embedding from image
  // 2. Vector search in MongoDB
  // 3. Text search fallback using OCR
  // 4. Fuzzy matching on titles
  // 5. Return top 3 matches with confidence
  ```

- [ ] **Data Enrichment**
  - [ ] Fetch latest pricing from TCGPlayer
  - [ ] Get card variants/editions
  - [ ] Retrieve evolution chain data
  - [ ] Get tournament legality status

### UI Implementation
- [ ] **Card Details View**
  - [ ] Card image carousel (if variants exist)
  - [ ] Pricing breakdown chart
  - [ ] Metadata display (HP, attacks, etc.)
  - [ ] Market trend graph
  - [ ] Add to collection button

### Error Handling
- [ ] Network failure fallback to cached data
- [ ] Low confidence match warnings
- [ ] Manual search option

###  **Deliverable**
- Scan card � Display full details
- Accurate pricing information
- Multiple match suggestions when uncertain

---

## Phase 4: User Collection Management
**Timeline**: 3-4 weeks  
**Goal**: Personal collection tracking with portfolio value

### Authentication Setup
- [ ] **Sign in with Apple**
  - [ ] Configure in App Store Connect
  - [ ] Implement AuthenticationServices
  - [ ] Handle user credentials securely
  - [ ] Store user ID in Keychain

### Collection Backend (Azure Functions)
- [ ] **User Collection APIs**
  ```javascript
  // /api/users/{userId}/collection
  GET    - Fetch user's collection
  POST   - Add card to collection
  DELETE - Remove card from collection
  
  // /api/users/{userId}/stats
  GET    - Collection statistics
  ```

### MongoDB User Schema
```javascript
{
  userId: String,  // Apple ID
  collection: [{
    cardId: String,
    quantity: Number,
    condition: String,
    dateAdded: Date,
    customNotes: String,
    purchasePrice: Number
  }],
  preferences: Object,
  createdAt: Date
}
```

### Collection Features
- [ ] **Collection View**
  - [ ] Grid/List toggle
  - [ ] Sort by: Value, Rarity, Set, Date Added
  - [ ] Filter by: Set, Type, Rarity
  - [ ] Search within collection

- [ ] **Portfolio Analytics**
  - [ ] Total collection value
  - [ ] Value change over time
  - [ ] Rarity distribution chart
  - [ ] Set completion progress
  - [ ] Most valuable cards

### Offline Support
- [ ] Core Data for local storage
- [ ] Sync when connection available
- [ ] Conflict resolution strategy

###  **Deliverable**
- User authentication working
- Full collection management
- Portfolio value tracking
- Offline capability

---

## Phase 5: Advanced Features
**Timeline**: 4-5 weeks  
**Goal**: ML-powered quality assessment

### Fraud Detection
- [ ] **ML Model Development**
  - [ ] Collect dataset of real vs fake cards
  - [ ] Train CoreML model
  - [ ] Features: Holographic patterns, font analysis, color accuracy
  - [ ] Confidence threshold: 90%

- [ ] **Implementation**
  - [ ] Run inference on-device
  - [ ] Show authenticity score
  - [ ] Highlight suspicious areas
  - [ ] Educational content on spotting fakes

### Damage Detection
- [ ] **Computer Vision Pipeline**
  - [ ] Edge detection for creases
  - [ ] Color analysis for fading
  - [ ] Corner detection for damage
  - [ ] Surface analysis for scratches

- [ ] **Grading Estimation**
  - [ ] Map damage to PSA/BGS scale
  - [ ] Show visual heatmap overlay
  - [ ] Provide condition report
  - [ ] Impact on value calculation

### Enhanced OCR
- [ ] Support for Japanese cards
- [ ] Promo card identification
- [ ] Error card detection

###  **Deliverable**
- Fraud detection with confidence scores
- Automated damage assessment
- Condition-based pricing

---

## Phase 6: Social & Engagement Features
**Timeline**: 3-4 weeks  
**Goal**: Community features and retention mechanics

### Friends System
- [ ] **Social Features**
  - [ ] Find friends via username
  - [ ] View friends' collections (privacy settings)
  - [ ] Collection comparison
  - [ ] Wishlist sharing

### Notifications (Azure Notification Hubs)
- [ ] **Push Notifications**
  - [ ] Price alerts (card value changes)
  - [ ] New set releases
  - [ ] Collection milestones
  - [ ] Friend activity (optional)

### Gamification
- [ ] Collection achievements
- [ ] Scanning streaks
- [ ] Rarity badges
- [ ] Set completion rewards

### Premium Features (IAP)
- [ ] **Pro Subscription**
  - [ ] Advanced fraud detection
  - [ ] Unlimited high-res scans
  - [ ] Priority API access
  - [ ] Historical price data
  - [ ] Export to CSV/PDF

###  **Deliverable**
- Social layer implemented
- Engagement features active
- Premium tier available

---

## Infrastructure & DevOps

### Azure Resources Required
- **Compute**: Azure Functions (Consumption Plan initially)
- **Storage**: Azure Blob Storage (Hot tier)
- **API Management**: Azure API Management (Developer tier)
- **Monitoring**: Application Insights
- **Notifications**: Azure Notification Hubs

### CI/CD Pipeline
- [ ] GitHub Actions for iOS builds
- [ ] Azure DevOps for Function deployments
- [ ] Automated testing on PR
- [ ] TestFlight distribution

### Monitoring & Analytics
- [ ] Crash reporting (AppCenter/Crashlytics)
- [ ] User analytics (Azure Application Insights)
- [ ] API performance monitoring
- [ ] Cost tracking and optimization

---

## Risk Mitigation

### Technical Risks
- **API Rate Limits**: Implement caching, queue requests
- **OCR Accuracy**: Provide manual input fallback
- **Network Dependency**: Robust offline mode
- **Image Storage Costs**: Implement smart compression

### Business Risks
- **API Changes**: Abstract API layer, version endpoints
- **Copyright Issues**: Only store reference data, not full card art
- **App Store Rejection**: Follow guidelines strictly, especially for IAP

---

## Success Metrics

### Phase 1-2 KPIs
- Card detection accuracy > 95%
- Image processing < 2 seconds
- OCR extraction success > 80%

### Phase 3-4 KPIs
- Card identification accuracy > 90%
- User retention (Day 7) > 40%
- Collection adds per user > 10 cards

### Phase 5-6 KPIs
- Fraud detection accuracy > 85%
- Premium conversion > 5%
- MAU growth > 20% month-over-month

---

## Timeline Summary

| Phase | Duration | Milestone |
|-------|----------|-----------|
| Phase 1 | 2-3 weeks | Core infrastructure ready |
| Phase 2 | 2-3 weeks | Auto-capture working |
| Phase 3 | 3-4 weeks | Full identification system |
| Phase 4 | 3-4 weeks | Collection management |
| Phase 5 | 4-5 weeks | Advanced ML features |
| Phase 6 | 3-4 weeks | Social features |
| **Total** | **17-23 weeks** | **Full app launch** |

---

## Next Steps
1. Set up Azure account and resources
2. Begin Phase 1 iOS development
3. Start MongoDB Atlas configuration
4. Create initial API endpoints
5. Begin collecting card dataset for ML training