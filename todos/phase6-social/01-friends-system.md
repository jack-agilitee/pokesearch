# Phase 6: Friends System

## Friend Models
- [ ] Create Friend.swift model:
  ```swift
  struct Friend {
      let id: String
      let username: String
      let displayName: String
      let collectionCount: Int
      let joinedDate: Date
  }
  ```

## Friends Service
- [ ] Create FriendsService.swift
- [ ] Search users by username
- [ ] Send friend request
- [ ] Accept/decline requests
- [ ] Remove friend

## Friends List View
- [ ] Create FriendsListView.swift
- [ ] Display friends list
- [ ] Show collection counts
- [ ] Add search functionality
- [ ] Pull to refresh

## Friend Requests
- [ ] Create FriendRequestsView.swift
- [ ] Show pending requests
- [ ] Accept/decline buttons
- [ ] Request notifications badge
- [ ] Block user option

## Username Setup
- [ ] Create UsernameSetupView.swift
- [ ] Validate username availability
- [ ] Show username requirements
- [ ] Handle username changes
- [ ] Display in profile