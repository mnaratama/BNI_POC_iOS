//
//  TransferSuccessView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//

import UIKit

class TransferSuccessView : UIViewController {
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferRecurringSuccessView = "TransferRecurringSuccessVC"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageView = "LandingPageVC"
        static let transferRecurringModalBottomView = "TransferRecurringModalBottomVC"

    }
    
    var transferConfirmationViewModel: TransferConfirmationViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferSuccessView")
        self.amountLabel.text = "\(self.transferConfirmationViewModel?.currencyConversion?.destinationAmount ?? 0.00)"
        self.recipientNameLabel.text = self.transferConfirmationViewModel?.receiver?.receiverName ?? ""
    }
    
    @IBAction func setUpButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferRecurringModalBottomView) as? TransferRecurringModalBottomView else {
            fatalError("Failed to load TransferRecurringModalBottomView from TransferSuccessView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageView) as? LandingPageView else {
            fatalError("Failed to load LandingPage from TransferSuccessView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

