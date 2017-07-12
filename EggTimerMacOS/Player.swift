//
//  Player.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/12/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation
import AVFoundation

class Player {
    var soundPlayer: AVAudioPlayer?
    
    init() {
        prepareSound()
    }
    
    private func prepareSound() {
        guard let audioFileUrl = Bundle.main.url(forResource: "ding",  withExtension: "mp3") else {
                                                    return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            soundPlayer?.prepareToPlay()
        } catch {
            pl("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
}
