//
//  BiometricLoginViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 08/03/23.
//

import UIKit
import LocalAuthentication

class BiometricLoginViewController: BaseViewController {

    @IBOutlet weak var buttonLoginWithUserId:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLoginButton()
        authorizeUsingTouchID()
        
    }
    

    private func setUpLoginButton(){
        buttonLoginWithUserId.layer.borderWidth = 1.0
        buttonLoginWithUserId.layer.borderColor = CGColor.init(red: 0.0/255.0, green: 102.0/255.0, blue: 133.0/255.0, alpha: 1.0)
    }
    
    @IBAction func buttonLoginWithUserIdPressed(sender:Any){
        guard let viewController = UIStoryboard(name: StoryboardName.preLogin, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.loginVC) as? LoginViewController else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func authorizeUsingTouchID() {
        let touchIDContext = LAContext()
        let reasonString = "Validate Biometrics(Face/Fingerprint) to signin"
       
        var error: NSError?
        if touchIDContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            // check fingerprint as device owner
            touchIDContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {
                (success: Bool, error: Error?) -> Void in
                
                // note: the block is executed on a private queue internal to the framework in an unspecified threading context
                if success {
                    DispatchQueue.main.async {
                        self.signInWithBiometrics()
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let FRAMEWORK_BUNDLE = Bundle(for: BiometricLoginViewController.self)
                        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                        alertController.title = NSLocalizedString("Unsuccessful", bundle:FRAMEWORK_BUNDLE, comment: "Unsuccessful")
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", bundle:FRAMEWORK_BUNDLE, comment: "OK"), style: UIAlertAction.Style.cancel, handler: nil))
                        
                        let error = error as! LAError
                        switch error.code {
                            
                        case .authenticationFailed:
                            alertController.message = NSLocalizedString("Authentication Failed", bundle:FRAMEWORK_BUNDLE, comment: "Authentication Failed")
                            
                        case .userCancel:
                            return // user pressed "Cancel" on the touch ID popup: just let the user use the login screen
                            
                        case .userFallback:
                            return // user pressed "Enter Password" on the touch ID popup: just let the user use the login screen
                            
                        case .systemCancel:
                            alertController.message = NSLocalizedString("System Cancelled", bundle:FRAMEWORK_BUNDLE, comment: "System Cancelled")
                            
                        default:
                            alertController.message = NSLocalizedString("Unable to Authenticate", bundle:FRAMEWORK_BUNDLE, comment: "Unable to Authenticate")
                        }
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func signInWithBiometrics() {
        let (username, password) = retriveStoredCredentials()
        NetworkAccessLayer.shared.verifyCredentials(userId: username, password: password, completionHandler: { isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.message == "success" {
                guard let viewController = UIStoryboard(name: StoryboardName.home, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.tabBarVC) as? UITabBarController else {
                    fatalError("Failed to load Main from EnterMobileNumberVC file")
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        })
    }
    
    
    func retriveStoredCredentials() -> (String, String) {
        // retrieve the stored credentials from the keychain
        let storedCredentials = Keychain.readStoredCredentialsFromKeychain()
        let username = storedCredentials?["username"] as? String ?? ""
        let password = storedCredentials?["password"] as? String ?? ""

        return (username, password)
    }

}
