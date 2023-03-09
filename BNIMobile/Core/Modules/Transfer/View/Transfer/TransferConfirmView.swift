//
//  TransferConfirmView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class TransferConfirmView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferReviewView = "TransferReviewVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferConfirmView")
    }
    
    @IBAction func buttonProceedTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferReviewView) as? TransferReviewView else {
            fatalError("Failed to load Transfer from TransferConfirmView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
