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
    
    var isCheckedPoin = false
    var isCheckedTC = false
    
    @IBOutlet weak var usePoinButton: UIImageView!
    
    @IBOutlet weak var tcButton: UIImageView!
    
    @IBOutlet weak var recipientLabel: UILabel!
    
    @IBOutlet weak var receipientBankAccountLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var foreignCurrencyAmountLabel: UILabel!
    
    @IBOutlet weak var idrAmountLabel: UILabel!
    
    @IBOutlet weak var guaranteedFeesLabel: UILabel!
    
    @IBOutlet weak var receipientFeesLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var transferConfirmationModel: TransferConfirmationViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferConfirmView")
        setupGestureRecognizer()
        let recipient = self.transferConfirmationModel?.receiver
        self.recipientLabel.text = recipient?.receiverName
        self.receipientBankAccountLabel.text = "\(recipient?.receiverBankName ?? "") | \(recipient?.receiverAcNumber ?? "")"
        self.currencyLabel.text = "\(recipient?.receiverCountryName ?? "") - \(recipient?.receiverCurrency ?? "")"
        
       // self.foreignCurrencyAmountLabel.text = self.transferConfirmationModel.
        if let currencyConversion = self.transferConfirmationModel?.currencyConversion {
            self.foreignCurrencyAmountLabel.text = "\(currencyConversion.destinationAmount)"
            self.idrAmountLabel.text = "\(currencyConversion.sourceAmount)"
            self.guaranteedFeesLabel.text = "\(currencyConversion.transferFeePercentage * currencyConversion.sourceAmount / 100)"
            self.receipientFeesLabel.text =  String(format: "%.2f", currencyConversion.calculateRecipientAmount())
            self.totalAmountLabel.text = "\(currencyConversion.calculateTotal())"
        }
    }
    
    func setupGestureRecognizer(){
        let usePoinGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(usePoinSelector(tapGestureRecognizer:)))
        usePoinButton.addGestureRecognizer(usePoinGestureRecognizer)
        
        let tcGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tcSelector(tapGestureRecognizer:)))
        tcButton.addGestureRecognizer(tcGestureRecognizer)
    }
    
    @objc func usePoinSelector(tapGestureRecognizer: UITapGestureRecognizer){
        print("tapped")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isCheckedPoin){
            tappedImage.image = UIImage(systemName:  "square")! as UIImage
            isCheckedPoin = false
        }
        else {
            tappedImage.image = UIImage(systemName: "checkmark.square")! as UIImage
            isCheckedPoin = true
        }
    }
    
    @objc func tcSelector(tapGestureRecognizer: UITapGestureRecognizer){
        print("tapped")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isCheckedTC){
            tappedImage.image = UIImage(systemName:  "square")! as UIImage
            isCheckedTC = false
        }
        else {
            tappedImage.image = UIImage(systemName: "checkmark.square")! as UIImage
            isCheckedTC = true
        }
    }
    
    @IBAction func buttonProceedTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferReviewView) as? TransferReviewView else {
            fatalError("Failed to load Transfer from TransferConfirmView file")
        }
        viewController.transferConfirmationViewModel = self.transferConfirmationModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
