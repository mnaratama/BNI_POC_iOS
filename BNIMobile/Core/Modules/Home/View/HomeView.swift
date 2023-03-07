//
//  HomeView.swift
//  BNIMobile
//
//  Created by Naratama on 05/03/23.
//

import UIKit


class HomeView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    
    enum Constants {
        static let mainStoryboardName = "Home"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "HomeQuicklinkTableCell", bundle: nil), forCellReuseIdentifier: "QuicklinkTableCell")
        tableView.register(UINib(nibName: "HomeHeaderTableCell", bundle: nil), forCellReuseIdentifier: "HeaderTableCell")
        tableView.register(UINib(nibName: "HomeRecentTransactionTableCell", bundle: nil), forCellReuseIdentifier: "RecentTransactionTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    @IBAction func settingTapped(_ sender: UIButton) {
        sheet()
    }
    
    
    func sheet() {
        let presentingViewController = MySpaceView()
        if #available(iOS 15.0, *) {
            if let sheet = presentingViewController.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
        } else {
            presentingViewController.modalPresentationStyle = .pageSheet
            presentingViewController.modalTransitionStyle = .coverVertical
        }
        present(presentingViewController, animated: true, completion: nil)
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    
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
            return 180
        } else {
            return UITableView.automaticDimension
        }
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        delegate?.didSelectotherMaterial(index: indexPath.row)
    //    }
}
