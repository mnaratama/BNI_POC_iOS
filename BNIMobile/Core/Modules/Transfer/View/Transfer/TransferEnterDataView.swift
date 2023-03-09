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
    
    var chargeType = ""
    
    var isChecked = false
        
    @IBOutlet weak var beneficiaryRadioButton: UIImageView!
    
    @IBOutlet weak var guaranteedRadioButton: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferEnterDataView")
        setupGestureRecognizer()
    }
    
    @objc func beneficiaryRadioButtonSelector(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isChecked){
            tappedImage.image = UIImage(named: "ic_radio_button_outline_blank")
            guaranteedRadioButton.image =  UIImage(named: "ic_radio_button")
            isChecked = false
        }
        else {
            tappedImage.image = UIImage(named: "ic_radio_button")
            guaranteedRadioButton.image =  UIImage(named: "ic_radio_button_outline_blank")
            isChecked = true
        }
    }
    
    @objc func guaranteedRadioButtonSelector(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(isChecked){
            tappedImage.image = UIImage(named: "ic_radio_button_outline_blank")
            beneficiaryRadioButton.image =  UIImage(named: "ic_radio_button")
            isChecked = false
        }
        else {
            tappedImage.image = UIImage(named: "ic_radio_button")
            beneficiaryRadioButton.image =  UIImage(named: "ic_radio_button_outline_blank")
            isChecked = true
        }
    }
    
    func setupGestureRecognizer(){
        let beneficiaryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(beneficiaryRadioButtonSelector(tapGestureRecognizer:)))
        beneficiaryRadioButton.addGestureRecognizer(beneficiaryGestureRecognizer)
        
        let guaranteedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(guaranteedRadioButtonSelector(tapGestureRecognizer:)))
        guaranteedRadioButton.addGestureRecognizer(guaranteedGestureRecognizer)
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

extension TransferEnterDataView {
    
}
