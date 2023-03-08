//
//  BiometricLoginViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 08/03/23.
//

import UIKit

class BiometricLoginViewController: BaseViewController {

    @IBOutlet weak var buttonLoginWithUserId:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLoginButton()
    }
    

    private func setUpLoginButton(){
        buttonLoginWithUserId.layer.borderWidth = 1.0
        buttonLoginWithUserId.layer.borderColor = CGColor.init(red: 0, green: 102, blue: 133, alpha: 1)
    }
    
    @IBAction func buttonLoginWithUserIdPressed(sender:Any){
        guard let viewController = UIStoryboard(name: StoryboardName.preLogin, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.loginVC) as? LoginViewController else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
