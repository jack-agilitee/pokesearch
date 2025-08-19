# Phase 1: Project Setup Tasks

## Project Structure
- [x] Create folder structure: Views/, ViewModels/, Models/, Services/, Utilities/
- [x] Move ContentView.swift to Views/ folder
- [x] Create AppConstants.swift file for global constants
- [x] Add .gitignore for Swift/Xcode files
- [x] Update CLAUDE.md with new project structure

## Camera Setup
- [x] Add Info.plist camera usage description: "This app needs camera access to scan Pokémon cards"
- [x] Create CameraView.swift in Views/Camera/
- [x] Import AVFoundation in CameraView
- [x] Create basic AVCaptureSession setup
- [x] Add camera preview layer to SwiftUI view using UIViewRepresentable

## Camera Permissions
- [x] Create CameraPermissionManager.swift in Services/Camera/
- [x] Add method to check camera authorization status
- [x] Add method to request camera permission
- [x] Create permission denied alert view
- [x] Add permission check on app launch

## Basic Camera UI
- [x] Create camera preview container view
- [x] Add cancel/close button
- [x] Set up basic navigation from ContentView to CameraView
- [x] Create card-shaped overlay guide (rounded rectangle)
- [x] Add "Position card here" text inside overlay
- [x] Make overlay semi-transparent white/black
- [x] Add simple scanning line animation (moves up/down)
- [x] Create pulsing opacity animation for overlay corners
- [x] Add brief instruction text below overlay ("Align card with frame")
