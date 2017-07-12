//
//  EggTimer.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/11/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation


protocol EggTimerProtocol {
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    func timerHasFinished(_ timer: EggTimer)
}


class EggTimer {
    
    // MARK: Properties
    var timer: Timer? = nil
    var startTime: Date?
    var duration: TimeInterval {
        get {
            let prefs = Preferences()
            return prefs.selectedTime
        } set {
            var prefs = Preferences()
            prefs.selectedTime = duration
        }
    }
    var elapsedTime: TimeInterval = 0
    var delegate: EggTimerProtocol?

    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    dynamic func timerAction() {
        guard let startTime = startTime else { return }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinished(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }

    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        timerAction()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        timerAction()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        var prefs = Preferences()
        duration = prefs.selectedTime
        elapsedTime = 0
        
        timerAction()
    }
    
    
}
