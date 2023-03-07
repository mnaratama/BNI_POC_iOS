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

private var key: UInt8 = 0

/**
UIImageView extension that adds image caching with DataSourceManager.
 
NSCache is used to handle image cache.
*/
extension UIImageView {
    
// **************************************************
// MARK: - Properties
// **************************************************

    private var dataCache: DataCache {
        return DataCache.instance
    }
    
    var request: AKNetworking.Request? {
        get {
            return objc_getAssociatedObject(self, &key) as? AKNetworking.Request
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
    }
    
// **************************************************
// MARK: - Constructors
// **************************************************

// **************************************************
// MARK: - Private Methods
// **************************************************

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
    Convenience method for setImageWithURL removing the necessity to pass a placeholder.
    
    - parameter url: URL , the image is located.
    */
    public func setImageWithURL(_ url: URL) {
        self.setImageWithURL(url, placeholderImage: nil)
    }
    
    /**
    Convenience method for setImageWithURLRequest that constructs a NSURLRequest
    using the provided NSURL.
    
    - parameter url:              NSURL to a remote location , the image is located.
    - parameter placeholderImage: placeholder image to be shown while the image is loaded.
    */
    public func setImageWithURL(_ url: URL, placeholderImage: UIImage?) {
        let request = NSMutableURLRequest(url: url)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        
        self.setImageWithURLRequest(request as URLRequest, placeholderImage: placeholderImage, success: nil, failure: nil)
    }

    /**
     Method that sets an image to UIImageView from cache or remote URL.
     
     This method first tries to load the requested image from cache, if the image is not cached,
     it's loaded from the provided URL. After the image is loaded, it's cached and set to the
     UIImageView that requested it.
     
     - parameter urlRequest:       A NSURLRequest that representes the image to be loaded.
     - parameter placeholderImage: An placeholder image to be shown while the image is downloaded.
     - parameter success:          Success closure with the format (NSURLRequest?, NSHTTPURLResponse?, UIImage?) -> Void
     - parameter failure:          Failure closure with the format (NSURLRequest?, NSHTTPURLResponse?, NSError) -> Void
    */
    public func setImageWithURLRequest(_ urlRequest: URLRequest, placeholderImage: UIImage?, success: ((_: URLRequest?, _: HTTPURLResponse?, _: UIImage?) -> Void)?, failure: ((_: URLRequest?, _: HTTPURLResponse?, _: NSError) -> Void)?) {

        // cancel any pending requests
        self.cancelImageRequest()
        
        if let cachedImage = self.dataCache[urlRequest] as? UIImage {
            if let success = success {
                success(nil, nil, cachedImage)
            } else {
                self.image = cachedImage
            }
            
            // cleanup the request
            self.request = nil
        } else {
            if let placeholderImage = placeholderImage {
                self.image = placeholderImage
            }
            
            self.request = DataSourceManager.request(urlRequest).validate().responseImage { [weak self] (_, response, image, error) -> Void in
                
                if let strongSelf = self {
                    if let error = error {
                        
                        // make sure the imageview has not been reused
                        if urlRequest.url! == strongSelf.request?.request?.url {
                            
                            if let failure = failure {
                                failure(urlRequest, response, error)
                            } 

                            // cleanup the request
                            strongSelf.request = nil
                        }

                    } else {
                        // make sure the imageview has not been reused
                        if urlRequest.url! == strongSelf.request?.request?.url {
                            
                            if let success = success {
                                success(urlRequest, response, image)
                            } else {
                                strongSelf.image = image
                            }
                            
                            // cleanup the request
                            strongSelf.request = nil

                            // cache the image
                            strongSelf.dataCache[urlRequest] = image
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    /**
    Method that provides a way to cancel the image download.
     */
    public func cancelImageRequest() {
        self.request?.cancel()
        self.request = nil
    }
    
// **************************************************
// MARK: - Override Public Methods
// **************************************************
    
}

extension UIImageView {
	
	/**
	This method exposes the cached image for a specific URL. It can be useful to use with your
	own image routines or when creating an image gallery for example.
	
	- parameter url:              NSURL to a remote location , the image is located.
	- returns: Returns a possible cached image.
	*/
	public class func cachedImage(with url: URL) -> UIImage? {
		let request = NSMutableURLRequest(url: url)
		request.addValue("image/*", forHTTPHeaderField: "Accept")
		
		return DataCache.instance[request as URLRequest] as? UIImage
	}
    
}
