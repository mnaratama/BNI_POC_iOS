//
//  TransferEnterDataView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class TransferEnterDataView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferConfirmView = "TransferConfirmVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferEnterDataView")
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferConfirmView) as? TransferConfirmView else {
            fatalError("Failed to load Transfer from TransferEnterDataView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
