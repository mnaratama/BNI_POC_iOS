//
//  MySpaceView.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class MySpaceView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Constants {
        static let homeStoryboardName = "Home"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MySpaceHeaderTableCell", bundle: nil), forCellReuseIdentifier: "MySpaceHeaderTableCell")
        tableView.register(UINib(nibName: "MySpaceClaimRewardTableCell", bundle: nil), forCellReuseIdentifier: "MySpaceClaimRewardTableCell")
        tableView.register(UINib(nibName: "MySpaceDealsTableCell", bundle: nil), forCellReuseIdentifier: "MySpaceDealsTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension MySpaceView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceHeaderTableCell", for: indexPath) as! MySpaceHeaderTableCell
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceClaimRewardTableCell", for: indexPath) as! MySpaceClaimRewardTableCell
            cell.bind(title: "BNI Products to help you bank better")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceDealsTableCell", for: indexPath) as! MySpaceDealsTableCell
            cell.bind(title: "Special deals just for you!")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 112
        } else {
            return 264
        }
    }
}
