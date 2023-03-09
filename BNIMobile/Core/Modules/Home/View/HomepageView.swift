//
//  HomepageView.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit


class HomepageView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var mySpaceView: UIView!
    
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTableView() {
        setupNetwork()
        tableView.register(UINib(nibName: "HomepageHeaderTableCell", bundle: nil), forCellReuseIdentifier: "HomepageHeaderTableCell")
        tableView.register(UINib(nibName: "HomepageOtherQuicklinkTableCell", bundle: nil), forCellReuseIdentifier: "HomepageOtherQuicklinkTableCell")
        tableView.register(UINib(nibName: "HomepageDebitCardTableCell", bundle: nil), forCellReuseIdentifier: "HomepageDebitCardTableCell")
        tableView.register(UINib(nibName: "HomepageCreditCardTableCell", bundle: nil), forCellReuseIdentifier: "HomepageCreditCardTableCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupView() {
        mySpaceView.layer.cornerRadius = 10
        mySpaceView.layer.shadowOffset = CGSize(width: 0,
                                                height: -3.0)
        mySpaceView.layer.shadowRadius = 3.5
        mySpaceView.layer.shadowOpacity = 0.1
        setupTableView()
    }
    
    private func setupNetwork() {
        NetworkAccessLayer.shared.getAccountCIF(cifNo: "", completionHandler: { [self] isSuccess, baseResponse, _  in
            if isSuccess, let baseResponse = baseResponse, baseResponse.status == 200 {
                homeViewModel.accountList = baseResponse.accounts
                tableView.reloadData()
            }
        })
    }
    
    @IBAction func manageTapped(_ sender: UIButton) {
    }
    
    @IBAction func mySpaceTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: StoryboardName.home, bundle: nil)
        let presentingViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerName.myspaceVC)
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

extension HomepageView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageHeaderTableCell", for: indexPath) as! HomepageHeaderTableCell
            cell.bind(data: homeViewModel.homepageQuicklinkItems)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageOtherQuicklinkTableCell", for: indexPath) as! HomepageOtherQuicklinkTableCell
            cell.cellDelegate = self
            cell.bind(data: homeViewModel.yourQuicklinkItems)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageDebitCardTableCell", for: indexPath) as! HomepageDebitCardTableCell
            cell.cellDelegate = self
            cell.bind(data: homeViewModel.accountList ?? [])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomepageCreditCardTableCell", for: indexPath) as! HomepageCreditCardTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 112
        } else if indexPath.row == 1 {
            return 156
        } else {
            return 164
        }
    }
}

extension HomepageView: HomepageDebitCardTableCellDelegate, HomepageOtherQuicklinkTableCellCellDelegate {
    
    // Navigate to AccountPage
    func collectionView(collectionviewcell: HomepageDebitCardCollectionCell?, index: Int, didTappedInTableViewCell: HomepageDebitCardTableCell) {
        guard let viewController = UIStoryboard(name: StoryboardName.home, bundle: nil).instantiateViewController(withIdentifier: ViewControllerName.homeviewVC) as? HomeView else {
            fatalError("Failed to load Main from EnterMobileNumberVC file")
        }
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: false)
    }
    
    // Navigate to Quicklink
    func collectionView(collectionviewcell: HomeQuicklinksCollectionCell?, index: Int, didTappedInTableViewCell: HomepageOtherQuicklinkTableCell) {
        //TODO: Load EPIC4 Here
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
