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

public let AKNetworkingErrorDomain = "com.ibm.mobilefirst.frameworks.AKNetworking"

// **********************************************************************************************************
//
// MARK: - Definitions -
//
// **********************************************************************************************************

public class Box<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
    
}

func delay(_ delay: Double, closure: @escaping () -> Void) {
    // DispatchQueue.main.after(when: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func keyForURL(_ URL: Foundation.URL?) -> String {
    return keyForHost(URL?.host, withPort: (URL as NSURL?)?.port?.intValue)
}

func keyForHost(_ host: String?, withPort port: Int?) -> String {
    return [host, port?.description].filter({ $0 != nil }).map({ $0! }).joined(separator: "")
}

func +=<K, V> (left: inout [K: V], right: [K: V]) { for (key, value) in right { left[key] = value } }
