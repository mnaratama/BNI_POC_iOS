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
import Foundation

// **************************************************
// MARK: - Send Log To Server Extension
// **************************************************
extension AKRequestLogging {
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    /**
     Method that sends the log file contents as an binary data in the body to the
     url of your choice
     
     - parameter method: The method that should be used to send the data, defaults to .POST
     - parameter url: The address that the log file should be sent to
     - parameter parameterName: The name of the parameter that the server will receive as the
     binary of the log file
     - parameter headers: Adittional headers that you may want to pass to your webserver, defaults
     to nil
     
     - returns: A Request object that represents this operation
     */
    public func sendLogToWebserverInBody(_ method: Method = .POST, url: String, parameterName: String, headers: [String: String]? = nil) -> Request {
        
        let logData = self.getLogAsNSData()
        let parameters = [parameterName: logData]
        
        let encoding = ParameterEncoding.custom { (urlRequest, _) -> URLRequest in
            let mutableURLRequest = (urlRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest
            
            mutableURLRequest?.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
            mutableURLRequest?.httpBody = logData
            
            return mutableURLRequest! as URLRequest
        }
        
        return DataSourceManager.request(method, url, parameters: parameters as [String: AnyObject]?,
                                         encoding: encoding, headers: headers)
    }
    
}
