//
//  LoginViewController.swift
//  BNIMobile
//
//  Created by Gobinda Ch Das on 08/03/23.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var vwToBG:UIView!
    @IBOutlet weak var stackVW:UIStackView!
    @IBOutlet weak var labelUserIdError:UILabel!
    @IBOutlet weak var labelPswdError:UILabel!
    @IBOutlet weak var textFieldUserid:UITextField!
    @IBOutlet weak var textFieldPswd:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpErrorLabel()
        // Do any additional setup after loading the view.
    }
    

    func setUpErrorLabel() {
        labelUserIdError.isHidden = true
        labelPswdError.isHidden = true
    }

    @IBAction func buttonLoginTapped(_ sender: Any) {
        //TO DO move to homescreen
    }
}
