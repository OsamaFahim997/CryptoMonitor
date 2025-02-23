//
//  String.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 23/2/25.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
