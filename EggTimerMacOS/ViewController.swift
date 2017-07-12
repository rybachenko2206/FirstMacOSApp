//
//  ViewController.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/6/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    // MARK: Outlets
    
    @IBOutlet weak var timeLeftTF: NSTextField!
    @IBOutlet weak var eggImageView: NSImageView!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    // MARK: Properties
    var eggTimer = EggTimer()
    var preferences = Preferences()
    

    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        eggTimer.delegate = self as EggTimerProtocol
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(preferencesIsChanged(notification:)),
                                               name: NSNotification.Name(rawValue: kPreferenceIsChanged),
                                               object: nil)
        
        updateDisplay(for: eggTimer.duration)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: Action funcs
    
    func preferencesIsChanged(notification: Notification) {
        eggTimer.duration = preferences.selectedTime
        if eggTimer.isStopped {
            updateDisplay(for: eggTimer.duration)
        } else {
            showAlertResetSettings(alertHander: { [weak self] (shouldReset: Bool) in
                if shouldReset == true {
                    self?.resetTimer()
                    
                }
            })
        }
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if eggTimer.isPaused {
            eggTimer.resumeTimer()
        } else {
            eggTimer.duration = preferences.selectedTime
            eggTimer.startTimer()
        }
        configureButtonsAndMenus()
    }

    @IBAction func stopButtonTapped(_ sender: Any) {
        eggTimer.stopTimer()
        configureButtonsAndMenus()
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        resetTimer()
    }
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        startButtonTapped(sender)
    }
    
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stopButtonTapped(sender)
    }
    
    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
        resetButtonTapped(sender)
    }
    
    
    // MARK: Private funcs
    fileprivate func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftTF.stringValue = textToDisplay(for: timeRemaining)
        eggImageView.image = imageToDisplay(for: timeRemaining)
    }
    
    private func resetTimer() {
        eggTimer.resetTimer()
        updateDisplay(for: eggTimer.duration)
        configureButtonsAndMenus()
    }
    
    private func showAlertResetSettings(alertHander: @escaping (Bool) -> ()) {
        let alert = NSAlert()
        alert.messageText = "Reset timer with the new settings?"
        alert.informativeText = "This will stop your current timer!"
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "Reset")
        alert.addButton(withTitle: "Cancel")
        
        let response = alert.runModal()
        let shouldReset = response == NSAlertFirstButtonReturn ? true : false
        alertHander(shouldReset)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
        let percentageComplete = 100 - (timeRemaining / eggTimer.duration * 100)
        
        if eggTimer.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: stoppedImageName)
        }
        
        let imageName: String
        switch percentageComplete {
        case 0 ..< 25:
            imageName = "0"
        case 25 ..< 50:
            imageName = "25"
        case 50 ..< 75:
            imageName = "50"
        case 75 ..< 100:
            imageName = "75"
        default:
            imageName = "100"
        }
        
        return NSImage(named: imageName)
    }
    
    private func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        
        if eggTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        } else if eggTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared().delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
}


extension ViewController: EggTimerProtocol {
    
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: EggTimer) {
        updateDisplay(for: 0)
        Player().playSound()
    }
}
