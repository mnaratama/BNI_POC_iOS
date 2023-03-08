//
//  HomeView.swift
//  BNIMobile
//
//  Created by Naratama on 05/03/23.
//

import UIKit


class HomeView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    
    enum Constants {
        static let homeStoryboardName = "Home"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tabBar.delegate = self
        tableView.register(UINib(nibName: "HomeQuicklinkTableCell", bundle: nil), forCellReuseIdentifier: "QuicklinkTableCell")
        tableView.register(UINib(nibName: "HomeHeaderTableCell", bundle: nil), forCellReuseIdentifier: "HeaderTableCell")
        tableView.register(UINib(nibName: "HomeRecentTransactionTableCell", bundle: nil), forCellReuseIdentifier: "RecentTransactionTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension HomeView: UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! HomeHeaderTableCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuicklinkTableCell", for: indexPath) as! HomeQuicklinkTableCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableCell", for: indexPath) as! HomeRecentTransactionTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else if indexPath.row == 1 {
            return 256
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        delegate?.didSelectotherMaterial(index: indexPath.row)
    //    }
}
