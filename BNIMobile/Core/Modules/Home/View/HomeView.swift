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
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    @IBAction func settingTapped(_ sender: UIButton) {
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell", for: indexPath) as! HomeHeaderTableCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuicklinkTableCell", for: indexPath) as! HomeQuicklinkTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else {
            return 180
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didSelectotherMaterial(index: indexPath.row)
//    }
}
