//
//  TransferEnterDataView.swift
//  BNIMobile
//
//  Created by admin on 07/03/23.
//

import UIKit

class TransferEnterDataView : UIViewController, UITextFieldDelegate {
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferConfirmView = "TransferConfirmVC"
    }
    var recepient: Receivers?
    var nameReceiverLabel = ""
    var bankReceiverLabel = ""
    var currencyReceiverLabel = ""
    var isBeneficiaryChecked = false, isGuaranteedChecked = false
    var chargeType: ChargeType?
        
    @IBOutlet weak var beneficiaryRadioButton: UIImageView!
    @IBOutlet weak var guaranteedRadioButton: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var sourceCurrencyField: UITextField!
    
    @IBOutlet weak var destinationCurrencyField: UITextField!
    
    var currencyConverter = CurrencyConverter()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferEnterDataView")
        setupGestureRecognizer()
        setupView()
        sourceCurrencyField.delegate = self
        destinationCurrencyField.delegate = self
        currencyConverter.exchangeRate = 16391.45
        currencyConverter.sourceCurrencyCode = "RP"
        currencyConverter.destinationCurrencyCode = "EUR"
    }
    
    @objc func beneficiaryRadioButtonSelector(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isBeneficiaryChecked){
            tappedImage.image = UIImage(named: "ic_radio_button_outline_blank")
            guaranteedRadioButton.image =  UIImage(named: "ic_radio_button")
            isBeneficiaryChecked = false
        }
        else {
            tappedImage.image = UIImage(named: "ic_radio_button")
            guaranteedRadioButton.image =  UIImage(named: "ic_radio_button_outline_blank")
            isBeneficiaryChecked = true
            self.chargeType = .beneficiary
        }
        
    }
    
    @objc func guaranteedRadioButtonSelector(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isGuaranteedChecked){
            tappedImage.image = UIImage(named: "ic_radio_button_outline_blank")
            beneficiaryRadioButton.image =  UIImage(named: "ic_radio_button")
            isGuaranteedChecked = false
        }
        else {
            tappedImage.image = UIImage(named: "ic_radio_button")
            beneficiaryRadioButton.image =  UIImage(named: "ic_radio_button_outline_blank")
            isGuaranteedChecked = true
            self.chargeType = .guaranteed
        }
    }
    
    func setupGestureRecognizer(){
        let beneficiaryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(beneficiaryRadioButtonSelector(tapGestureRecognizer:)))
        beneficiaryRadioButton.addGestureRecognizer(beneficiaryGestureRecognizer)
        
        let guaranteedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(guaranteedRadioButtonSelector(tapGestureRecognizer:)))
        guaranteedRadioButton.addGestureRecognizer(guaranteedGestureRecognizer)
    }
    
    func setupView(){
        nameLabel.text = recepient?.receiverName
        bankLabel.text = "\(recepient?.receiverBankName ?? "") | \(recepient?.receiverAcNumber ?? "")"
        currencyLabel.text = "\(recepient?.receiverCountryName ?? "") - \(recepient?.receiverCurrency ?? "")"
    }
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferConfirmView) as? TransferConfirmView else {
            fatalError("Failed to load Transfer from TransferEnterDataView file")
        }
        let transferConfirmViewModel = TransferConfirmationViewModel()
        transferConfirmViewModel.receiver = recepient
        transferConfirmViewModel.chargeType = self.chargeType
        currencyConverter.sourceCurrencyCode = recepient?.payerBaseCurrencySymbol ?? ""
        currencyConverter.destinationCurrencyCode = "EUR"
        transferConfirmViewModel.currencyConversion = currencyConverter
        viewController.transferConfirmationModel = transferConfirmViewModel
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("test")
        let oldText = textField.text ?? ""
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            return true
        }
        if textField.tag == 1000 {
            
            let value = Double(newText) ?? 0.00
            let exchangeValue = currencyConverter.exchangeRate
            self.destinationCurrencyField.text = "\(value / exchangeValue)"
            currencyConverter.destinationAmount = value / exchangeValue
            currencyConverter.sourceAmount = value
        } else {
            let value = Double(newText ) ?? 0.00
            let exchangeValue = currencyConverter.exchangeRate
            self.sourceCurrencyField.text = "\(value * exchangeValue)"
            currencyConverter.sourceAmount = value * exchangeValue
            currencyConverter.destinationAmount = value
        }
        return true
    }
    
}

extension TransferEnterDataView {
    
}
