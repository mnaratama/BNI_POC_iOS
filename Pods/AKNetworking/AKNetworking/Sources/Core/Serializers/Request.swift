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
 Request defines a generic request made to a webserver, it handles the execution
 queue with NSOperation in a serial way.
 */
public class Request: NSObject {

// **************************************************
// MARK: - Properties
// **************************************************

    public typealias Serializer = (URLRequest, HTTPURLResponse?, Data?) -> (AnyObject?, NSError?)

    public let handler: RequestDelegate

    public var task: URLSessionTask {
        return self.handler.task
    }

    public var request: URLRequest? {
        return task.originalRequest
    }
    
    public var response: HTTPURLResponse? {
        return task.response as? HTTPURLResponse
    }
    
    public var data: Data? {
        return handler.data as Data
    }
    
    public var error: Error? {
        return handler.error
    }

    var completionQueue: DispatchQueue = DispatchQueue.main

    var uploadProgressClosure : (_ error: String, _ progressStatus: String) -> Void
    
// **************************************************
// MARK: - Constructors
// **************************************************

    init(task: URLSessionTask) {
        self.handler = RequestDelegate(task: task)
        self.uploadProgressClosure = {_, _ in }
        
        super.init()
    }
    
    init(task: URLSessionTask, uploadProgressClosure: @escaping (_ error: String, _ progressStatus: String) -> Void ) {
        self.uploadProgressClosure = uploadProgressClosure
        self.handler = RequestDelegate(task: task, uploadProgressClosure: self.uploadProgressClosure)
        
        super.init()
        
    }

// **************************************************
// MARK: - Private Methods
// **************************************************

    private func requestIsCached() -> Bool {

        var hasCache: Bool = false

        if let cachedResponse = URLCache.shared.cachedResponse(for: self.request!) {
            print("show cache")
            print("request - \(String(describing: self.request))")
            print("response - \(cachedResponse.response)")
            hasCache = true
        }

        return hasCache
    }

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Default response handler. All other response functions pass through this one.

     Response from the Request is serialized, after that the completionHandler is called
     in the configured queue (default is main).

     This method runs asynchronously, all operations are made in a queue created
     by its delegate.

     - parameter serializer:        Serializer closure that handles serializing the WebServer Response.
     - parameter completionHandler: closure that acts as callback, with the signature: (NSURLRequest?, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void

     - returns: returns the Request object associated with it.
     */
    @discardableResult public func response(_ serializer: @escaping Serializer, completionHandler: @escaping (_: URLRequest?, _: HTTPURLResponse?, _: AnyObject?, _: NSError?) -> Void ) -> Self {
        self.handler.queue.addOperation {
            // serialize the data
            let (responseObject, _): (AnyObject?, NSError?) = serializer(self.request!, self.response, self.data)

            // dispatch to the completion handler on the configured queue (main by default)
            if let response = self.response, let data = self.data {
                if DataSourceManager.sharedInstance.shouldLog {
                    AKRequestLogging.instance.saveResponseLogString(self, response: response, responseData: data)
                }
            }

            self.completionQueue.async {
                completionHandler(self.request, self.response, responseObject, (self.error as NSError?) )
            }
            
        }
        
        return self
    }

    /**
     Method to set a queue responsible to handle the call of the completionBlocks.

     - parameter queue: the queue that will handle the completionBlocks.

     - returns: returns the Request object associated with it.
     */
    public func completionQueue(_ queue: DispatchQueue) -> Self {
        self.completionQueue = queue
        return self
    }

    /**
     Cancel the task associated with this Request.
     */
    public func cancel() {
        self.task.cancel()
    }

    /**
     Suspend the task associated with this Request.
     */
    public func suspend() {
        self.task.suspend()
    }

    /**
     Resume the task associated with this Request.
     */
    public func resume() {
        self.task.resume()
    }

// **************************************************
// MARK: - Override Public Methods
// **************************************************

}

// **************************************************
// MARK: - Extension for serializing NSData
// **************************************************
extension Request {

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Method that creates a Serializer that converts the response to a NSData.

     - returns: a NSData Serializer.
     */
    public class func dataResponseSerializer() -> Serializer {
        return { (_, _, data) in
            return (data as AnyObject, nil)
        }
        
    }

