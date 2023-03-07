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

// **********************************************************************************************************
//
// MARK: - Constants -
//
// **********************************************************************************************************

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

// **********************************************************************************************************
//
// MARK: - Class -
//
// **********************************************************************************************************

extension String {

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Encodes a String with Base64
     
     - returns: A String encoded with Base64
     */
    public func encodeStringToBase64() -> String {
        guard let strData = self.data(using: String.Encoding.utf8) else {
            return ""
        }
        
        return strData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
 
    /**
     Decodes a String from Base64 Encoding
     
     - returns: A String decoded from Base64
     */
    public func decodeStringFromBase64() -> String {
        guard let decodedData = Data(base64Encoded: self,
            options: NSData.Base64DecodingOptions(rawValue: 0)),
            let decodedString = String(data: decodedData, encoding: String.Encoding.utf8) else {
                return ""
        }
        
        return decodedString
    }
    
}
