//
//  Double.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 27/10/23.
//

import Foundation

extension Double {
    
    func asCurrencyWithNDecimals(min:Int = 2,max:Int = 6) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = min
        formatter.maximumFractionDigits = max
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "$0.00"
    }
    
    func asNumberAsString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberAsString() + "%"
    }
    
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted .asNumberAsString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberAsString()
        default:
            return "\(sign)\(self)"
        }
    }
}
