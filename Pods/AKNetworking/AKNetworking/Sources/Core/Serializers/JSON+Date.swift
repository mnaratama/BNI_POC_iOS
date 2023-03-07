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
// MARK: - Extension for adding Date
// **************************************************

extension JSON {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    private var dateFormatter: DateFormatter {
        // grab the thread dictionary
        let threadDictionary = Thread.current.threadDictionary
        if let formatter = threadDictionary[cachedDateFormatterKey] as? DateFormatter {
            // return the cached formatter
            return formatter
        } else {
            // create a new formatter and cache it
            let formatter = DateFormatter()
            threadDictionary[cachedDateFormatterKey] = formatter
            return formatter
        }
        
    }
    
    public var date: Date? {
        switch self.type {
        case .string:
            let dateFormatter = self.dateFormatter
            dateFormatter.locale = isoLocale
            for format in isoFormats {
                dateFormatter.dateFormat = format
                if let string = dateFormatter.date(from: self.stringValue) {
                    return string
                }
                
            }
            
            return nil
        default: return nil
        }
        
    }
    
    public var dateValue: Date {
        return self.date ?? Date()
    }
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    /**
     Generates a date using the passed format and timezone.
     
     - parameter format:   a String containing a date format such as: yyyy-MM-dd
     - parameter timezone: a NSTimeZone.
     
     - returns: a NSDate object if the JSON can be converted, nil otherwise.
     */
    public func dateFromFormat(_ format: String, timezone: TimeZone = TimeZone(identifier: "timezone")!) -> Date? {
        switch self.type {
        case .string:
            let dateFormatter = self.dateFormatter
            dateFormatter.locale = isoLocale
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = timezone
            return dateFormatter.date(from: self.stringValue)
        default: return nil
        }
        
    }
    
    /**
     Generates a date using the passed format and timezone.
     
     - parameter format:   a String containing a date format such as: yyyy-MM-dd
     - parameter timezone: a NSTimeZone.
     
     - returns: a NSDate object with the value contained in JSON, todays NSDate otherwise.
     */
    public func dateValueFromFormat(_ format: String, timezone: TimeZone = TimeZone(identifier: "")!) -> Date {
        return self.dateFromFormat(format, timezone: timezone) ?? Date()
    }
    
    /**
     Generates a date with GMT Timezone using the passed format.
     
     - parameter format: a String containing a date format such as: yyyy-MM-dd
     
     - returns: a NSDate object if the JSON can be converted, nil otherwise.
     */
    public func dateNormalizedToGMTFromFormat(_ format: String) -> Date? {
        switch self.type {
        case .string:
            let string = self.stringValue
            let length = string.count
            let formatLength = format.replacingOccurrences(of: "'", with: "", options: [], range: nil).count
            if length >= formatLength {
                let endIndex = string.index(string.startIndex, offsetBy: formatLength)
                
                let gmtDateString = string[..<endIndex]

                return JSON(gmtDateString).dateValueFromFormat(format, timezone: TimeZone(secondsFromGMT: 0)!)
            }
            
            return nil
        default: return nil
        }
        
    }
    
    /**
     Generates a date with GMT Timezone using the passed format.
     
     - parameter format: a String containing a date format such as: yyyy-MM-dd
     
     - returns: a NSDate object with the value contained in JSON, todays NSDate otherwise.
     */
    public func dateValueNormalizedToGMTFromFormat(_ format: String) -> Date {
        return self.dateNormalizedToGMTFromFormat(format) ?? Date()
    }
    
    public var dateNormalizedToGMT: Date? {
        return self.dateNormalizedToGMTFromFormat("yyyy-MM-dd'T'HH:mm:ss")
    }
    
    public var dateValueNormalizedToGMT: Date {
        return self.dateNormalizedToGMT ?? Date()
    }
    
    // **************************************************
    // MARK: - Override Public Methods
    // **************************************************
}
