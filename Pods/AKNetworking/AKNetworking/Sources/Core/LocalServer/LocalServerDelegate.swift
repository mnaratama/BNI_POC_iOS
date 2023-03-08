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
 Protocol that defines a Delegate for the LocalServer.
 
 This protocol is used to make mock responses for a server request.
 */
public protocol LocalServerDelegate: AnyObject {
    
// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Tells the local server what response he should give to this
     NSURLRequest.
     
     - parameter urlRequest: a Request to be mocked by the LocalServer.
     
     - returns: servers Response.
     */
    func responseForURLRequest(_ urlRequest: URLRequest) -> Response
}
