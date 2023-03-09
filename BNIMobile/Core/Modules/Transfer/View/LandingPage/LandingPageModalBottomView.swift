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
    
    var transferViewModel = TransferViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipientTableView.delegate = self
        recipientTableView.dataSource = self
        print("LandingPageModalBottomView")
        setupNetwork()
    }
    
    @IBAction func buttonMakeTransferTapped(_ sender: Any) {
        print("buttonTapped")
        
    }
    
    private func setupNetwork() {
        NetworkAccessLayer.shared.getRecieverAll(cifNo: "", completionHandler: { [self] isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.status == 200 {
                transferViewModel.receiversList = baseResponse.receivers
                recipientTableView.reloadData()
            }
        })
    }
}

extension LandingPageModalBottomView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transferViewModel.receiversList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientCell", for: indexPath) as! LandingPageModalTableViewCell
        let bankNamesLabel = "\(transferViewModel.receiversList?[indexPath.row].receiverBankName ?? "") | \(transferViewModel.receiversList?[indexPath.row].receiverAcNumber ?? "")"
        let countryNamesLabel = "\(transferViewModel.receiversList?[indexPath.row].receiverCountryName ?? "") - \(transferViewModel.receiversList?[indexPath.row].payerBaseCurrency ?? "")"
        cell.bind(recipient: transferViewModel.receiversList?[indexPath.row].receiverName ?? "", bankNames: bankNamesLabel, countryNames: countryNamesLabel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: Constants.transferStoryboardName, bundle: nil).instantiateViewController(withIdentifier: Constants.transferEnterDataView) as? TransferEnterDataView else {
            fatalError("Failed to load Transfer from LandingPageVC file")
        }
        let bankNamesLabel = "\(transferViewModel.receiversList?[indexPath.row].receiverBankName ?? "") | \(transferViewModel.receiversList?[indexPath.row].receiverAcNumber ?? "")"
        let countryNamesLabel = "\(transferViewModel.receiversList?[indexPath.row].receiverCountryName ?? "") - \(transferViewModel.receiversList?[indexPath.row].payerBaseCurrency ?? "")"
        viewController.nameReceiverLabel = transferViewModel.receiversList?[indexPath.row].receiverName ?? ""
        viewController.bankReceiverLabel = bankNamesLabel
        viewController.currencyReceiverLabel = countryNamesLabel
        viewController.recepient = transferViewModel.receiversList?[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
