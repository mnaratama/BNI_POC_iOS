//
//  LandingPageView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class LandingPageView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferEnterDataView = "TransferEnterDataVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LandingPageView")
    }
    
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferEnterDataView) as? TransferEnterDataView else {
            fatalError("Failed to load Transfer from LandingPageVC file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
