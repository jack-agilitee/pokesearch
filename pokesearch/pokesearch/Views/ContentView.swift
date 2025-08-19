//
//  ContentView.swift
//  pokesearch
//
//  Created by Jack Nichols on 8/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showCamera = false
    @StateObject private var permissionManager = CameraPermissionManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 80))
                    .foregroundStyle(.tint)
                
                Text("PokeSearch")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Scan Pokémon cards to identify and value them")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    Task {
                        if permissionManager.isNotDetermined {
                            _ = await permissionManager.requestCameraPermission()
                        }
                        if permissionManager.hasPermission {
                            showCamera = true
                        } else if permissionManager.isDenied {
                            permissionManager.showPermissionAlert = true
                        }
                    }
                }) {
                    Label(AppConstants.UI.scanButtonTitle, systemImage: "camera.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: 200)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView()
            }
            .alert(isPresented: $permissionManager.showPermissionAlert) {
                permissionManager.permissionDeniedAlert
            }
            .onAppear {
                permissionManager.checkCameraAuthorizationStatus()
            }
        }
    }
}

#Preview {
    ContentView()
}
