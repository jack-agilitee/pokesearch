# Phase 2: OCR Text Extraction

## Vision OCR Setup
- [ ] Create OCRService.swift in Services/OCR/
- [ ] Import Vision framework
- [ ] Create VNRecognizeTextRequest
- [ ] Set recognition level to .accurate
- [ ] Set up text recognition languages (English)

## Text Extraction Pipeline
- [ ] Create method to process cropped card image
- [ ] Define regions of interest (title, set info, number)
- [ ] Run OCR on full image first
- [ ] Extract text observations with confidence scores
- [ ] Sort text by vertical position

## Card Title Extraction
- [ ] Identify top 20% of card as title region
- [ ] Extract text from title region
- [ ] Filter out small text (attacks, HP)
- [ ] Combine multi-line titles
- [ ] Clean special characters

## Set Information Extraction
- [ ] Identify bottom 10% as set info region
- [ ] Look for pattern: number/total (e.g., "025/165")
- [ ] Extract set symbol text if present
- [ ] Extract rarity symbol position
- [ ] Parse card number

## OCR Post-Processing
- [ ] Create OCRResult struct with all extracted data
- [ ] Calculate overall confidence score
- [ ] Flag low-confidence extractions
- [ ] Store bounding boxes for each text element
- [ ] Create fallback for failed extractions