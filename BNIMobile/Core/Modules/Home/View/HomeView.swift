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
    @IBOutlet weak var nominalLabel: UILabel!
    
    var homeViewModel = HomeViewModel()
    var selectedIndex = -1
    var cardNominal = 0
    var accountNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        setupNetwork()
        tabBar.delegate = self
        tableView.register(UINib(nibName: "HomeQuicklinkTableCell", bundle: nil), forCellReuseIdentifier: "QuicklinkTableCell")
        tableView.register(UINib(nibName: "HomeHeaderTableCell", bundle: nil), forCellReuseIdentifier: "HeaderTableCell")
        tableView.register(UINib(nibName: "HomeRecentTransactionTableCell", bundle: nil), forCellReuseIdentifier: "RecentTransactionTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        nominalLabel.text = "Rp \(cardNominal.asPriceFormat)"
    }
    
    private func setupNetwork() {
        NetworkAccessLayer.shared.getAccountTransaction(accountNo: accountNumber, completionHandler: { [self] isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.status == 200 {
                homeViewModel.transactionList = baseResponse.transactions
                tableView.reloadData()
            }
        })
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
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
            cell.cellDelegate = self
            cell.bind(data: homeViewModel.yourQuicklinkItems, selected: selectedIndex)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableCell", for: indexPath) as! HomeRecentTransactionTableCell
            cell.bind(data: homeViewModel.transactionList ?? [])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        } else if indexPath.row == 1 {
            if selectedIndex == -1 {
                return 132
            }else{
                return 256
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if selectedIndex == -1 {
                selectedIndex = 1
            }else{
                selectedIndex = -1
            }
            tableView.reloadData()
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension HomeView: HomeQuicklinkTableCellDelegate {
    
    // Navigate to Quicklink
    func collectionView(collectionviewcell: HomeQuicklinksCollectionCell?, index: Int, didTappedInTableViewCell: HomeQuicklinkTableCell) {
        //TODO: Load EPIC4 Here
        guard let viewController = UIStoryboard(name: StoryboardName.landingPage, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.landingPageVC) as? LandingPageView else {
            fatalError("Failed to load Main from CongratulationsPointViewController file")
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Navigate to Quicklink
    func pushToManage() {
        let storyboard = UIStoryboard(name: StoryboardName.home, bundle: nil)
        let presentingViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerName.quicklinksVC)
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
