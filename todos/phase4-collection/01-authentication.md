# Phase 4: Authentication Setup

## Sign in with Apple
- [ ] Add Sign In with Apple capability in Xcode
- [ ] Create AuthenticationService.swift
- [ ] Import AuthenticationServices framework
- [ ] Create ASAuthorizationController setup
- [ ] Handle authorization delegate methods

## Auth UI Components
- [ ] Create SignInView.swift
- [ ] Add Apple Sign In button (ASAuthorizationAppleIDButton)
- [ ] Style button to match app theme
- [ ] Add "Continue as Guest" option
- [ ] Create welcome message

## User Model
- [ ] Create User.swift model:
  ```swift
  struct User {
      let id: String  // Apple ID
      let email: String?
      let name: String?
      let createdAt: Date
  }
  ```

- [ ] Store user in UserDefaults/Keychain
- [ ] Create isAuthenticated computed property
- [ ] Add logout functionality
- [ ] Handle auth state changes

## Keychain Storage
- [ ] Create KeychainService.swift
- [ ] Store user credentials securely
- [ ] Store API tokens
- [ ] Add biometric lock option
- [ ] Handle keychain errors

## Auth Flow
- [ ] Check auth status on app launch
- [ ] Show sign in if not authenticated
- [ ] Navigate to main app after sign in
- [ ] Handle sign in cancellation
- [ ] Persist auth across app launches