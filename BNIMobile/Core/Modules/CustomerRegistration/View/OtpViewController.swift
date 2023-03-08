//
//  OtpViewController.swift
//  BNIMobile
//
//  Created by Hari R Krishna on 07/03/23.
//

import UIKit

class OtpViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var otp: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        nextButton(shouldEnable: false)
    }
    
    /// Configures the text filed and adds the tap gesture
    fileprivate func setupTextField() {
        textField.isUserInteractionEnabled = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(updatedValue(textField:)), for: .editingChanged)
    }

    /// method to enable / disable the next button
    fileprivate func nextButton(shouldEnable: Bool = false) {
        self.nextButton.isEnabled = shouldEnable
        self.nextButton.backgroundColor = shouldEnable ? UIColor(named: EnterMobileNumberViewController.Constants.colorBNITeal) : UIColor(named: EnterMobileNumberViewController.Constants.colorButtonDisabled)
    }

    /// called each time user enters a value in the textFiled, Validation should happen here
    @objc func updatedValue(textField: UITextField) {
        guard let valueEntered = textField.text else {
            return
        }

        otp = valueEntered
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        // to check the maxLength of otp = 6
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        // enable next button only if the number is entered, disable if the number is cleared
        self.nextButton(shouldEnable: !newString.isEmpty && newString.count >= 6)

        return newString.count <= 6
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        NetworkAccessLayer.shared.validateOTP(otp: otp, completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse {
                print("Response JSON : \(baseResponse)")
            }
        })
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        
    }
    
}
