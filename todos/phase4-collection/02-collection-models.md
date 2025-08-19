# Phase 4: Collection Data Models

## Collection Models
- [ ] Create CollectionItem.swift:
  ```swift
  struct CollectionItem {
      let id: UUID
      let cardId: String
      let quantity: Int
      let condition: CardCondition
      let dateAdded: Date
      let notes: String?
      let purchasePrice: Double?
  }
  ```

- [ ] Create CardCondition enum:
  ```swift
  enum CardCondition: String {
      case mint, nearMint, lightlyPlayed
      case moderatelyPlayed, heavilyPlayed, damaged
  }
  ```

## Collection Statistics
- [ ] Create CollectionStats.swift:
  ```swift
  struct CollectionStats {
      let totalCards: Int
      let uniqueCards: Int
      let totalValue: Double
      let rarityBreakdown: [String: Int]
  }
  ```

## Local Storage Setup
- [ ] Create CoreDataManager.swift
- [ ] Define Collection entity in Core Data
- [ ] Add migration support
- [ ] Create fetch requests
- [ ] Handle save/delete operations

## Collection Service
- [ ] Create CollectionService.swift
- [ ] Method to add card to collection
- [ ] Method to remove card
- [ ] Method to update quantity
- [ ] Method to fetch user's collection
- [ ] Calculate collection value