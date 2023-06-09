//
//  MpinView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class MpinView: BaseViewController, UITextFieldDelegate {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferSuccessView = "TransferSuccessVC"
    }
    
    var transferConfirmationViewModel: TransferConfirmationViewModel?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var enterOTPLabel: UILabel!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    var otp: String = ""
    var timer: Timer?
    var counter = 30

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton(shouldEnable: false)
        configureWarningLabel(showWarning: false)
       // self.performSelector(onMainThread: #selector(setTimer), with: nil, waitUntilDone: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupEnterOTPText()
        nextButton(shouldEnable: false)
        configureWarningLabel(showWarning: false)
    }
    
    @objc func setTimer() {
        resendOTPButton.isEnabled = false
        counter = 30
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateOTPTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateOTPTimerLabel() {
        if counter > 0 {
            counter -= 1
        } else {
            resendOTPButton.isEnabled = true
            timer?.invalidate()
        }
        warningLabel.text = "\(counter) sec"
    }
    
    func setupEnterOTPText() {
//        if let mobileNumber = UserDefaults.standard.string(forKey: "MobileNumber") {
//            enterOTPLabel.text = "Enter the OTP sent to \(mobileNumber)"
//        } else {
//            enterOTPLabel.text = "Enter the OTP sent"
//        }
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
    
    // MARK: - TextField Delegates
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
    
    func configureWarningLabel(showWarning: Bool) {
        configureWarningBorderView(showWarning: showWarning)
        if showWarning {
            self.warningLabel.text = "Wrong MPIN"
            self.warningLabel.textColor = UIColor.red
            self.warningLabel.isHidden = false
        } else {
            self.warningLabel.text = ""
            self.warningLabel.textColor = UIColor.clear
            self.warningLabel.isHidden = true
        }
    }
        
    func configureWarningBorderView(showWarning: Bool) {
        warningView.isHidden = !showWarning
        warningView.layer.borderWidth = 2
        warningView.layer.borderColor = UIColor.red.cgColor
    }
    
    // MARK: - Button action
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        NetworkAccessLayer.shared.validateOTP(otp: otp, completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.success ?? false  {
                guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferSuccessView) as? TransferSuccessView else {
                    fatalError("Failed to load Transfer from MpinView file")
                }
                viewController.transferConfirmationViewModel = self.transferConfirmationViewModel
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.configureWarningLabel(showWarning: true)
            }
        })
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        self.configureWarningLabel(showWarning: false)
        self.nextButton(shouldEnable: false)
        self.textField.text = ""
        if let mobileNumber = UserDefaults.standard.string(forKey: "MobileNumber") {
            NetworkAccessLayer.shared.generateOTP(mobileNumber: mobileNumber, completionHandler: {isSuccess, baseResponse, _  in
                if isSuccess, let baseResponse = baseResponse {
                    print("resendButtonTapped \n Response JSON : \(baseResponse)")
                }
                // start the tcount down imer
                    //self.performSelector(onMainThread: #selector(self.setTimer), with: nil, waitUntilDone: true)
            })
        }
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
