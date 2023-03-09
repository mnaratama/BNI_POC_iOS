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
import UniformTypeIdentifiers

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

/**
 Session Configuration
 */
public enum SessionConfiguration: String {
    case `default`
    case ephemeral
}

/**
 HTTP method definitions.
 
 - GET:     HTTP GET
 - POST:    HTTP POST
 - DELETE:  HTTP DELETE
 - HEAD:    HTTP HEAD
 - PUT:     HTTP PUT
 - PATCH:   HTTP PATCH
 - TRACE:   HTTP TRACE
 - CONNECT: HTTP CONNECT
 - OPTIONS: HTTP OPTIONS
 */
public enum Method: String {
    case GET
    case POST
    case DELETE
    case HEAD
    case PUT
    case PATCH
    case TRACE
    case CONNECT
    case OPTIONS
}

/**
 Multipart constants string.
 
 - Content:     MultipartContent
 - FileName:    FileName
 - FileData:    FileData
 - JSONData:    JSONData
 */
public struct MultipartConstants {
    public static var Content = "MultipartContent"
    public static var FileName = "FileName"
    public static var FileData = "FileData"
    public static var JSONData = "JSONData"
}

/**
 Enum that describes the Encoding method that DataSourceManager should use in
 its requests.
 
 - URL:                  Encodes parameters using percent-encoding.
 - JSON:                 Encodes the suplied parameters to JSON.
 - Custom->NSURLRequest: Custom encoding to be defined.
 */
public enum ParameterEncoding {
    case url
    case json
    case custom((URLRequest, [String: AnyObject]?) -> URLRequest)
    case multipart
    /**
     Add and encodes the parameters passed to NSURLRequest.
     
     If no parameters are suplied, this func returns the same request
     received, otherwise all parameters are encoded using the rule suplied,
     then they are added to a copy of the request.
     
     - parameter urlRequest: Request that needs to be encoded.
     - parameter parameters: The parameters that.
     - parameter encodingFlag: Flag to say FIle to be encoded or not
     - returns: the modified NSURLRequest with the suplied parameters.
     */
    public func encodeRequest(_ urlRequest: URLRequest, parameters: [String: AnyObject]?, encodingFlag: Bool? = nil) -> URLRequest {
        if parameters == nil {
            return urlRequest
        }
        
        if let mutableURLRequest = (urlRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            var _: NSError? = nil
            
            switch self {
            case .url:
                func escape(_ string: String) -> String {
                    return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                }
                
                func queryStringFromParameters(_ parameters: [String: AnyObject]) -> String {
                    var parts: [String] = []
                    for (name, value) in parameters {
                        let queryParam = escape("\(name)")
                        let queryValue = escape("\(value)")
                        parts.append("\(queryParam)=\(queryValue)")
                    }
                    
                    return parts.joined(separator: "&")
                }
                
                if let URLComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false) {
                    
                    var URLLocalComponents = URLComponents
                    
                    URLLocalComponents.percentEncodedQuery = (URLLocalComponents.percentEncodedQuery != nil ? URLLocalComponents.percentEncodedQuery! + "&" : "") + queryStringFromParameters(parameters!)
                    mutableURLRequest.url = URLLocalComponents.url
                }
                
            case .json:
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters!, options: JSONSerialization.WritingOptions())
                    mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    mutableURLRequest.httpBody = data
                } catch {
                    print("JSONSerialization failed")
                }
                
            case .custom(let closure):
                return closure(urlRequest, parameters)
                
            case .multipart:
                return encodeMultipartRequest(mutableURLRequest, parameters, encodingFlag)
                
            }
            
            return mutableURLRequest as URLRequest
        }
        
        return URLRequest(url: URL(string: "")!)
    }
    
    private func encodeMultipartRequest(_ urlRequest: NSMutableURLRequest, _ parameters: [String: AnyObject]?, _ encodingFlag: Bool? = nil) -> URLRequest {
        let boundary = "----ABCD"
        let bodyData: NSMutableData = NSMutableData()
        
        let content: String = "multipart/form-data; boundary=\("--ABCD")"
        urlRequest.setValue(content, forHTTPHeaderField: "Content-Type")
        
        // append boundary
        bodyData.append("\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        if let multipartContents = parameters![MultipartConstants.Content] as? NSDictionary {
            
            if let json = multipartContents[MultipartConstants.JSONData] {
                bodyData.append("Content-Disposition: form-data; name=\"json\"".data(using: String.Encoding.utf8)!)
                bodyData.append("\n".data(using: String.Encoding.utf8)!)
                bodyData.append("Content-Type: application/json\r\n".data(using: String.Encoding.utf8)!)
                bodyData.append("\n".data(using: String.Encoding.utf8)!)
                do {
                    let parameterData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
                        bodyData.append(parameterData.base64EncodedData(options: .lineLength64Characters))
                } catch {
                    
                }
                
                bodyData.append("\n\n".data(using: String.Encoding.utf8)!)
                // append boundary
                bodyData.append("\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            }
            
            if let fileData = multipartContents[MultipartConstants.FileData] as? NSData {
                if let fileName = multipartContents[MultipartConstants.FileName] as? String {
                    bodyData.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(fileName)\"\n".data(using: String.Encoding.utf8)!)
                    
                    let objects = fileName.components(separatedBy: ".")
                    let mimeType = getMIMEType(fileExtension: objects[1])
                    bodyData.append("Content-Type: \(mimeType!)\r\n".data(using: String.Encoding.utf8)!)
                    bodyData.append("\n".data(using: String.Encoding.utf8)!)
                    if encodingFlag == nil || encodingFlag == true {
                         bodyData.append((fileData.base64EncodedData(options: .lineLength64Characters)))
                    } else {
                        bodyData.append(fileData as Data)
                    }
                    bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
                    bodyData.append("\("----ABCD--")\r\n".data(using: String.Encoding.utf8)!)
                }
                
            }
            
            // body
            urlRequest.setValue("\(bodyData.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = bodyData as Data
        }
        
        return urlRequest as URLRequest
    }
    
    private func getMIMEType(fileExtension: String) -> String? {
        if !fileExtension.isEmpty {
            if #available(iOS 15.0, *) {
                // let utiRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)
                let utiRef = UTType(tag: fileExtension, tagClass: UTTagClass.filenameExtension, conformingTo: nil)
                if let mimeType = utiRef?.preferredMIMEType {
                    return mimeType as String
                }
            } else {
                let utiRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension as CFString, nil)
                let UTI = utiRef!.takeUnretainedValue()
                utiRef!.release()
                
                let mimeTypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType)
                if mimeTypeRef != nil {
                    let mimeType = mimeTypeRef!.takeUnretainedValue()
                    mimeTypeRef!.release()
                    return mimeType as String
                }
            }
        }
        return "application/octet-stream"
    }
    
}
