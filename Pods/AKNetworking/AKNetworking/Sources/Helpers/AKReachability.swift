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
import SystemConfiguration

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
Identifier for the notifications triggered from AKReachability

The Notification info will contain a dictionary with the key AKReachabilityStatusChanged
that will contain a description of the current connection status
*/
public let AKReachabilityDidChangeNotification = "com.ibm.akreachability.change"

/**
Closure type definition for AKReachability status updates
*/
public typealias AKReachabilityClosure = (_ reachable: Bool, _ status: AKReachabilityStatus) -> Void

/**
Enum with the possible status of the internet connection monitored by
AKReachability
*/
public enum AKReachabilityStatus {
    case notReachable
    case reachableViaWWan
    case reachableViaWifi
    
    public var description: String {
        switch self {
        case .reachableViaWWan:
                return "ReachableViaWWan"
        case .reachableViaWifi:
                return "ReachableViaWifi"
        case .notReachable:
                return "NotReachable"
        }
        
    }
    
}

// **********************************************************************************************************
//
// MARK: - Class -
//
// **********************************************************************************************************
/**
Class for monitoring if an internet connection is present
*/
public class AKReachability {

// **************************************************
// MARK: - Properties
// **************************************************

    // *********************************************
    // MARK: Private
    // *********************************************
    
    private var _isReachable: Bool = false
    private var _reachabilityStatus: AKReachabilityStatus = .notReachable
    private var scNetworkReachability: SCNetworkReachability?
    
    // *********************************************
    // MARK: Public
    // *********************************************
    
    /**
     Var for acessing the AKReachability singleton
     the default host for monitoring reachability is "ibm.com"
     */
    public static let instance = AKReachability()
    
    /**
     This var holds a closure for receiving reachability changes
     */
    public var reachabilityClosure: AKReachabilityClosure?
    
    /**
     Var for verifying if the internet is reachable
     */
    public var isReachable: Bool {
        return self._isReachable
    }
    
    /**
     Var with information about the current internet
     connection
     */
    public var reachabilityStatus: AKReachabilityStatus {
        return self._reachabilityStatus
    }
    
// **************************************************
// MARK: - Constructors
// **************************************************

    private init() {
        let defaultHost = "ibm.com"
        guard let addressReachability = AKReachability.createReachabilityWithHost(defaultHost) else {
            return
        }
    
        self.scNetworkReachability = addressReachability
    }
    
// **************************************************
// MARK: - Private Methods
// **************************************************
    private static func createReachabilityWithAddress(_ address: sockaddr_in) -> SCNetworkReachability? {
        var addr = address
        
        guard let networkReachability = withUnsafePointer(to: &addr, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
            
        }) else {
            return nil
        }
 
        return networkReachability
    }
    
    private static func createReachabilityWithHost(_ host: String) -> SCNetworkReachability? {
        let hostToReach = host
        
        guard let networkReachability = withUnsafePointer(to: hostToReach, {_ in 
            SCNetworkReachabilityCreateWithName(nil, hostToReach)
            
        }) else {
            return nil
        }
        
        return networkReachability
    }
    
    private static func statusFromReachabilityFlags(_ flags: SCNetworkReachabilityFlags) -> AKReachabilityStatus {
        var status: AKReachabilityStatus
        
        let isConnectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isReachableViaWwan = flags.contains(.isWWAN)
        
        if !isConnectionRequired && isReachable {
            if isReachableViaWwan {
                status = .reachableViaWWan
            } else {
                status = .reachableViaWifi
            }
            
        } else {
            status = .notReachable
        }
        
        return status
    }
    
    private static func isReachableFromStatus(_ status: AKReachabilityStatus) -> Bool {
        switch status {
        case .reachableViaWifi:
                return true
        case .reachableViaWWan:
                return true
        default:
                return false
        }
        
    }

    private static func handleReachabilityStatusUpdate(_ pointer: UnsafeMutableRawPointer, isReachable: Bool, reachabilityStatus: AKReachabilityStatus) {
        
            let selfInstance = Unmanaged<AKReachability>.fromOpaque(pointer).takeUnretainedValue()
        
            selfInstance._isReachable = isReachable
            selfInstance._reachabilityStatus = reachabilityStatus
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: AKReachabilityDidChangeNotification),
                object: nil,
                userInfo: ["AKReachabilityStatusChanged": reachabilityStatus.description])
            
            DispatchQueue.main.async(execute: { () -> Void in
                selfInstance.reachabilityClosure?(selfInstance.isReachable,
                                                  selfInstance.reachabilityStatus)
            })
    }

// **************************************************
// MARK: - Self Public Methods
// **************************************************

    /**
     Method that starts monitoring reachability of the default address, 
     a custom host or custom address
    
     For setting a host for reachability, call setHostForReachability and supply a host as String, ie: "ibm.com"
    
     For setting a custom address for reachability, call setAddressForReachability and supply a sockaddr_in with the address 
     for monitoring reachability
     */
    public func startMonitoring() {
        self.stopMonitoring()
        
        guard let reachability = self.scNetworkReachability else {
            self._isReachable = isReachable
            self._reachabilityStatus = reachabilityStatus
            
            return
        }
        
        var scNetworkContext = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        scNetworkContext.info = UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
        
        SCNetworkReachabilitySetCallback(reachability, { (_, flags, info) in
                let reachabilityStatus = AKReachability.statusFromReachabilityFlags(flags)
                let isReachable = AKReachability.isReachableFromStatus(reachabilityStatus)
            
                AKReachability.handleReachabilityStatusUpdate(info!,
                    isReachable: isReachable,
                    reachabilityStatus: reachabilityStatus)
            },
            &scNetworkContext)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    /**
     Stops AKReachability of monitoring for internet connection changes
     */
    public func stopMonitoring() {
        guard let reachability = self.scNetworkReachability else {
            return
        }
    
        SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    /**
     Sets a host for monitoring reachability, when this method is called, reachability monitoring is stopped
     you should call startMonitoring() after setting a new host
    
     - parameter host: a host for monitoring reachability with the format "host.domain" ie: "ibm.com"
     */
    public func setHostForReachability(_ host: String) {
        self.stopMonitoring()
        self.scNetworkReachability = nil
        
        guard let hostReachAbility = AKReachability.createReachabilityWithHost(host) else {
            return
        }
        
        self.scNetworkReachability = hostReachAbility
    }
    
    /**
     Sets an address for monitoring reachability, when this method is called, reachability monitoring is stopped
     you should call startMonitoring() after setting a new address
    
     - parameter address: an address for monitoring reachability with the format "host.domain" ie: "ibm.com"
     */
    public func setAddressForReachability(_ address: sockaddr_in) {
        self.stopMonitoring()
        self.scNetworkReachability = nil
        
        guard let addressReachability = AKReachability.createReachabilityWithAddress(address) else {
            return
        }
        
        self.scNetworkReachability = addressReachability
    }
    
// **************************************************
// MARK: - Override Public Methods
// **************************************************
}
