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

/**
Cache control

- Public:			Public
- Private:			Private
- NoCache:			No Cache
- NoStore:			No Store
- MaxAgeNonExpired:	Max Age Non Expired(31536000), one year, best practice max date
- MaxAgeExpired:	Max Age Expired(0)
*/
public enum RequestCacheControl: String {
    case cachePublic = "public"
    case cachePrivate = "private"
    case noCache = "no-cache"
    case noStore = "no-store"
    case maxAgeNonExpired = "max-age=31536000"
    case maxAgeExpired = "max-age=0"
}

// **********************************************************************************************************
//
// MARK: - Class -
//
// **********************************************************************************************************

public class CacheManager: NSObject {

// **************************************************
// MARK: - Properties
// **************************************************

    /**
    Singleton instance of CacheManager.
    */
    public static let instance: CacheManager = CacheManager()

    /**
    Capacity measured in bytes, for the cache. Default value is 512Mb
    */
    public var memoryCapacity: Int = 512 * 1024 * 1024

// **************************************************
// MARK: - Constructors
// **************************************************

// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Internal Methods
// **************************************************

    internal func save(_ data: NSMutableData, taskSession: URLSessionTask) {
		
		let totalBytes: Int = data.length
		
		if let response = taskSession.response, let request = taskSession.originalRequest {
			
			let cachedResponse: CachedURLResponse = CachedURLResponse(response: response, data: data as Data)
			
			if totalBytes > self.memoryCapacity {
				URLCache.shared.storeCachedResponse(cachedResponse, for: request)
			} else {
				DataCache.instance[request] = cachedResponse
			}
            
		}
        
    }

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
    Clear all cached responses.
    */
    public func clearCache() {
        URLCache.shared.removeAllCachedResponses()
    }

// **************************************************
// MARK: - Override Public Methods
// **************************************************

}
