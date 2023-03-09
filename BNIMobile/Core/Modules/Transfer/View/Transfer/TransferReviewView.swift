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
        static let mPinStoryboardName = "Mpin"
        static let mPinView = "MpinVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferReviewView")
    }
    
    @IBAction func buttonConfirmTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.mPinStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.mPinView) as? MpinView else {
            fatalError("Failed to load Transfer from TransferReviewView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
