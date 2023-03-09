//
//  TransferReviewView.swift
//  BNIMobile
//
//  Created by admin on 08/03/23.
//
import UIKit

class TransferReviewView : UIViewController {
    
    @IBOutlet weak var foreignCurrencyAmountLabel: UILabel!
    
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    @IBOutlet weak var idrAmountLabel: UILabel!
    
    @IBOutlet weak var transferFeesGuaranteedLabel: UILabel!
    
    @IBOutlet weak var recipientReceivedAmountLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var accountNumberLabel: UILabel!
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    
    @IBOutlet weak var bicCodeLabel: UILabel!
    
    @IBOutlet weak var recipientBankLabel: UILabel!
    
    @IBOutlet weak var reipientCurrencyLabel: UILabel!
    
    var transferConfirmationViewModel: TransferConfirmationViewModel?
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferSuccessView = "TransferSuccessVC"
        static let mPinStoryboardName = "Mpin"
        static let mPinView = "MpinVC"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferReviewView")
        let recipient = self.transferConfirmationViewModel?.receiver
        self.accountNumberLabel.text = "\(recipient?.receiverAcNumber ?? "")"
        self.recipientNameLabel.text = "\(recipient?.receiverName ?? "")"
        self.recipientBankLabel.text = "\(recipient?.receiverBankName ?? "")"
        self.reipientCurrencyLabel.text = "\(recipient?.receiverCurrency ?? "")"
        
       // self.foreignCurrencyAmountLabel.text = self.transferConfirmationModel.
        if let currencyConversion = self.transferConfirmationViewModel?.currencyConversion {
            self.foreignCurrencyAmountLabel.text = "\(currencyConversion.destinationAmount)"
            self.exchangeRateLabel.text = "1 \(currencyConversion.destinationCurrencyCode) = \(currencyConversion.exchangeRate) \(currencyConversion.sourceCurrencyCode)"
            self.idrAmountLabel.text = "\(currencyConversion.sourceAmount)"
            self.transferFeesGuaranteedLabel.text = "\(currencyConversion.transferFeePercentage * currencyConversion.sourceAmount / 100)"
            self.recipientReceivedAmountLabel.text = String(format: "%.2f", currencyConversion.calculateRecipientAmount())
            self.totalAmountLabel.text = "\(currencyConversion.calculateTotal())"
        }
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
