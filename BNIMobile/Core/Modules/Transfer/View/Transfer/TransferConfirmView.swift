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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransferConfirmView")
        setupGestureRecognizer()
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

        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
