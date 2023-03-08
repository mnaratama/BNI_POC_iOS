//
//  CongratulationsPointViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 06/03/23.
//

import UIKit

class CongratulationsPointViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func CloseButtonAction(_ sender: Any) {
        //TODO: Load EPIC3 Here
    }
}
