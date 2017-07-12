//
//  PreferencesVc.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/11/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

let kPreferenceIsChanged = "preferencesIsChanged"

import Cocoa

class PreferencesVc: NSViewController {
    
    // MARK: Outlets
    @IBOutlet weak var popupButton: NSPopUpButton!
    @IBOutlet weak var timingSlider: NSSlider!
    @IBOutlet weak var timingLabel: NSTextField!
    @IBOutlet weak var playSoundCheckbox: NSButton!
    
    // MARK: Properties
    var preferences = Preferences()
    
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showExistingPrefs()
    }
    
    // MARK: Action funcs
    
    @IBAction func boilDurationValueChanged(_ sender: NSPopUpButton) {
        guard let selectedItem = sender.selectedItem else { return }
        let durationInMins = selectedItem.tag
        timingSlider.isEnabled = sender.selectedItem?.tag == 0
        
        if BoilDuration(rawValue: TimeInterval(durationInMins * 60)) != nil {
            timingSlider.integerValue = durationInMins
            showSliderValueAsText()
        }
    }
    
    @IBAction func timingSliderValueChanged(_ sender: NSSlider) {
        if BoilDuration(rawValue: TimeInterval(sender.integerValue * 60)) != nil {
            let tag = sender.integerValue
            popupButton.selectItem(withTag: tag)
            timingSlider.isEnabled = false
        }
        showSliderValueAsText()
    }
    
    @IBAction func okButtonTapped(_ sender: NSButton) {
        preferences.selectedTime = TimeInterval(timingSlider.integerValue * 60)
        preferences.playSoundEndTime = Bool(playSoundCheckbox.state)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPreferenceIsChanged),
                                        object: nil)
        view.window?.close()
    }
    
    @IBAction func cancelButtonTapped(_ sender: NSButton) {
        view.window?.close()
    }
    
    @IBAction func playSoundCheckboxTapped(_ sender: NSButton) {
        
    }
    
    // MARK: Private funcs
    private func showExistingPrefs() {
        if let bDur = BoilDuration(rawValue: preferences.selectedTime) {
            popupButton.selectItem(withTag: bDur.rawValue.inMinunes())
        } else {
            popupButton.selectItem(withTag: 0)
        }
        timingSlider.integerValue = preferences.selectedTime.inMinunes()
        timingSlider.isEnabled = popupButton.selectedItem?.tag == 0
        showSliderValueAsText()
        
        playSoundCheckbox.state = preferences.playSoundEndTime == true ? 1 : 0
    }
    
    private func showSliderValueAsText() {
        let newTimerDuration = timingSlider.integerValue
        let minutesDescription = (newTimerDuration == 1) ? "minute" : "minutes"
        timingLabel.stringValue = "\(newTimerDuration) \(minutesDescription)"
    }
    
}
