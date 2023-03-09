//
//  Extension+View.swift
//  BNIMobile
//
//  Created by Naratama on 09/03/23.
//

import Foundation

extension Double {
    var nonTrailingZero: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    var asPriceFormat: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        let price = numberFormatter.string(from: NSNumber(value: self))
        if let price = price {
            return price
        }
        return ""
    }
    
    static func df2so(_ price: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: price as NSNumber)!
    }
}

extension Int {
    var asPriceFormat: String {
        guard self > 0 else { return "Gratis" }
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        let price = numberFormatter.string(from: NSNumber(value: self))
        if let price = price {
            return price
        }
        return ""
    }
    
    var asPriceFormatOnlyNumber: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        let price = numberFormatter.string(from: NSNumber(value: self))
        if let price = price {
            return price
        }
        return ""
    }
    
    func secondsToTime() -> String {
        
        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        
        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"
        
        return "\(h_string):\(m_string):\(s_string)"
    }
    
    func durationToTime() -> String {
        
        let (h,m) = (self / 3600, (self % 3600) / 60)
        
        if h > 0 {
            return "\(h).\(m) jam"
        } else {
            return "\(m) menit"
        }
    }
    
    var asCountDownFormat: String{
        let str = String(self)
        return str.count > 1 ? str : "0\(str)"
    }
}
