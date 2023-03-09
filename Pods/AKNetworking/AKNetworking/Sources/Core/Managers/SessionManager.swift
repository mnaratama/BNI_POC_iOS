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
 SessionManager create tasks and passes them to NSURLSession
 to be executed later, depending on the queue.
 */
public class SessionManager {
    
    // **************************************************
    // MARK: - Properties
    // **************************************************
    
    public var localSession: URLSession?
    private var currentSession: URLSession {
        return self.localMode ? localSession! : session!
    }
    
    private static var instance: SessionManager?
    static var timeoutSessionIntervalForRequest: TimeInterval = 60
    static var timeoutSessionIntervalForResource: TimeInterval =  24*3600*7
    static var maximumFileSizeAllowedForUploading: Int =  2048
    
    public var session: URLSession?
    public var handler: SessionManagerDelegate?
    
    internal var error: NSError? { return handler?.error }
    
    public var localMode = false {
        didSet {
            self.configuration()
        }
        
    }
    
    public var baseURLString: String?
    
    public var headers: [String: String] = [:]
    public var timeoutInterval: TimeInterval?
    public var localResponseDelayInterval: TimeInterval = 0.5
    
    var acceptedSelfSignedServers: [String] = []
    
    var username: String?
    var password: String?
    var cacheControl: RequestCacheControl?
    var responseValidator: ResponseValidator?
    static var sessionConfiguration: SessionConfiguration = .sessionDefault
    static var enableRequestCacche: Bool = true
    static var enableURLCache: Bool = true
    
    var cachePolicy: NSURLRequest.CachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    
    /// Since AKNetworking provides a built-in class `LocalServer` which conforms to LocalServerDelegate, which can be initilised in the local scope in the host application. Making this property weak will immediately deallocates the property.
    /// Therefore it has been left unresolved. 
    public var localServerDelegate: LocalServerDelegate?
    
    var uploadProgressClosure: (_ error: String, _ progressStatus: String) -> Void
    
    public static var sharedInstance: SessionManager {
        
        if SessionManager.instance == nil {
            SessionManager.instance = SessionManager()
        }
        
        return SessionManager.instance!
    }
    
    // **************************************************
    // MARK: - Constructors
    // **************************************************
    
    private init() {
        self.uploadProgressClosure = {_, _ in }
        
        self.configuration()
    }
    
    // **************************************************
    // MARK: - Private Methods
    // **************************************************
    
    private func configuration() {
        var configuration = URLSessionConfiguration.default
        
        if SessionManager.sessionConfiguration == .ephemeral {
            configuration = URLSessionConfiguration.ephemeral
        }
        
        if SessionManager.enableRequestCacche {
            configuration.requestCachePolicy = .useProtocolCachePolicy
        }
        
        if SessionManager.enableURLCache {
            configuration.urlCache = URLCache.shared
        }
        
        configuration.timeoutIntervalForRequest = SessionManager.timeoutSessionIntervalForRequest
        configuration.timeoutIntervalForResource = SessionManager.timeoutSessionIntervalForResource
        
        self.handler = SessionManagerDelegate()
        self.session = URLSession(configuration: configuration, delegate: self.handler, delegateQueue: nil)
        
        if self.localMode {
            configuration.protocolClasses = [StubURLHTTPProtocol.self]
        }
        
        self.localSession = URLSession(configuration: configuration, delegate: self.handler, delegateQueue: nil)
        self.uploadProgressClosure = {_, _ in }
        
    }
    
    // **************************************************
    // MARK: - Internal Methods
    // **************************************************
    