    /**
     Convenience method that converts server Response to NSData.

     - parameter completionHandler: closure that acts as callback, with the signature: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void ) -> Self

     - returns: returns the Request object associated with it.
     */
    @discardableResult public func response(_ completionHandler: @escaping (_: URLRequest?, _: HTTPURLResponse?, _: Data?, _: NSError?) -> Void ) -> Self {
        return self.response(Request.dataResponseSerializer()) {(urlRequest: URLRequest?, urlResponse: HTTPURLResponse?, object: AnyObject?, error: NSError?) -> Void in

            // call the completion handler and cast the unserialized data
            completionHandler(urlRequest, urlResponse, object as? Data, error)
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for serializing String
// **************************************************
extension Request {

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Method that creates a Serializer that converts the response to String.

     - parameter encoding: the desired String encoding, can be implied defaults to NSUTF8StringEncoding.

     - returns: a String Serializer.
     */
    public class func stringResponseSerializer(_ encoding: String.Encoding = String.Encoding.utf8) -> Serializer {
        return { (_, _, data) in
            var responseString: String? 
            if let data = data {
                if let string = NSString(data: data, encoding: encoding.rawValue) as String? {
                    responseString = string
                }
                
            }

            return (responseString as AnyObject, nil)
        }
        
    }

    /**
     Convenience method that converts server Response to String.

     - parameter completionHandler: closure that acts as callback, with the signature: (NSURLRequest?, NSHTTPURLResponse?, String?, NSError?) -> Void ) -> Self

     - returns: returns the Request object associated with it.
     */
    @discardableResult public func responseString(_ completionHandler: @escaping (_ : URLRequest?, _: HTTPURLResponse?, _: String?, _: NSError?) -> Void ) -> Self {
        return self.response(Request.stringResponseSerializer()) {(urlRequest: URLRequest?, urlResponse: HTTPURLResponse?, object: AnyObject?, error: NSError?) -> Void in

            // call the completion handler and cast the unserialized data
            completionHandler( urlRequest, urlResponse, object as? String, error)
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for serializing JSON
// **************************************************
extension Request {

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Method that creates a Serializer that converts the response to JSON.

     - returns: a JSON Serializer.
     */
    public class func jsonResponseSerializer() -> Serializer {
        return { (_, _, data) in
            var responseJSON: JSON
            if let data = data {
                responseJSON = JSON(data: data)
            } else {
                responseJSON = JSON.nullJSON
            }

            return (Box(responseJSON), nil)
        }
        
    }

    /**
     Convenience method that converts server Response to JSON.

     - parameter completionHandler: closure that acts as callback, with the signature: (NSURLRequest?, NSHTTPURLResponse?, JSON?, NSError?) -> Void ) -> Self

     - returns: returns the Request object associated with it.
     */
    @discardableResult public func responseJSON(_ completionHandler: @escaping (_: URLRequest?, _: HTTPURLResponse?, _: JSON, _: NSError?) -> Void ) -> Self {
        return self.response(Request.jsonResponseSerializer()) {(urlRequest: URLRequest?, urlResponse: HTTPURLResponse?, object: AnyObject?, error: NSError?) -> Void in

            // call the completion handler and cast the unserialized data
            completionHandler(urlRequest, urlResponse, (object as? Box)!.value, error)
        }
        
    }
    
}

// **************************************************
// MARK: - Extension for serializing image
// **************************************************
extension Request {

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Method that creates a Serializer that converts the response to an UIImage.

     - returns: an UIImage Serializer.
     */
    public class func imageResponseSerializer() -> Serializer {
        // request, response
        return { _, _, data in
            if data == nil {
                return (nil, nil)
            }
            // let image = UIImage(data: data!, scale: UIScreen.main.scale)
            let image = UIImage(data: data!, scale: UIScreen.main.scale)

            return (image, nil)
        }
    }

    /**
     Convenience method that converts server Response to an UIImage.

     - parameter completionHandler: closure that acts as callback, with the signature: (NSURLRequest?, NSHTTPURLResponse?, UIImage?, NSError?) -> Void ) -> Self

     - returns: returns the Request object associated with it.
     */
    @discardableResult public func responseImage( completionHandler: @escaping (_: URLRequest?, _: HTTPURLResponse?, _: UIImage?, _: NSError?) -> Void ) -> Self {
        return self.response(Request.imageResponseSerializer()) {(urlRequest: URLRequest?, urlResponse: HTTPURLResponse?, object: AnyObject?, error: NSError?) -> Void in

            // call the completion handler and cast the unserialized data
            completionHandler(urlRequest, urlResponse, object as? UIImage, error)
        }
    }
}

// **************************************************
// MARK: - Extension for validating a request
// **************************************************

extension Request {

// **************************************************
// MARK: - Self Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
	Validates the Request response with a set of rules in validator instance.

	- parameter validator: A ResponseValidator instance. By default it'll create a validation
	against HTTP status codes 200, 201, 202

	- returns: the Request object associated with it.
	*/
	public func validate(_ validator: ResponseValidator = ResponseValidator(statusCode: [200, 201, 202, 203, 204, 205, 206])) -> Self {

		// Validating will trigger error on this request if necessary.
		validator.validate(self)

        return self
    }
}
