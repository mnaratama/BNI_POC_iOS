//
//  Keychain+Utils.swift
//  Supervisor
//
//  Created by Mukunda Marthy on 9/03/23.
//  Copyright © 2023 IBM. All rights reserved.
//

import UIKit

public let UserKey = "username"
public let PassKey = "password"
public let ServiceKey = "credentials"

extension Keychain {

    struct Keys {
        static let credentials = Bundle.main.bundleIdentifier! + ".Login"
        static let userID = "BNILogin.userId"
    }

    // MARK: - Credentials (username, password)

    class func getCredentials() -> [String: NSCoding]? {
       
        do {
            return try Keychain.loadDataForUserAccount(Keys.credentials)
        } catch(let error) {
            NSLog("%@", error.localizedDescription)
        }
        
        return nil
    }
    
    class func getPreviousLoggedUser() -> String {
        let storedCredentials = Keychain.getCredentials()
        return storedCredentials?["username"] as? String ?? ""
    }

    class func saveCredentials(userName: String, password: String) {
        let data: [String: NSCoding] = [
            UserKey: userName as NSString,
            PassKey: password as NSString
        ]

        let options = KeychainOptions()
        _ = options.service(ServiceKey)

        _ = Keychain.saveData(data, forUserAccount: Keys.credentials, withOptions: options)
    }
    
    class func deleteCredentials() {
        let options = KeychainOptions()
        _ = options.service(ServiceKey)

        do {
            try Keychain.deleteDataForUserAccount(Keys.credentials, withOptions: options)
        } catch {
            NSLog("%@", error.localizedDescription)
        }
    }
    
    class func readStoredCredentialsFromKeychain() -> [String: NSCoding]? {
        do {
            let storedCredentials = try Keychain.loadDataForUserAccount(Keychain.Keys.credentials)
            return storedCredentials

        } catch {
            NSLog("%@", error.localizedDescription)
            return nil
        }
    }
}
