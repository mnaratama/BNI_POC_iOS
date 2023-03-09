//
//  QuicklinksView.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class QuicklinksView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ManageQuicklinkTableCell", bundle: nil), forCellReuseIdentifier: "ManageQuicklinkTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension QuicklinksView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManageQuicklinkTableCell", for: indexPath) as! ManageQuicklinkTableCell
            cell.bind(data: homeViewModel.yourQuicklinkItems)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManageQuicklinkTableCell", for: indexPath) as! ManageQuicklinkTableCell
            cell.bind(data: homeViewModel.availableQuicklinkItems)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 208
        } else {
            return 192
        }
    }
}
