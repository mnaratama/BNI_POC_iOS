//
//  SuccessAddBeneficiaryView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//


import UIKit

class AddRecipientSuccessView : UIViewController {
    
    enum Constants {
        static let mainStoryboardName = "Transfer"
        static let beneficiaryAddCountryVC = "Success"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Success Add Beneficiary View")
    }
    
    func buttonTappedToStart(_ sender : Any){
        guard let viewController = UIStoryboard(name: Constants.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.beneficiaryAddCountryVC) as? AddRecipientCountryView else {
            fatalError("Failed to load Transfer from BenificiaryAddCountryVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
