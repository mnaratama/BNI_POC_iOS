/*
 * IBM iOS Accelerators component
 * Licensed Materials - Property of IBM
  * Copyright (C) 2017 IBM Corp. All Rights Reserved
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

public class NSCacheBase: NSCache<AnyObject, AnyObject> {

// **************************************************
// MARK: - Properties
// **************************************************

// **************************************************
// MARK: - Constructors
// **************************************************

	override init() {
		super.init()
		
        _ = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { _ in
                                                self.memoryWarning()
        }

	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************
    
    subscript(key: URLRequest) -> AnyObject? {
        get {
            switch key.cachePolicy {
            case NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData:
                return nil
            default:
                return self.object(forKey: key as AnyObject)
            }
            
        }
        
        set {
            if let value = newValue {
                self.setObject(value, forKey: key as AnyObject)
            } else {
                self.removeObject(forKey: key as AnyObject)
            }
            
        }
        
    }
	
    public func memoryWarning() {
		
    }
	
// **************************************************
// MARK: - Override Public Methods
// **************************************************
}
