//
//  EnterMobileNumberView.swift
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

class EnterMobileNumberViewController: BaseViewController, UITextFieldDelegate {
    
    enum Constants {
        static let colorBNITeal = "BNI Teal"
        static let colorButtonDisabled = "Button Disabled"
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLineLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var mobileNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        nextButton(shouldEnable: false)
    }
   
    /// Configures the text filed and adds the tap gesture
    fileprivate func setupTextField() {
        textField.isUserInteractionEnabled = true
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(updatedValue(textField:)), for: .editingChanged)
    }

    /// method to enable / disable the next button
    fileprivate func nextButton(shouldEnable: Bool = false) {
        self.nextButton.isEnabled = shouldEnable
        self.nextButton.backgroundColor = shouldEnable ? UIColor(named: Constants.colorBNITeal) : UIColor(named: Constants.colorButtonDisabled)
    }
    
    /// called each time user enters a value in the textFiled, Validation should happen here
    @objc func updatedValue(textField: UITextField) {
        guard let valueEntered = textField.text else {
            return
        }

    //TODO: Validate the entered data here and enable the button
        
        self.nextButton(shouldEnable: true)
        mobileNumber = valueEntered
    }

    /// called when the keyboard gets dismissed,  any additional validation should happen here
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let _ = textField.text else {
            return
        }
        self.nextButton(shouldEnable: true)
        //TODO: save the data if required here
    }
    
    @IBAction func buttonDoneTapped(_ sender: Any) {
        UserDefaults.standard.set(self.mobileNumber, forKey: "MobileNumber")
        NetworkAccessLayer.shared.generateOTP(mobileNumber: self.mobileNumber, completionHandler: {isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse {
                print("Response JSON : \(baseResponse)")
            }
        })

        guard let viewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.OtpViewController) as? OtpViewController else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
