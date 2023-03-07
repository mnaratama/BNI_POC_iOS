//
//  CustomerRegView.swift
//  BNIMobile
/*
 * Licensed Materials - Property of IBM
 * Copyright (C) 2023 IBM Corp. All Rights Reserved.
 *
 * IMPORTANT: This IBM software is supplied to you by IBM
 * Corp. (""IBM"") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit

enum VCConstants {
    static let mainStoryboardName = "Main"
    static let enterMobileNumberVC = "EnterMobileNumberVC"
    static let congratulationsDoneVC = "CongratulationsDoneViewController"
    static let congratulationsPointVC = "CongratulationsPointViewController"
    static let enterCredentialVC = "EnterCredentialViewController"
}

class CustomerRegView: UIViewController {
    
    enum Constants {
        static let mainStoryboardName = "Main"
        static let enterMobileNumberVC = "EnterMobileNumberVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebAccessLayer.shared.getMetadata(uuid: "testID", completionHandler: {isSuccess, responseJson, _  in
            if isSuccess {
                print("Response JSON : \(responseJson)")
            }
        })
    }
    
    @IBAction func buttonTappedToStart(_ sender: Any) {        
        guard let viewController = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.enterMobileNumberVC) as? EnterMobileNumberView else {
            fatalError("Failed to load Main from EnterMobileNumberVC file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
