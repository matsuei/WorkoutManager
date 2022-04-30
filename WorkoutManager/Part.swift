//
//  Part.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/05/10.
//
import Foundation

enum Part: String, CaseIterable, Identifiable {
    case chest
    case back
    case shoulder
    case biceps
    case triceps
    case abs
    case leg
    
    var id: String {
        rawValue
    }
    
    var section: Int {
        switch self {
        case .chest:
            return 0
        case .back:
            return 1
        case .shoulder:
            return 2
        case .biceps:
            return 3
        case .triceps:
            return 4
        case .abs:
            return 5
        case .leg:
            return 6
        }
    }
    
    var text: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}
