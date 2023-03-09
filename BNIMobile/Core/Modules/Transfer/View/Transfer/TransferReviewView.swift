//
//  TransferReviewView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//
import UIKit

class TransferReviewView : UIViewController {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferSuccessView = "TransferSuccessVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferReviewView")
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferSuccessView) as? TransferSuccessView else {
            fatalError("Failed to load Transfer from TransferReviewView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
