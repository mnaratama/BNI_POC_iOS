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
 The RequestDelegate class acts as delegate for all NSURLSessionTasks and also creates a queue
 to handle the serialization of the responses.
 */
public class RequestDelegate: NSObject, URLSessionDataDelegate {
    
// **************************************************
// MARK: - Properties
// **************************************************
    
    public var queue: OperationQueue
    
    var task: URLSessionTask
    var data: NSMutableData
    var error: Error?
    
    var uploadProgressClosure: (_ error: String, _ progressStatus: String) -> Void
    
// **************************************************
// MARK: - Constructors
// **************************************************
    
    /**
     Public initializer.
     
     - parameter task: is the task associated with the request, the same one
     that we will receive updates from NSURLSessionDataDelegate.
     
     - returns: returns a RequestDelegate instance.
     */
    init(task: URLSessionTask) {
        self.task = task
        self.data = NSMutableData()
        self.uploadProgressClosure = {_, _ in }
        
        self.queue = {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            queue.isSuspended = true
            return queue
            }()
    }
    
    init(task: URLSessionTask, uploadProgressClosure : @escaping (_ error: String, _ progressStatus: String) -> Void ) {
        self.task = task
        self.data = NSMutableData()
        self.uploadProgressClosure = uploadProgressClosure
        self.queue = {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            queue.isSuspended = true
            return queue
            }()
    }
    
    deinit {
        self.queue.cancelAllOperations()
        self.queue.isSuspended = true
    }
    
// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************
    
    // public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.error = error
        self.queue.isSuspended = false
        
        CacheManager.instance.save(self.data, taskSession: task)
        
        if error != nil {
            DispatchQueue.main.async {
                self.uploadProgressClosure((error?.localizedDescription)!, "")
            }
            
        }
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    public  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let progressPercent = Int(uploadProgress*100)
        DispatchQueue.main.async {
            self.uploadProgressClosure("", String(format: "%d", progressPercent))
        }
        
    }
    
// **************************************************
// MARK: - Override Public Methods
// **************************************************

}
