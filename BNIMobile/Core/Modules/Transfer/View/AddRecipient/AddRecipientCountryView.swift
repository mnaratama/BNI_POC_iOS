//
//  ChooseRecipientView.swift
//  BNIMobile
//
//  Created by admin on 06/03/23.
//

import UIKit

class AddRecipientCountryView : UIViewController {
    
    enum Constants {
        static let addRecipientStoryboardName = "AddRecipient"
        static let addRecipientAccountDetailsView = "AddRecipientAccountDetailsVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddRecipientCountryView")
    }
    
    
    @IBAction func buttonNextTapped(_ sender: Any) {
        guard let viewController = UIStoryboard(name: Constants.addRecipientStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.addRecipientAccountDetailsView) as? AddRecipientAccountDetailsView else {
            fatalError("Failed to load Transfer from AddRecipientAccountDetailsVC file")
        }
            
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
