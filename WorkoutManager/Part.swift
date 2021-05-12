//
//  Part.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/05/10.
//
import Foundation

enum Part: String, CaseIterable {
    case chest
    case back
    case shoulder
    case biceps
    case triceps
    case abs
    case leg
    
    var text: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}
