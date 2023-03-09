//
//  CongratulationsPointViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class CongratulationsPointViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func CloseButtonAction(_ sender: Any) {
        guard let viewController = UIStoryboard(name: StoryboardName.home, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.tabBarVC) as? UITabBarController else {
            fatalError("Failed to load Main from EnterMobileNumberVC file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
