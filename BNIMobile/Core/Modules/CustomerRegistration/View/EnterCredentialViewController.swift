//
//  EnterCredentialViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class EnterCredentialViewController: BaseViewController {
    
    @IBOutlet weak var vwToBG:UIView!
    @IBOutlet weak var stackVW:UIStackView!
    @IBOutlet weak var lblUrerIdError:UILabel!
    @IBOutlet weak var lblPswdError:UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideErrorLabel()
//        nextButton(shouldEnable: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    fileprivate func nextButton(shouldEnable: Bool = false) {
        self.nextButton.isEnabled = shouldEnable
        self.nextButton.backgroundColor = shouldEnable ? UIColor(named: EnterMobileNumberViewController.Constants.colorBNITeal) : UIColor(named: EnterMobileNumberViewController.Constants.colorButtonDisabled)
    }

    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.congratulationsDoneVC) as? CongratulationsDoneViewController else {
            fatalError("Failed to load Main from CongratulationsDoneViewController file")
        }
        userDefaultsToSaveCustomerRegStatus()
        self.navigationController?.pushViewController(viewController, animated: true)
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
}
