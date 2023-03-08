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

class StubURLHTTPProtocol: URLProtocol {

// **************************************************
// MARK: - Properties
// **************************************************
    
    var stopped: Bool = false
    
// **************************************************
// MARK: - Constructors
// **************************************************

// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************

// **************************************************
// MARK: - Override Public Methods
// **************************************************
    
    override class func canInit(with request: URLRequest) -> Bool {
        if let scheme = request.url?.scheme {
            return ["http", "https"].firstIndex(of: scheme) != nil
        } else {
            return false
        }
        
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ request1: URLRequest, to request2: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        // copy the original request and reassign the HTTPBody since NSURLSession loses it as the request is transformed internally.
        if let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            mutableRequest.httpBody = StubURLHTTPProtocol.property(forKey: "HTTPBody", in: request) as? Data
            
            // grab the wrapper
            let wrapper = StubURLHTTPProtocol.property(forKey: "matcher", in: request) as? Box<LocalServerDelegate?>
            if let stubResponse = wrapper?.value?.responseForURLRequest(mutableRequest as URLRequest) {
                delay(stubResponse.delay ?? DataSourceManager.localResponseDelayInterval) {
                    if !self.stopped {
                        let response = HTTPURLResponse(url: self.request.url!, statusCode: stubResponse.statusCode, httpVersion: "HTTP/1.1", headerFields: stubResponse.headers)!
                        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                        if let body = stubResponse.body {
                            self.client?.urlProtocol(self, didLoad: body)
                        }
                        
                        self.client?.urlProtocolDidFinishLoading(self)
                    }
                    
                }
                
            } else {
                let error = NSError(domain: AKNetworkingErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Missing local response.", comment: "")])
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            
        }
        
    }
    
    override func stopLoading() {
        self.stopped = true
    }
    
}
