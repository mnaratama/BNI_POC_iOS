//
//  LoginViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 08/03/23.
//


import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
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
        configureWarningBorderView(showWarning: false)
        enableNextButton()
        //self.setCustomBackButton(imgName: "close", target: self, selector: #selector(backAction))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func backAction() {
        self.navigationController?.popToRootViewController(animated: true)
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
                guard let viewController = UIStoryboard(name: StoryboardName.home, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.tabBarVC) as? UITabBarController else {
                    fatalError("Failed to load Main from EnterMobileNumberVC file")
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.configureWarningBorderView(showWarning: true)
            }
        })
    }
    
    func configureWarningBorderView(showWarning: Bool) {
        configureErrorLabel(shouldShow: showWarning)
        userIdWarningView.isHidden = !showWarning
        userIdWarningView.layer.borderWidth = 2
        userIdWarningView.layer.borderColor = UIColor.red.cgColor
        
        passwordWarningView.isHidden = !showWarning
        passwordWarningView.layer.borderWidth = 2
        passwordWarningView.layer.borderColor = UIColor.red.cgColor
    }

    func userDefaultsToSaveCustomerRegStatus() {
//        //TODO: can be removed once we have the API inplace to determine this status
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(true, forKey: "hasCustomerRegistered")
        if let username = userIdTextField.text, let password = passwordTextField.text {
            storeCredentials(username, password)
        }
    }
    
    func storeCredentials(_ username: String, _ password: String) {
        // store credentials in keychain for next offline
        let credentials = ["username": username as NSString, "password": password as NSString]
        _ = KeychainOptions().securityAccessType(SecurityAccessType.whenUnlocked)
        _ = Keychain.saveData(credentials, forUserAccount: Keychain.Keys.credentials)

    }
    
    func configureErrorLabel(shouldShow: Bool){
        lblPswdError.isHidden = !shouldShow
        lblPswdError.textColor = UIColor.red
        lblUrerIdError.isHidden = !shouldShow
        lblUrerIdError.textColor = UIColor.red
    }
    
    // MARK: - TextField Delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableNextButton()
    }
}
