//
//  TimeInterval.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/11/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation

extension TimeInterval {
    func inMinunes() -> Int {
        return Int(self) / 60
    }
}
