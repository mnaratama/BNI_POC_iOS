//
//  QuicklinksView.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class QuicklinksView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MySpaceHeaderTableCell", bundle: nil), forCellReuseIdentifier: "MySpaceHeaderTableCell")
        tableView.register(UINib(nibName: "MySpaceClaimRewardTableCell", bundle: nil), forCellReuseIdentifier: "MySpaceClaimRewardTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension QuicklinksView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceHeaderTableCell", for: indexPath) as! MySpaceHeaderTableCell
            return cell
//        }
        
//        else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "QuicklinkTableCell", for: indexPath) as! HomeQuicklinkTableCell
//            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySpaceClaimRewardTableCell", for: indexPath) as! MySpaceClaimRewardTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 112
//        } else if indexPath.row == 1 {
//            return 180
        } else {
            return 250
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        delegate?.didSelectotherMaterial(index: indexPath.row)
    //    }
}
