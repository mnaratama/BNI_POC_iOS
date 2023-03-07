//
//  NetworkAccessLayer.swift
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

class WebAccessLayer: NSObject {
    
    //**************************************************
    // MARK: - Creating shared Instance for WebAccessLayer
    //**************************************************
    static let shared: WebAccessLayer = {
        let instance = WebAccessLayer()
        return instance
    }()
    
    private override init() {}
    
    func getMetadata( uuid : String, completionHandler: @escaping (_ isSuccess: Bool,  _ json: JSON, _: NSError?) -> Void){
        Request.getMetadata(uuid: uuid).execute().responseJSON { (urlRequest, urlResponse, json, error) -> Void in
            if error == nil {
                print("getMetadata response: \(json)")
                completionHandler(true, json, nil)
            } else {
                completionHandler(false,json, error)
            }
        }
    }
}
