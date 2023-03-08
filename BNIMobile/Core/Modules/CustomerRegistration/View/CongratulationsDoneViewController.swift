//
//  CongratulationsDoneViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class CongratulationsDoneViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func buttonDoneTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: StoryboardName.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.congratulationsPointVC) as? CongratulationsPointViewController else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
