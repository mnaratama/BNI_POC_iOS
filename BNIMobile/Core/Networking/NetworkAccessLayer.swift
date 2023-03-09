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
import UIKit

class NetworkAccessLayer: NSObject {
    
    //**************************************************
    // MARK: - Creating shared Instance for WebAccessLayer
    //**************************************************
    static let shared: NetworkAccessLayer = {
        let instance = NetworkAccessLayer()
        return instance
    }()
    
    private override init() {}
    
    func parse(response: JSON) -> BaseResponse? {
        let mainDict = response.object as? Dictionary<String, AnyObject>
        if let eMainDict = mainDict {
            if let jsonData = try? JSONSerialization.data(withJSONObject: eMainDict, options: .sortedKeys) {
                do {
                    let basereponse = try JSONDecoder().decode(BaseResponse.self, from: jsonData)
                    return basereponse
                } catch {
                    print(error)
                    return nil
                }
            }
        }
        return nil
    }
    
    func verifyAccount(mobileNumber : String, completionHandler: @escaping (_ isSuccess: Bool,  _ json: JSON, _: NSError?) -> Void){
        Request.verifyAccount(mobileNumber: mobileNumber).execute().responseJSON { (urlRequest, urlResponse, json, error) -> Void in
            if error == nil {
                print("verifyAccount response: \(json)")
                completionHandler(true, json, nil)
            } else {
                completionHandler(false,json, error)
            }
        }
    }
    
    func generateOTP(mobileNumber : String, completionHandler: @escaping (_ isSuccess: Bool,  _ baseResponse: BaseResponse?, _: NSError?) -> Void){
        Request.generateOTP(mobileNumber: mobileNumber).execute().responseJSON { (urlRequest, urlResponse, json, error) -> Void in
            if error == nil {
                if let baseResponse = self.parse(response: json) {
                    completionHandler(true, baseResponse, nil)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
    func validateOTP(otp: String, completionHandler: @escaping (_ isSuccess: Bool,  _ baseResponse: BaseResponse?, _: NSError?) -> Void){
        Request.validateOTP(otp: otp).execute().responseJSON { (urlRequest, urlResponse, json, error) -> Void in
            if error == nil {
                print("validateOTP response: \(json)")
                if let baseResponse = self.parse(response: json) {
                    completionHandler(true, baseResponse, nil)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
    
    func verifyCredentials(userId: String, password: String, completionHandler: @escaping (_ isSuccess: Bool,  _ baseResponse: BaseResponse?, _: NSError?) -> Void) {
        DataSourceManager.baseURLString = "https://productservice-mavipoc-ps.apps.mavipoc-pb.duh8.p1.openshiftapps.com"
        Request.verifyCredentials(userId: userId, password: password).execute().responseJSON { (urlRequest, urlResponse, json, error) -> Void in
            if error == nil {
                print("verifyCredentials response: \(json)")
                if let baseResponse = self.parse(response: json) {
                    completionHandler(true, baseResponse, nil)
                }
            } else {
                completionHandler(false, nil, error)
            }
        }

    }
}
