//
//  LandingPageModalBottomView.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//

import UIKit

class LandingPageModalBottomView : UIViewController {
    
    @IBOutlet weak var recipientTableView: UITableView!
    
    
    enum Constants {
        static let transferStoryboardName = "Transfer"
        static let transferEnterDataView = "TransferEnterDataVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LandingPageModalBottomView")
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferEnterDataView) as? TransferEnterDataView else {
            fatalError("Failed to load Transfer from LandingPageVC file")
        }

        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LandingPageModalBottomView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientCell", for: indexPath)
        return cell
    }
}
