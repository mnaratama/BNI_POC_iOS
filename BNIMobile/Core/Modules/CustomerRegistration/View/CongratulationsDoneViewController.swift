//
//  CongratulationsDoneViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class CongratulationsDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func buttonDoneTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: VCConstants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: VCConstants.congratulationsPointVC) as? CongratulationsPointViewController else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
