//
//  UIApplication.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
