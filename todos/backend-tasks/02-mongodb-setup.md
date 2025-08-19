# Backend: MongoDB Atlas Configuration

## Atlas Cluster Setup
- [ ] Create MongoDB Atlas account
- [ ] Provision M10+ cluster (for vector search)
- [ ] Configure network access (Azure IPs)
- [ ] Create database user
- [ ] Get connection string

## Database Schema
- [ ] Create 'pokesearch' database
- [ ] Create 'cards' collection
- [ ] Define card document schema
- [ ] Create 'users' collection
- [ ] Create 'collections' collection

## Indexes Configuration
- [ ] Create text index on card title
- [ ] Create compound index on set + number
- [ ] Create index on rarity
- [ ] Set up TTL index for cache
- [ ] Create unique index on card ID

## Vector Search Setup
- [ ] Enable Atlas Vector Search
- [ ] Create vector index on embeddings field
- [ ] Configure dimensions (1536 for OpenAI)
- [ ] Set similarity metric (cosine)
- [ ] Test vector search queries

## Data Migration
- [ ] Create import scripts
- [ ] Import initial card dataset
- [ ] Validate data integrity
- [ ] Set up backup schedule
- [ ] Configure monitoring alerts