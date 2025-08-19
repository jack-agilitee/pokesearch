# Backend: Azure Functions API Development

## Project Setup
- [ ] Initialize Node.js project
- [ ] Install Azure Functions Core Tools
- [ ] Set up TypeScript configuration
- [ ] Install dependencies (mongodb, axios, etc.)
- [ ] Configure local.settings.json

## Card Search Function
- [ ] Create function: SearchCards
- [ ] Implement text search endpoint
- [ ] Add pagination support
- [ ] Include filtering options
- [ ] Return sorted results

## Card Identification Function
- [ ] Create function: IdentifyCard
- [ ] Accept base64 image input
- [ ] Generate image embedding
- [ ] Perform vector similarity search
- [ ] Return top matches with confidence

## Card Details Function
- [ ] Create function: GetCardDetails
- [ ] Fetch by card ID
- [ ] Include pricing data
- [ ] Add related cards
- [ ] Cache responses

## User Collection Functions
- [ ] Create function: GetUserCollection
- [ ] Create function: AddToCollection
- [ ] Create function: RemoveFromCollection
- [ ] Create function: UpdateCollectionItem
- [ ] Implement collection statistics

## Image Upload Function
- [ ] Create function: UploadCardImage
- [ ] Validate image format/size
- [ ] Upload to Blob Storage
- [ ] Generate thumbnails
- [ ] Return CDN URLs