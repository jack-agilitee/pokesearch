# Phase 3: Error Handling & Fallbacks

## Network Error Handling
- [ ] Create NetworkErrorView.swift
- [ ] Detect no internet connection
- [ ] Show offline mode message
- [ ] Add retry button
- [ ] Cache last successful results

## API Error States
- [ ] Handle 404 (card not found)
- [ ] Handle 429 (rate limited)
- [ ] Handle 500 (server error)
- [ ] Handle timeout errors
- [ ] Parse error messages from API

## Retry Logic
- [ ] Implement exponential backoff
- [ ] Max 3 retry attempts
- [ ] Show retry progress
- [ ] Cancel retry option
- [ ] Log failed attempts

## Fallback Search
- [ ] Create ManualSearchView.swift
- [ ] Add text search input
- [ ] Search by card name
- [ ] Filter by set
- [ ] Browse by category

## Offline Mode
- [ ] Cache recent searches
- [ ] Store viewed card details
- [ ] Queue scans for later upload
- [ ] Show offline indicator
- [ ] Sync when connection restored