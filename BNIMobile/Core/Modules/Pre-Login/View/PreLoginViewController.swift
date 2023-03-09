//
//  PreLoginViewController.swift
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

class PreLoginViewController: BaseViewController {
    
    @IBOutlet weak var balanceView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkAccessLayer.shared.getAccountBalance(accounrNo: "", completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.message == "success" {
//                let data = baseResponse.content?.current_balance
//                print("xxxxxxxxx", data)
            }
        })
    }
    
    @IBAction func longPressForBalance(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        showBalanceView(status: false)
    }
    
    @IBAction func tapPressForCloseBalance(_ sender: Any) {
        showBalanceView(status: true)
    }
    
    private func showBalanceView(status:Bool) {
        UIView.transition(with: balanceView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.balanceView.isHidden = status
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let viewController = UIStoryboard(name: StoryboardName.preLogin, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.biometricLoginVC) as? BiometricLoginViewController else {
            fatalError("Failed to load Main from BiometricLoginViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
