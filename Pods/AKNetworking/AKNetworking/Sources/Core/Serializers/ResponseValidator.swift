/*
 * IBM iOS Accelerators component
 * Licensed Materials - Property of IBM
 * Copyright (C) 2017 IBM Corp. All Rights Reserved
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

// **************************************************************************************************
//
// MARK: - Constants -
//
// **************************************************************************************************

// **************************************************************************************************
//
// MARK: - Definitions -
//
// **************************************************************************************************

// **************************************************************************************************
//
// MARK: - Class -
//
// **************************************************************************************************

/**
 This class is responsible for validating the request response. It uses only a few properties and a public
 method to facilitate the developer's work.
 **/

public class ResponseValidator {

// *************************************************
// MARK: - Properties
// *************************************************
    
    /**
     This property is the statusCode of response that you want to validate.
     **/
    public var statusCode: [Int]?
    
    /**
     This property is the header of the response that you want to validate.
     **/
    public var headers: [String: String]?
    
    /**
     This property is a string that you want to evaluate in the request response.
     **/
    public var string: String?
    
    /**
     This property is a JSON that you want to evaluate in the request response.
     **/
    public var json: JSON?

// *************************************************
// MARK: - Constructors
// *************************************************

    public init(statusCode: [Int]? = nil, headers: [String: String]? = nil, string: String? = nil, json: JSON? = nil) {
        self.statusCode = statusCode
        self.headers = headers
        self.string = string
        self.json = json
    }

// *************************************************
// MARK: - Private Methods
// *************************************************

    private func validateStatusCodes(_ codesObject: [Int], request: Request) {
        request.handler.queue.addOperation {
            if let response = request.response, request.error == nil {
                if !codesObject.contains(response.statusCode) {
                    request.handler.error = NSError(domain: AKNetworkingErrorDomain, code: response.statusCode, userInfo: nil)
                }
                
            }
            
        }
        
    }

    private func validateHeaders(_ headersObject: [String: String], request: Request) {
        request.handler.queue.addOperation {
            if let response = request.response, request.error == nil {
                let responseHeaders = response.allHeaderFields
                let result = headersObject.contains {
                    if let value = responseHeaders[$0.0] as? String {
                        return value == $0.1
                    }

                    return false
                }

                if !result {
                    request.handler.error = NSError(domain: AKNetworkingErrorDomain, code: 415, userInfo: nil)
                }
                
            }
            
        }
        
    }

    private func validateString(_ stringObject: String, request: Request) {
        request.handler.queue.addOperation {
            if let data = request.data, request.error == nil {
                if let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ,
                    !responseString.contains(stringObject) {
                    request.handler.error = NSError(domain: AKNetworkingErrorDomain, code: 420, userInfo: nil)
                }
                
            }
            
        }
        
    }

    private func validateJSON(_ jsonObject: JSON, request: Request) {
        request.handler.queue.addOperation {
            if let data = request.data, request.error == nil {

                let responseJSON = JSON(data: data)

                // First check, strict equal
                if !(responseJSON == jsonObject) {
                    if responseJSON.type != jsonObject.type {
                        request.handler.error = NSError(domain: AKNetworkingErrorDomain, code: 420, userInfo: nil)
                    } else {
                        // Is gonna need a different JSON
                    }
                    
                }
                
            }
            
        }
        
    }

// *************************************************
// MARK: - Self Public Methods
// *************************************************

    /**
     this method to validate the request of the response received as a parameter to an instance of the 
     Request class. It is important to know that you must pass the values for the property of 
     "ResponseValidator" class for the method to validate correctly.
     
     - parameter request: is an instance of the class "Request", it is the request that you want to validate
                          the response.
     
     **/
    public func validate(_ request: Request) {

        // Validating HTTP Status codes
        if let codes = self.statusCode {
            self.validateStatusCodes(codes, request: request)
        }

        // Validating headers
        if let headersObject = self.headers {
            self.validateHeaders(headersObject, request: request)
        }

        // Validating Strings
        if let stringObject = self.string {
            self.validateString(stringObject, request: request)
        }

        // Validating JSON
        if let jsonObject = self.json {
            self.validateJSON(jsonObject, request: request)
        }
        
    }

// *************************************************
// MARK: - Override Public Methods
// *************************************************

}
