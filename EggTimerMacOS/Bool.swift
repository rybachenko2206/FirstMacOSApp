//
//  Bool.swift
//  EggTimerMacOS
//
//  Created by Roman Rybachenko on 7/12/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation


extension Bool {
    init<T : Integer>(_ integer: T){
        self.init(integer != 0)
    }
}
