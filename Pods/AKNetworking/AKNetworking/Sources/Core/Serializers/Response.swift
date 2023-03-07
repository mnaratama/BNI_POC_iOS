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

/**
 Response class is a representation of a server response.
 */
public class Response {
    
// **************************************************
// MARK: - Properties
// **************************************************

    var delay: Double?
    
    var statusCode: Int = 200
    var body: Data?
    var headers = [String: String]()
    
// **************************************************
// MARK: - Constructors
// **************************************************

    public init() {}
    
    /**
     Initializes the Response object with a NSData and assigns it to its body property.
     
     - parameter data: NSData to initialize the object with.
     
     - returns: Response instance.
     */
    public init(data: Data) {
        self.body = data
    }
    
    /**
     Initializes the Response object with a JSON and assigns JSON's rawData to its body property.
     Also adds to the headers property the Content-Type application/json.
     
     - parameter json: JSON to initialize the object with.
     
     - returns: Response instance.
     */
    public init(json: JSON) {
        self.body = json.rawData
        self.headers["Content-Type"] = "application/json"
    }
    
    /**
     Initializes the Response object with a String and assigns String's data to its body property.
     
     - parameter string: String to initialize the object with.
     
     - returns: Response instance.
     */
    public init(string: String) {
        self.body = string.data(using: String.Encoding.utf8)
    }
    
    /**
     Initializes the Response object with the contents of a File and assigns it to its body property.
     
     - parameter filename: name of the file to be loaded.
     - parameter type:     type of the file to be loaded.
     - parameter bundle:   the bundle , the file is located, defaults to Main Bundle.
     */
    public init(filename: String, ofType type: String, bundle: Bundle = Bundle.main) {
        if let filePath = bundle.path(forResource: filename, ofType: type) {
            self.body = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        }
        
    }
    
// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Set the delay of the Response with the one passed.
     
     - parameter delay.
     
     - returns: the Response object associated with the call.
     */
    public func withDelay(_ delay: Double) -> Self {
        self.delay = delay
        return self
    }
    
    /**
     Set the status code of the Response with the one passed.
     
     - parameter statusCode: a status.
     
     - returns: the Response object associated with the call.
     */
    public func withStatusCode(_ statusCode: Int) -> Self {
        self.statusCode = statusCode
        return self
    }
    
    /**
     Adds the headers contained in the dictionary to its header array
     
     - parameter headers: dictionary with headers to be added.
     
     - returns: the Response object associated with the call.
     */
    public func withHeaders(_ headers: [String: String]) -> Self {
        for (key, value) in headers { self.headers[key] = value }
        
        return self
    }
    
// **************************************************
// MARK: - Override Public Methods
// **************************************************
    
}
