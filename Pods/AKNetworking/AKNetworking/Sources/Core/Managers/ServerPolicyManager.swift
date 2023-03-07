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
/**
 This is an enum that should be used to print the error that can occur when loading a certificate and the
 result is nil.
 **/

private enum CertificateError: Error {
    case certificateNil(String)
}

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
 This class is responsible for loading the certificates and public keys to the developer. You can load
 different ways, working with only a certificate or an array of certificates or a key array.
 **/
public class ServerPolicyManager: NSObject, URLSessionDataDelegate {

// **************************************************
// MARK: - Properties
// **************************************************

    var certificates: [SecCertificate]?
    var keys: [SecKey]?

// **************************************************
// MARK: - Constructors
// **************************************************

// **************************************************
// MARK: - Internal Methods
// **************************************************

    internal func certificateDataForTrust(_ trust: SecTrust) -> [Data] {
        var certificates: [SecCertificate] = []
		print(SecTrustGetCertificateCount(trust))
        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.append(certificate)
            }
            
        }

        return allCertificateDataForCertificates(certificates)
    }

    internal func allCertificateDataForCertificates(_ certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
        
    }

    internal func trustIsValid(_ trust: SecTrust) -> Bool {
        
        var isValid = false
        var result = SecTrustResultType.invalid
        if #available(iOS 13, *) {
            let status = SecTrustEvaluateWithError(trust, nil)
            if status {
                
                let unspecified = SecTrustResultType.unspecified
                let proceed = SecTrustResultType.proceed
                
                let validate = result == unspecified || result == proceed
                isValid = validate
            }
            return isValid
        } else {
            let status = SecTrustEvaluate(trust, &result)
            if status == errSecSuccess {
                let unspecified = SecTrustResultType.unspecified
                let proceed = SecTrustResultType.proceed
                
                let validate = result == unspecified || result == proceed
                isValid = validate
            }
            return isValid
        }
    }

    internal  func keysForTrust(_ trust: SecTrust) -> [SecKey] {
        var publicKeysLoaded: [SecKey] = []

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let
                certificate = SecTrustGetCertificateAtIndex(trust, index),
                let publicKey = keyForCertificate(certificate) {
                publicKeysLoaded.append(publicKey)
            }
            
        }

        return publicKeysLoaded
    }

    internal  func keyForCertificate(_ certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreationStatus == errSecSuccess {
            if #available(iOS 14, *) {
            publicKey = SecTrustCopyKey(trust)
            } else {
                publicKey = SecTrustCopyPublicKey(trust)
            }
        }

        return publicKey
    }

// **************************************************
// MARK: - Private Methods
// **************************************************

    private static func keyForCertificate(_ certificate: SecCertificate) -> SecKey? {

        var currentPublicKey: SecKey?

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreateStatus = SecTrustCreateWithCertificates(certificate, policy, &trust)

        if let trust = trust, trustCreateStatus == errSecSuccess {
            if #available(iOS 14, *) {
                currentPublicKey = SecTrustCopyKey(trust)
            } else {
                currentPublicKey = SecTrustCopyPublicKey(trust)
            }
        }
        return currentPublicKey
    }

// **************************************************
// MARK: - Self Public Methods
// **************************************************
    /**
     Loads a specific certificate that this within the project, you can use this method to load exactly the
     certificate you need. Passing the bundle,the name and type of the certificate. The default is the
     certificate path is mainBundle (), but you can change through your specific path.

     - parameter bundle: This is the certificate path.
     - parameter nameFromCertificate: this is the name of the certificate.
     - parameter ofType: This is the type of the certificate.

     - returns: a loaded certificate.
     */
//    public class func certificateNamed(name: String, ofType: String, bundle: NSBundle = NSBundle.mainBundle()) -> SecCertificate? {
//
//        if let pathToCert = bundle.pathForResource(name, ofType: ofType),
//            localCertificate = (NSData(contentsOfFile: pathToCert)),
//            certificate = SecCertificateCreateWithData(nil, localCertificate) {
//
//            return certificate
//        }
    
//
//		return nil
//    }

    /**
    This method load a specific array of certificates. In this case it carries the certificates with the
    type and the path that you pass.

     - parameter bundle: This is the certificate path.
     - parameter ofType: This is the type of the certificate.

     - returns: a  array with certificates.
     */
//    public class func certificateWithTypeInBundle(bundle: NSBundle = NSBundle.mainBundle(), ofType:[String]) ->  [SecCertificate]? {
//
//        var certificatesLoaded: [SecCertificate] = []
//        let paths = Set(ofType.map { fileExtension in
//            bundle.pathsForResourcesOfType(fileExtension, inDirectory: nil)
//            }.flatten())
//
//        for path in paths {
//            if let
//                certificateData = NSData(contentsOfFile: path),
//                certificate = SecCertificateCreateWithData(nil, certificateData) {
//                certificatesLoaded.append(certificate)
//            }
    
//        }
    
//
//        return certificatesLoaded
//
//    }

//    /**
//     This method carry an array of all the certificates that are within the project with extensions
//     [".cer". "CER". "Crt". "CRT". "Der". "DER"]. It works only with the bundle paramentro which by default
//     is the mainBundle () but you can go a different path if needed.
//
//     - parameter bundle: This is the certificate path.
//
//     - returns: a  array with certificates.
//     */
//    public class func certificatesInBundle(bundle: NSBundle = NSBundle.mainBundle()) -> [SecCertificate] {
//
//        var certificatesLoaded: [SecCertificate] = []
//
//        let paths = Set([".cer", ".CER", ".crt", ".CRT", ".der", ".DER"].map { fileExtension in
//            bundle.pathsForResourcesOfType(fileExtension, inDirectory: nil)
//            }.flatten())
//
//        for path in paths {
//            if let
//                certificateData = NSData(contentsOfFile: path),
//                certificate = SecCertificateCreateWithData(nil, certificateData) {
//                certificatesLoaded.append(certificate)
//            }
    
//        }
    
//
//        return certificatesLoaded
//    }

//    /**
//     This method loads an array with with all publicsKeys of certificates that are in the project.
//     The default is to load the keys with mainBundle (), but you can change the path if needed.
//
//     - parameter bundle: This is the keys path.
//
//     - returns: a  array with PublicsKeys.
//     */
//    public class func keysInBundle(bundle: NSBundle = NSBundle.mainBundle()) -> [SecKey] {
//        var arryPublicKeys: [SecKey] = []
//
//        for certificate in certificatesInBundle(bundle) {
//            if let publicKey = keyForCertificate(certificate) {
//                arryPublicKeys.append(publicKey)
//            }
    
//        }
    
//
//        return arryPublicKeys
//    }

// **************************************************
// MARK: - Override Public Methods
// **************************************************

}
