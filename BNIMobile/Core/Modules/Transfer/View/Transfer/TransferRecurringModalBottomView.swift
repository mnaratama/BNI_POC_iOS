//
//  TransferRecurringModalBottomView.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

import UIKit

class TransferRecurringModalBottomView : UIViewController {
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferRecurringSuccessView = "TransferRecurringSuccessVC"
        static let landingPageStoryboardName = "LandingPage"
        static let landingPageView = "LandingPageVC"
        static let transferRecurringModalBottomView = "TransferRecurringModalBottomVC"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferRecurringModalBottomView")
//        setupGestureRecognizer()

    }
    
//    func setupGestureRecognizer(){
//        let usePoinGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(usePoinSelector(tapGestureRecognizer:)))
//        usePoinButton.addGestureRecognizer(usePoinGestureRecognizer)
//
//    }
    
//    @objc func usePoinSelector(tapGestureRecognizer: UITapGestureRecognizer){
//        print("tapped")
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        if(isCheckedPoin){
//            tappedImage.image = UIImage(systemName:  "square")! as UIImage
//            isCheckedPoin = false
//        }
//        else {
//            tappedImage.image = UIImage(systemName: "checkmark.square")! as UIImage
//            isCheckedPoin = true
//        }
//    }

    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.landingPageStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.landingPageView) as? LandingPageView else {
            fatalError("Failed to load LandingPage from TransferSuccessView file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferRecurringSuccessView) as? TransferRecurringSuccessView else {
            fatalError("Failed to load LandingPage from TransferRecurringSuccessVC file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
