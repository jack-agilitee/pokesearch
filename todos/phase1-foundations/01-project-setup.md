# Phase 1: Project Setup Tasks

## Project Structure
- [ ] Create folder structure: Views/, ViewModels/, Models/, Services/, Utilities/
- [ ] Move ContentView.swift to Views/ folder
- [ ] Create AppConstants.swift file for global constants
- [ ] Add .gitignore for Swift/Xcode files
- [ ] Update CLAUDE.md with new project structure

## Camera Setup
- [ ] Add Info.plist camera usage description: "This app needs camera access to scan Pokémon cards"
- [ ] Create CameraView.swift in Views/Camera/
- [ ] Import AVFoundation in CameraView
- [ ] Create basic AVCaptureSession setup
- [ ] Add camera preview layer to SwiftUI view using UIViewRepresentable

## Camera Permissions
- [ ] Create CameraPermissionManager.swift in Services/Camera/
- [ ] Add method to check camera authorization status
- [ ] Add method to request camera permission
- [ ] Create permission denied alert view
- [ ] Add permission check on app launch

## Basic Camera UI
- [ ] Create camera preview container view
- [ ] Add cancel/close button
- [ ] Set up basic navigation from ContentView to CameraView
- [ ] Create card-shaped overlay guide (rounded rectangle)
- [ ] Add "Position card here" text inside overlay
- [ ] Make overlay semi-transparent white/black
- [ ] Add simple scanning line animation (moves up/down)
- [ ] Create pulsing opacity animation for overlay corners
- [ ] Add brief instruction text below overlay ("Align card with frame")
