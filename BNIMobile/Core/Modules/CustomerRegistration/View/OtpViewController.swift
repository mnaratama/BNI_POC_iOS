//
//  OtpViewController.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 07/03/23.
//

import UIKit

class OtpViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        NetworkAccessLayer.shared.validateOTP(otp: "1111", completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse {
                print("Response JSON : \(baseResponse)")
            }
        })
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        
    }
    
}
