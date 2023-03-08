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
// MARK: - Extension for Array, Dictionary, String, Sequencing
// **************************************************

extension JSON {
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    internal func castClass<T>(_ clazz: T.Type, withType type: JSONType) -> T? {
        return self.type == type ? self.object as? T : nil
    }
    
}

// **************************************************
// MARK: - Extension for Subscript generatorion
// **************************************************
extension JSON {
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    public subscript(key: String) -> JSON {
        get {
            switch self.type {
            case .dictionary:
                if let newObject: AnyObject = self.object[key]! as AnyObject? {
                    return JSON(newObject)
                } else {
                    return JSON.nullJSON
                }
                
            default: return JSON.nullJSON
            }
            
        }
        
        set {
            if self.type == .dictionary {
                if var dict = self.object as? [String: AnyObject] {
                    dict[key] = newValue.object
                    self.object = dict as AnyObject
                }
                
            }
            
        }
        
    }
    
    public subscript(index: Int) -> JSON {
        get {
            switch self.type {
            case .array:
                if let array = self.object as? [AnyObject] {
                    if index >= 0 && index < array.count {
                        return JSON(array[index])
                    } else {
                        return JSON.nullJSON
                    }
                    
                }
                
            default: return JSON.nullJSON
            }
            
            return JSON.nullJSON
        }
        
        set {
            if self.type == .array {
                if var array = self.object as? [AnyObject] {
                    if index < array.count {
                        array[index] = newValue.object
                        self.object = array as AnyObject
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for enabling sequencing
// **************************************************
extension JSON: Sequence {
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    public func makeIterator() -> AnyIterator<JSON> {
        
        switch self.type {
        case .array:
            if let array = object as? [AnyObject] {
                var generate = array.makeIterator()
                return AnyIterator {
                    if let element: AnyObject = generate.next() {
                        return JSON(element)
                    } else {
                        return nil
                    }
                    
                }
                
            }
            
        default:
            return AnyIterator {
                return nil
            }
            
        }
        
        return AnyIterator {
            return nil
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for adding Optional/Raw JSON
// **************************************************
extension JSON {
    public var optional: JSON? {
        return self.type != .null ? self: nil
    }
    
}

extension JSON {
    public var rawValue: AnyObject {
        return self.object
    }
    
}

extension JSON {
    public var rawData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self.object, options: JSONSerialization.WritingOptions(rawValue: 0))
        } catch _ {
            return nil
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for adding String
// **************************************************
extension JSON {
    public var string: String? {
        return castClass(String.self, withType: .string)
    }
    
    public var stringValue: String {
        switch self.type {
        case .string: return (self.object as? String)!
        case .number: return self.object.stringValue
        default: return ""
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for adding Boolean
// **************************************************
extension JSON {
    public var bool: Bool? {
        return castClass(Bool.self, withType: .number)
    }
    
    public var boolValue: Bool {
        return self.bool ?? false
    }
    
}

// **************************************************
// MARK: - Extension for adding Array
// **************************************************
extension JSON {
    public var array: [JSON]? {
        switch self.type {
        case .array: return (self.object as? [AnyObject])!.map {
            JSON($0)
            }
            
        default: return nil
        }
        
    }
    
    public var arrayValue: [JSON] {
        return self.array ?? []
    }
    
}

// **************************************************
// MARK: - Extension for adding Dictionary
// **************************************************
extension JSON {
    public func map<NewValue>(_ source: [Key: Value], transform: (Value) -> NewValue) -> [Key: NewValue] {
        var result = [Key: NewValue](minimumCapacity: source.count)
        for (key, value) in source {
            result[key] = transform(value)
        }
        
        return result
    }
    
    public var dictionary: [String: JSON]? {
        switch self.type {
        case .dictionary: return self.map((self.object as? [String: AnyObject])!) {
            JSON($0)
            }
            
        default: return nil
        }
        
    }
    
    public var dictionaryValue: [String: JSON] {
        return self.dictionary ?? [:]
    }
    
}

// **************************************************
// MARK: - Extension for adding URL
// **************************************************
extension JSON {
    public var url: URL? {
        switch self.type {
        case .string: return URL(string: self.stringValue)
        default:return nil
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for creating Equatable
// **************************************************
extension JSON: Equatable {
}

public func == (lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs.type, rhs.type) {
    case (.number, .number):
        if let number1 = lhs.object as? NSNumber, let number2 = rhs.object as? NSNumber {
            return number1 == number2
        }
        
    case (.string, .string):
        if let string1 = lhs.object as? String, let string2 = lhs.object as? String {
            return string1 == string2
        }
        
    case (.array, .array):
        if let array1 = lhs.object as? NSArray, let array2 = rhs.object as? NSArray {
            return array1 == array2
        }
        
    case (.dictionary, .dictionary):
        if let dict1 = lhs.object as? NSDictionary, let dict2 = rhs.object as? NSDictionary {
            return dict1 == dict2
        }
        
    case (.null, .null):
        return true
    default:
        return false
    }
    
    return false
}

// **************************************************
// MARK: - Extensions for making it Literal Convertible
// **************************************************
extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
    
}

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: AnyObject...) {
        self.init(elements)
    }
    
}

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, AnyObject)...) {
        var dict = [String: AnyObject]()
        for (key, value) in elements {
            dict[key] = value
        }
        
        self.init(dict)
    }
    
}

// ***********************************************************
// MARK: - Extension for making it Printable
// ***********************************************************
extension JSON: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self.type {
        case .array, .dictionary:
            do {
                let data = try JSONSerialization.data(withJSONObject: self.object, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    return string
                }
                
            } catch {
                return "error"
            }
            
            return "unknown"
        default:
            return "\(self.object)"
        }
        
    }
    
    public var debugDescription: String {
        return self.description
    }
    
}
