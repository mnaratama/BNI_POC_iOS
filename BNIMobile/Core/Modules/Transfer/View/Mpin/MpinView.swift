//
//  MpinView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class MpinView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferSuccessView = "TransferSuccessVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MpinView")
    }
    
    @IBAction func buttonSubmitTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferSuccessView) as? TransferSuccessView else {
            fatalError("Failed to load Transfer from MpinView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
