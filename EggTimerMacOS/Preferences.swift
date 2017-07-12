//
//  Preferences.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/11/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation

let kSelectedTime = "SelectedTime"
let kPlaySound = "PlaySound"

struct Preferences {
    var selectedTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.value(forKey: kSelectedTime) as? Double
            if savedTime == nil || savedTime == 0 {
                return BoilDuration.softBoiled.rawValue
            }
            return savedTime!
        } set {
            UserDefaults.standard.set(newValue, forKey: kSelectedTime)
        }
    }
    
    var playSoundEndTime: Bool {
        get {
            let shouldPlay = UserDefaults.standard.value(forKey: kPlaySound) as? Bool
            if shouldPlay == nil {
                return true
            }
            return shouldPlay!
        } set {
            UserDefaults.standard.set(newValue, forKey: kPlaySound)
        }
    }
    
}
