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

import Foundation

// **********************************************************************************************************
//
// MARK: - Constants -
//
// **********************************************************************************************************

internal let cachedDateFormatterKey = "CachedDateFormatterKey"
internal let isoLocale = Locale(identifier: "en_US_POSIX")
internal let isoFormats = ["yyyy-MM-dd'T'HH:mm:ssZZZZZ", "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"]

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

/**
 JSONType enumerates the possible value types contained in a JSONObject
 */
public enum JSONType: Int {
    case string, number, array, dictionary, unknown, null
}

// **********************************************************************************************************
//
// MARK: - Struct -
//
// **********************************************************************************************************

/**
 This struct works as a mime for a JSON sent from the webserver.
 
 There are convenience methods for working with local files and
 to parse the NSData received from a webserver call.
 */
public struct JSON {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    private var _type: JSONType = .null
    private var _object: AnyObject = NSNull()
    
    public var type: JSONType {
        return self._type
    }
    
    public var object: AnyObject {
        get {
            return self._object
        }
        
        set {
            _object = newValue
            switch newValue {
            case _ as String: self._type = .string
            case _ as NSNumber: self._type = .number
            case _ as [String: AnyObject]: self._type = .dictionary
            case _ as [AnyObject]: self._type = .array
            case _ as NSNull: self._type = .null
            default:
                self._object = NSNull()
                self._type = .unknown
            }
            
        }
        
    }
    
    public static var nullJSON: JSON {
        return JSON(NSNull())
    }
    
    public var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self.object, options: .prettyPrinted)
    }
    
    // **************************************************
    // MARK: - Constructors
    // **************************************************
    
    /**
     Creates a JSON struct from a Object, if the suplied object is invalid, an empty json is returned.
     
     - parameter object: object to initialize a JSON from.
     
     - returns: a JSON struct.
     */
    public init(_ object: Any) {
        
        if let floatVal = object as? FloatLiteralType {
            let floatObject = NSNumber(value: floatVal)
            self.object = floatObject as AnyObject
            return
        }
        
        if let integerVal = object as? IntegerLiteralType {
            let intergerObject = NSNumber(value: integerVal)
            self.object = intergerObject as AnyObject
            return
        }
        
        if let booleanVal = object as? BooleanLiteralType {
            let booleanObject = NSNumber(value: booleanVal)
            self.object = booleanObject as AnyObject
            return
        }
        
        self.object = object as AnyObject
    }
    
    /**
     Creates a a JSON struct from an array of jsons.
     
     - parameter jsonArray: array of jsons.
     
     - returns: a JSON struct.
     */
    public init(_ jsonArray: [JSON]) {
        self.object = jsonArray.map {
            $0.object
            } as AnyObject
    }
    
    /**
     Creates a JSON struct from NSData, if the suplied NSData is invalid, an empty json is returned.
     
     - parameter data: NSData to initialize a JSON from.
     
     - returns: a JSON struct.
     */
    public init(data: Data) {
        do {
            let object: AnyObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
            self.init(object)
        } catch _ {
            self.init(NSNull())
        }
        
    }
    
    /**
     Creates a JSON struct from a file, returns an empty json if the file is invalid.
     
     - parameter filename: name of the json file.
     - parameter ext:      file extension of the json file.
     - parameter bundle:   a bundle where the file is located, defaults to MainBundle.
     
     - returns: a JSON struct.
     */
    public init(filename: String, ofType ext: String? = "json", inDirectory directory: String? = nil, bundle: Bundle = Bundle.main) {
        if let filePath = bundle.path(forResource: filename, ofType: ext, inDirectory: directory), let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            self.init(data: data)
        } else {
            self.init(NSNull())
        }
        
    }
    
}
