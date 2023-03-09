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

extension SessionManager {

    /**
     Create Multipart Upload Request.
     Performs file size check.
     If file size > user defined maximum file size, return nil
     If file size == 0,  return nil
     Else creates a multipart file upload request and return.
     
     - parameter urlString:  The url that you want to send the request.
     - parameter parameters: Parameters for the request. This parameter is optional and defaults to nil.
     - parameter encoding:   Encoding that should be used on this request. This parameter is optional and defaults to JSON.
     - parameter headers:    HTTP Headers for the request. This parameter is optional and defaults to nil.
     - parameter encodingFlag: Flag to say FIle to be encoded or not
     - returns: a Request object that represents this request.
     */
    
    func multipartUploadRequest(urlString: String, parameters: [String: AnyObject]?, headers: [String: String]? = nil, encodingFlag: Bool? = nil, closure: @escaping (_ error: String, _ progressStatus: String) -> Void ) -> Request? {
        
        self.uploadProgressClosure = closure
        
        if let multipartContents = parameters![MultipartConstants.Content] as? NSDictionary {
            if let data = multipartContents[MultipartConstants.FileData] as? NSData {
                var fileSize = data.length
                
                if fileSize > 1024 {
                    fileSize = Int(data.length)/1024
                }
                
                if fileSize > SessionManager.maximumFileSizeAllowedForUploading {
                    self.uploadProgressClosure("File size is larger than \(SessionManager.maximumFileSizeAllowedForUploading)", "")
                    return nil
                } else if fileSize == 0 {
                    self.uploadProgressClosure("File contains nil data", "")
                    return nil
                }
                
            }
            
        }
        
        func relativeURLString(string: String) -> String {
            var components = (string as NSString).pathComponents
            if components.first == "/" { components.remove(at: 0) }
            
            return components.joined(separator: "/")
        }
        
        var URL = NSURL(string: urlString)
        if URL?.host == nil, let baseURLString = self.baseURLString {
            URL = NSURL(string: relativeURLString(string: urlString), relativeTo: NSURL(string: baseURLString) as URL?)!
        }
        
        let urlRequest = NSMutableURLRequest(url: URL! as URL)
        urlRequest.httpMethod = Method.POST.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
            
        }
        
        let encoding = ParameterEncoding.multipart
        
        return uploadRequest(urlRequest: encoding.encodeRequest(urlRequest as URLRequest, parameters: parameters, encodingFlag: encodingFlag) as NSURLRequest)
    }
    
}
