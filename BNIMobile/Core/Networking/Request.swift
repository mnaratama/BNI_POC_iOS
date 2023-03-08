//
//  Request.swift
//  BNIMobile
/*
 * Licensed Materials - Property of IBM
 * Copyright (C) 2023 IBM Corp. All Rights Reserved.
 *
 * IMPORTANT: This IBM software is supplied to you by IBM
 * Corp. (""IBM"") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import Foundation
import AKNetworking

enum Request {
    
    case getMetadata(uuid: String)
    
    func execute() -> AKNetworking.Request {
        let request: AKNetworking.Request
        
        switch self {
            
        case .getMetadata(_):
            request = DataSourceManager.request(.GET, "/api/v1/generateotp", parameters: nil, encoding: .json, headers: self.headers)
        }
            // log the response
            request.responseString { (urlRequest, urlResponse, string, error) -> Void in
                // use this closure to log the response
                
#if DEBUG
                if let url = urlRequest?.url {
                    print(url.absoluteURL)
                }
#endif
                if let urlResponse = urlResponse {
                    print(urlResponse)
                }
            }
            
            return request
            
        }
    
    var headers: [String: String] {
        let headers: [String: String] = [:]
        // add required header attributes here
//        headers["Authorization"] = "Bearer xxx"
        return headers
    }
}


