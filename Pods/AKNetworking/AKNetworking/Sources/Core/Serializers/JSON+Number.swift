/*
 * IBM iOS Accelerators component
 * Licensed Materials - Property of IBM
 * Copyright (C) 2017 IBM Corp. All Rights Reserved.
 * 6949 - XXX
 *
 * IMPORTANT:  This IBM software is supplied to you by IBM
 * Corp. ("IBM") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit

// **************************************************
// MARK: - Extension for adding Number
// **************************************************
extension JSON {
    public var number: NSNumber? {
        return castClass(NSNumber.self, withType: .number)
    }
    
    public var numberValue: NSNumber {
        return self.number ?? NSNumber(value: 0.0)
    }
    
    public var int: Int? {
        return self.number?.intValue
    }
    
    public var intValue: Int {
        return self.numberValue.intValue
    }
    
    public var float: Float? {
        return self.number?.floatValue
    }
    
    public var floatValue: Float {
        return self.numberValue.floatValue
    }
    
    public var double: Double? {
        return self.number?.doubleValue
    }
    
    public var doubleValue: Double {
        return self.numberValue.doubleValue
    }
    
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
    
}

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(NSNull.self)
    }
    
}
