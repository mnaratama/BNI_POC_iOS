//
//  EnterCredentialViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class EnterCredentialViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var vwToBG:UIView!
    @IBOutlet weak var stackVW:UIStackView!
    @IBOutlet weak var lblUrerIdError:UILabel!
    @IBOutlet weak var lblPswdError:UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userIdWarningView: UIView!
    @IBOutlet weak var passwordWarningView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        hideErrorLabel()
        enableNextButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /// Configures the text filed and adds the tap gesture
    fileprivate func setupTextField() {
        userIdTextField.isUserInteractionEnabled = true
        userIdTextField.delegate = self
        passwordTextField.isUserInteractionEnabled = true
        passwordTextField.delegate = self
    }
    
    fileprivate func enableNextButton() {
        let shouldEnable = !(userIdTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty
        self.nextButton.isEnabled = shouldEnable
        self.nextButton.backgroundColor = shouldEnable ? UIColor(named: EnterMobileNumberViewController.Constants.colorBNITeal) : UIColor(named: EnterMobileNumberViewController.Constants.colorButtonDisabled)
    }

    @IBAction func buttonNextTapped(_ sender: Any) {
        NetworkAccessLayer.shared.verifyCredentials(userId: userIdTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.message == "success" {
                guard let viewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.congratulationsDoneVC) as? CongratulationsDoneViewController else {
                    fatalError("Failed to load Main from CongratulationsDoneViewController file")
                }
                self.userDefaultsToSaveCustomerRegStatus()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        })
    }
    
    func userDefaultsToSaveCustomerRegStatus() {
        //TODO: can be removed once we have the API inplace to determine this status
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "hasCustomerRegistered")
    }
    
    func hideErrorLabel(){
        lblPswdError.isHidden = true
        lblUrerIdError.isHidden = true
    }
    
    // MARK: - TextField Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableNextButton()
    }
}
