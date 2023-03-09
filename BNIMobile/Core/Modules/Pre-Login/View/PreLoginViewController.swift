//
//  PreLoginViewController.swift
//  BNIMobile
/*
 * Licensed Materials - Property of IBM
 * Copyright (C) 2023 IBM Corp. All Rights Reserved.
 *
 * IMPORTANT: This IBM software is supplied to you by IBM
 * Corp. (""IBM"") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit

class PreLoginViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var balanceView: UIVisualEffectView!
    
    var transactions:[TransactionRecent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountBalance()
    }
    
    @IBAction func longPressForBalance(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        showBalanceView(status: false)
    }
    
    @IBAction func tapPressForCloseBalance(_ sender: Any) {
        showBalanceView(status: true)
    }
    
    private func showBalanceView(status:Bool) {
        UIView.transition(with: balanceView, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.balanceView.isHidden = status
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let viewController = UIStoryboard(name: StoryboardName.preLogin, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.biometricLoginVC) as? BiometricLoginViewController else {
            fatalError("Failed to load Main from BiometricLoginViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PreLoginViewController {
    func getAccountBalance() {
        let storedCredentials = Keychain.readStoredCredentialsFromKeychain()
        let username = storedCredentials?["username"] as? String ?? ""
        NetworkAccessLayer.shared.getUserData(userId: username, completionHandler: { isSuccess, baseResponse, _ in
            if let baseResponse = baseResponse, baseResponse.responsestatuscode == 200, let accountNumber = baseResponse.userData?.accountno {
                NetworkAccessLayer.shared.getAccountBalance(accounrNo: accountNumber, completionHandler: { isSuccess, baseResponse, _ in
                    if let baseResponse = baseResponse, baseResponse.status == 200 {
                        self.transactions =  baseResponse.transactions ?? []
                        self.tableView.reloadData()
                    }
                })
            }
        })
    }
}

extension PreLoginViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerName.transactionCell, for: indexPath) as! TransactionTableViewCell
      
        cell.amount.text = transactions[indexPath.row].amount?.description
        cell.payee.text = transactions[indexPath.row].transactionType
        return cell
    }
}
