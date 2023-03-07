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
import UIKit
import MobileCoreServices

// **********************************************************************************************************
//
// MARK: - Extension -
//
// **********************************************************************************************************

/**
 Extension for adding logic to cert validation
 */
extension DataSourceManager {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    /**
     This var holds a list with the hosts that can connect with a broken
     ssl certificate
     */
    public class var acceptedSelfSignedServers: [String] {
       
        get {
            return SessionManager.sharedInstance.acceptedSelfSignedServers
        } set {
            SessionManager.sharedInstance.acceptedSelfSignedServers = newValue
        }
    }
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    /**
     Appends a host to a whitelist of servers that can connect even if the
     https certificate fails to be validated
     
     - parameter host: the host that needs to be whitelisted, without the protocol, for instance:
     httpbin.org
     */
    public class func appendValidSelfSignedServer(_ host: String) {
        self.acceptedSelfSignedServers.append(host)
    }
    
    /**
     Checks if the host is on the whitelisted lists, if it is, then the connection
     would be made
     
     - parameter host: the host to check if it is whitelisted, without the protocol, for instance:
     httpbin.org
     
     - returns: a boolean with true if the server is contained in the list and false otherwise
     */
    public class func isSelfSignedServerValid(_ host: String) -> Bool {
        return self.acceptedSelfSignedServers.contains(host)
    }
    
}

// **********************************************************************************************************
//
// MARK: - Extension -
//
// **********************************************************************************************************

/**
 Extension for adding Basic HTTP Authentication
 */
extension DataSourceManager {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    /**
     property for setting an username for basic http authentication
     defaults to nil and should have no value if you don't want
     this feature
     */
    public class var username: String? {
        
        get {
            return SessionManager.sharedInstance.username
        } set {
            SessionManager.sharedInstance.username = newValue
        }
    }
    
    /**
     property for setting a password for basic http authentication
     defaults to nil and should have no value if you don't want
     this feature
     */
    public class var password: String? {
        get {
            return SessionManager.sharedInstance.password
        } set {
            SessionManager.sharedInstance.password = newValue
        }
    }
    
}
