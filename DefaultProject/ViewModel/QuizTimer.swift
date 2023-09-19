//
//  File.swift
//  DefaultProject
//
//  Created by darktech4 on 19/09/2023.
//

import Foundation

class QuizTimer: ObservableObject {
    static var shared = QuizTimer()
    @Published var elapsedTime: TimeInterval = 0
    
    private var startTime: Date?
    private var endTime: Date?
    private var timer: Timer?
    
    
    init() {
        startTime = nil
        endTime = nil
        timer = nil
    }
    
    // start time
    func start() {
        startTime = Date()
        endTime = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, let startTime = self.startTime else {
                return
            }
            
            let currentTime = Date()
            self.elapsedTime = currentTime.timeIntervalSince(startTime)
        }
    }
    
    // stop time
    func stop() {
        timer?.invalidate()
        timer = nil
        
        if let startTime = startTime {
            endTime = Date()
            let elapsedTime = endTime!.timeIntervalSince(startTime)
        }
    }
    
    func reset() {
        startTime = nil
        endTime = nil
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: timeInterval) ?? "0s"
    }
    
}
