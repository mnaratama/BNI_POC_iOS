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
This class acts as delegate for all NSURLSessionTasks and also handles calling
the delegate methods for each task that was created.
*/
final public class SessionManagerDelegate: NSObject, URLSessionDataDelegate {
	
    // private let requestsQueue = DispatchQueue(label: "queue", attributes: DispatchQueueAttributes.concurrent)
    private let requestsQueue = DispatchQueue(label: "queue", attributes: DispatchQueue.Attributes.concurrent)
    
    var requests: [Int: RequestDelegate] = [:]
    var error: NSError?
    
    subscript(task: URLSessionTask) -> RequestDelegate? {
        get {
            var result: RequestDelegate?
            requestsQueue.sync {
                result = self.requests[task.taskIdentifier]
            }
            
            return result
        }
        
        set {
            requestsQueue.sync(flags: .barrier, execute: {
                self.requests[task.taskIdentifier] = newValue
            })
        }
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let delegate = self[task] {
            delegate.urlSession(session, task: task, didCompleteWithError: error)
        }
        
        self[task] = nil
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let delegate = self[dataTask] {
            delegate.urlSession(session, dataTask: dataTask, didReceive: data)
        }
        
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        if let delegate = self[task] {
            delegate.urlSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
        }
        
    }
           
// **************************************************
// MARK: - Override Public Methods
// **************************************************

}

// **************************************************
// MARK: - Extension for handling self signed certs
// **************************************************

extension SessionManagerDelegate {

	typealias AuthResult = (disposition: Foundation.URLSession.AuthChallengeDisposition, credential: URLCredential?)

// **************************************************
// MARK: - Private Methods
// **************************************************

    private func trustIsValid(_ trust: SecTrust) -> Bool {
        var isValid = false
        
        var result = SecTrustResultType.invalid
        if #available(iOS 13, *) {
            let status = SecTrustEvaluateWithError(trust, nil)
            if status {
                let unspecified = SecTrustResultType.unspecified
                let proceed = SecTrustResultType.proceed
                isValid = result == unspecified || result == proceed
            }
            return isValid
        } else {
            let status = SecTrustEvaluate(trust, &result)
            if status == errSecSuccess {
                let unspecified = SecTrustResultType.unspecified
                let proceed = SecTrustResultType.proceed
                isValid = result == unspecified || result == proceed
            }
            return isValid
        }
    }

	private func handleLocalCertificates(_ challenge: URLAuthenticationChallenge) {

		let servicePoliceManager =  DataSourceManager.sharedInstance.serverPolicyManager

		if let serverTrust = challenge.protectionSpace.serverTrust,
			let certificatesArray = servicePoliceManager?.certificates {

			var serverTrustIsValid = false

			if certificatesArray.count > 1 {
				let policy = SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?))
				SecTrustSetPolicies(serverTrust, [policy] as CFTypeRef)

				SecTrustSetAnchorCertificates(serverTrust, certificatesArray as CFArray)
				SecTrustSetAnchorCertificatesOnly(serverTrust, true)

				serverTrustIsValid = trustIsValid(serverTrust)
			} else {

				let serverCertificatesDataArray = servicePoliceManager?.certificateDataForTrust(serverTrust)
				let pinnedCertificatesDataArray = servicePoliceManager?.allCertificateDataForCertificates(certificatesArray)

				outerLoop: for serverCertificateData in serverCertificatesDataArray! {
					for pinnedCertificateData in pinnedCertificatesDataArray! 
						where serverCertificateData == pinnedCertificateData {
							serverTrustIsValid = true
							break outerLoop
						}
					
				}
			}

			if !serverTrustIsValid {
				self.error = NSError(domain: AKNetworkingErrorDomain, code: 0, userInfo:
					[NSLocalizedDescriptionKey: NSLocalizedString("local certificate was not found",
						comment: "You dont have a valid local certificate in ServerPolicyManager, please add a certificate.")])
			}
		}
	}

	private func handleLocalKeys(_ challenge: URLAuthenticationChallenge) {

        let servicePoliceManager =  DataSourceManager.sharedInstance.serverPolicyManager
        
        if let serverTrust = challenge.protectionSpace.serverTrust,
            let pinnedPublicKeys = servicePoliceManager?.keys {
            
            let policies = NSMutableArray()
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString?)))
            SecTrustSetPolicies(serverTrust, [policies] as CFTypeRef)
            
            var certificateChainEvaluationPassed = true
            var hasKey = false
            
            certificateChainEvaluationPassed = servicePoliceManager?.trustIsValid(serverTrust) ?? false
            
            if certificateChainEvaluationPassed {
                outerLoop: for serverPublicKey in (servicePoliceManager?.keysForTrust(serverTrust))! {
                    if (pinnedPublicKeys as NSArray).contains(serverPublicKey) {
                        hasKey = true
                        break outerLoop
                    }
                    
                }
                
                if !hasKey {
                    self.error = NSError(domain: AKNetworkingErrorDomain, code: 0,
                                         userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Public key was not found.",
                                                                                                 comment: "You do not have any public key in ServerPolicyManager, please add a pubic key.")])
                }
                
            }
        }

	}

	private func handleAuthenticationChallenge(_ challenge: URLAuthenticationChallenge) -> AuthResult {
		var disposition = Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
		var credential: URLCredential?

		if DataSourceManager.isSelfSignedServerValid(challenge.protectionSpace.host) {
			if let serverTrust = challenge.protectionSpace.serverTrust {
				credential = URLCredential(trust: serverTrust)
				disposition = Foundation.URLSession.AuthChallengeDisposition.useCredential
			}
		}

		// *************************
		// MARK: - Client Certificates
		// *************************

		self.handleLocalCertificates(challenge)

		// *************************
		// MARK: - Client Keys
		// *************************

		self.handleLocalKeys(challenge)

		return (disposition: disposition, credential: credential)
	}

// **************************************************
// MARK: - Internal Methods
// **************************************************
    
    func handleChallenge(challenge: URLAuthenticationChallenge,
                         completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var authDisposition: URLSession.AuthChallengeDisposition = .useCredential
        var authCredential: URLCredential?
        
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            break
        case NSURLAuthenticationMethodClientCertificate:
            let result = self.handleAuthenticationChallenge(challenge)
            
            authDisposition = result.disposition
            authCredential = result.credential
            
        default:
            break
        }
        
        completionHandler(authDisposition, authCredential)
    }
	
	public func urlSession(_ session: URLSession,
	                       didReceive challenge: URLAuthenticationChallenge,
	                       completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		self.handleChallenge(challenge: challenge, completionHandler: completionHandler)
	}
	
	public func urlSession(_ session: URLSession,
	                       task: URLSessionTask,
	                       didReceive challenge: URLAuthenticationChallenge,
	                       completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		self.handleChallenge(challenge: challenge, completionHandler: completionHandler)
	}

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: (CachedURLResponse) -> Void) {
        var cached: CachedURLResponse?
        if let request = dataTask.currentRequest {
            switch request.cachePolicy {
            case .reloadIgnoringLocalCacheData:
                cached = nil
                
            default:
                if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
                    cached = cachedResponse
                } else {
                    cached = proposedResponse
                }
                
            }
            
        }

        completionHandler(cached!)
    }
    
}
