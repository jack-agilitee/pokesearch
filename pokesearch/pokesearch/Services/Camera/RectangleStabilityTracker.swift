import Foundation
import CoreGraphics

class RectangleStabilityTracker {
    private var observations: [RectangleObservation] = []
    private let maxObservations = 5  // Store last 5 observations
    private let stabilityThreshold: CGFloat = 0.05  // 5% variance threshold
    private let requiredStableFrames = 3  // Need 3 stable frames to confirm stability
    
    var onStabilityChanged: ((Bool) -> Void)?
    
    private(set) var isStable: Bool = false {
        didSet {
            if oldValue != isStable {
                onStabilityChanged?(isStable)
            }
        }
    }
    
    func addObservation(_ observation: RectangleObservation) {
        observations.append(observation)
        
        // Keep only the most recent observations
        if observations.count > maxObservations {
            observations.removeFirst()
        }
        
        updateStability()
    }
    
    func reset() {
        observations.removeAll()
        isStable = false
    }
    
    private func updateStability() {
        guard observations.count >= requiredStableFrames else {
            isStable = false
            return
        }
        
        // Check if recent observations are stable
        let recentObservations = observations.suffix(requiredStableFrames)
        guard let firstObservation = recentObservations.first else {
            isStable = false
            return
        }
        
        // Check if all recent observations are stable relative to the first one
        let allStable = recentObservations.dropFirst().allSatisfy { observation in
            observation.isStable(comparedTo: firstObservation, threshold: stabilityThreshold)
        }
        
        isStable = allStable
    }
    
    var averageConfidence: Float {
        guard !observations.isEmpty else { return 0 }
        let totalConfidence = observations.reduce(0) { $0 + $1.confidence }
        return totalConfidence / Float(observations.count)
    }
    
    var lastObservation: RectangleObservation? {
        observations.last
    }
    
    var hasEnoughObservations: Bool {
        observations.count >= requiredStableFrames
    }
}