    /**
     Creates a Request from a NSURLRequest.
     
     In order to use this method, it's necessary to manually create an NSURLRequest.
     With every information that's necessary.
     
     This method adds the headers that were set before it's call to the NSURLRequest
     object, modify the timeout if a different one was set.
     
     Also there's some setup if running in LocalServer mode.
     
     After this setup is done, a task with the modified urlRequest is created, a new
     Request object is created with this task and returned.
     
     - parameter urlRequest:          A NSURLRequest with the request details.
     - parameter localServerDelegate: A delegate for the local server.
     
     - returns: a Request object that represents this request.
     */
    func request(_ urlRequest: URLRequest, localServerDelegate: LocalServerDelegate?) -> Request {
        // create a mutable copy
        
        var mutableURLRequest: NSMutableURLRequest?
        
        if let mutableRequest = (urlRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest {
            mutableURLRequest = mutableRequest
        }
        
        if let username = self.username,
            let password = self.password {
            
            var encodedAuth = "\(username):\(password)"
            encodedAuth = encodedAuth.encodeStringToBase64()
            
            self.headers["Authorization"] = "Basic \(encodedAuth)"
        }
        
        // add cache control value if needed.
        if let cacheControl = self.cacheControl {
            self.headers["Cache-Control"] = cacheControl.rawValue
        }
        
        // add headers if needed and don't already exist
        for (key, value) in self.headers {
            if mutableURLRequest?.value(forHTTPHeaderField: key) == nil {
                mutableURLRequest?.setValue(value, forHTTPHeaderField: key)
            }
            
        }
        
        mutableURLRequest?.cachePolicy = self.cachePolicy
        
        // update timeout if needed
        if let timeoutInterval = self.timeoutInterval {
            mutableURLRequest?.timeoutInterval = timeoutInterval
        }
        
        // store the matcher (wrapper)
        if self.localMode {
            StubURLHTTPProtocol.setProperty(Box(localServerDelegate), forKey: "matcher", in: mutableURLRequest!)
            if let HTTPBody = mutableURLRequest?.httpBody {
                StubURLHTTPProtocol.setProperty(HTTPBody, forKey: "HTTPBody", in: mutableURLRequest!)
            }
            
        }
        
        // start the task
        // let task = self.currentSession.dataTask(with: mutableURLRequest) //renato
        let task = self.currentSession.dataTask(with: mutableURLRequest! as URLRequest)
        
        // create the remote request
        let request = Request(task: task)
        
        // store the task
        if let delegate = self.handler {
            delegate[task] = request.handler
        }
        
        // resume it
        task.resume()
        AKRequestLogging.instance.saveRequestLogString(request)
        
        // Building the default validator if it's necessary.
        if let validator = self.responseValidator {
            return request.validate(validator)
        }
        
        return request
    }
    
    func uploadRequest(urlRequest: NSURLRequest) -> Request? {
        // create a mutable copy
        
        var mutableURLRequest: NSMutableURLRequest?
        
        if let mutableRequest = urlRequest.mutableCopy() as? NSMutableURLRequest {
            mutableURLRequest = mutableRequest
        }
        
        if let username = self.username,
            let password = self.password {
            
            var encodedAuth = "\(username):\(password)"
            encodedAuth = encodedAuth.encodeStringToBase64()
            
            self.headers["Authorization"] = "Basic \(encodedAuth)"
        }
        
        // add headers if needed and don't already exist
        for (key, value) in self.headers where mutableURLRequest?.value(forHTTPHeaderField: key) == nil {
            mutableURLRequest?.setValue(value, forHTTPHeaderField: key)
        }
        
        // start the task
        let task = self.currentSession.dataTask(with: mutableURLRequest! as URLRequest)
        
        // create the remote request
        let request = Request(task: task, uploadProgressClosure: uploadProgressClosure)
        
        // store the task
        self.handler?[task] = request.handler
        
        // resume task
        task.resume()
        
        if AKRequestLogging.instance.shouldLogRequestsToConsole || AKRequestLogging.instance.shouldLogRequestsToFile {
            
            AKRequestLogging.instance.saveRequestLogString(request)
        }
        
        return request
    }
    
    /**
     Creates a Request from a NSURLRequest.
     
     In order to use this method, it's necessary to manually create an NSURLRequest.
     With every information that's necessary.
     
     - parameter urlRequest: A NSURLRequest with the request details.
     
     - returns: a Request object that represents this request.
     */
    func request(_ urlRequest: URLRequest) -> Request {
        return request(urlRequest, localServerDelegate: self.localServerDelegate)
    }
    
    /**
     This method creates a Request using the parameters suplied.
     
     - parameter method:     The Method that should be used to make this request.
     - parameter urlString:  The url that you want to send the request.
     - parameter parameters: Parameters for the request. This parameter is optional and defaults to nil.
     - parameter encoding:   Encoding that should be used on this request. This parameter is optional and defaults to JSON.
     - parameter headers:    HTTP Headers for the request. This parameter is optional and defaults to nil.
     
     - returns: a Request object that represents this request
     */
    func request(_ method: Method, _ urlString: String, parameters: [String: AnyObject]? = nil,
                 encoding: ParameterEncoding = .json, headers: [String: String]? = nil) -> Request {
        
        func relativeURLString(_ string: String) -> String {
            var components = (string as NSString).pathComponents
            if components.first == "/" { components.remove(at: 0) }
            
            return components.joined(separator: "/")
        }
        
        var URL = Foundation.URL(string: urlString)
        if URL?.host == nil, let baseURLString = self.baseURLString {
            URL = Foundation.URL(string: relativeURLString(urlString), relativeTo: Foundation.URL(string: baseURLString)!)!
        }
        
        let urlRequest = NSMutableURLRequest(url: URL!)
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
            
        }
        
        return request(encoding.encodeRequest(urlRequest as URLRequest, parameters: parameters))
    }
    
    func destroy() {
        SessionManager.instance = nil
    }
    
    // **************************************************
    // MARK: - Self Public Methods
    // **************************************************
    
    // **************************************************
    // MARK: - Override Public Methods
    // **************************************************
    
}
