//
//  EnterCredentialViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class EnterCredentialViewController: UIViewController {
    
    @IBOutlet weak var vwToBG:UIView!
    @IBOutlet weak var stackVW:UIStackView!
    @IBOutlet weak var lblUrerIdError:UILabel!
    @IBOutlet weak var lblPswdError:UILabel!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        hideErrorLabel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }

    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: VCConstants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: VCConstants.congratulationsDoneVC) as? CongratulationsDoneViewController else {
            fatalError("Failed to load Main from CongratulationsDoneViewController file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func hideErrorLabel(){
        lblPswdError.isHidden = true
        lblUrerIdError.isHidden = true
    }
}
