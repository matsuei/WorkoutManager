//
//  UIApplication+Extension.swift
//  WorkoutManager
//
//  Created by 松栄健太 on 2021/08/14.
//
import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
