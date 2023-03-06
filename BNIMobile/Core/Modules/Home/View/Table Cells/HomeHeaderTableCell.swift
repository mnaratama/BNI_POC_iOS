//
//  HomeHeaderTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeHeaderTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let width = UIScreen.main.bounds.width * 0.5
    var items:[HomeHeaderTab]?
    var didSelectCell: ((Int)->Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
//        backgroundColor = UIColor.systemTeal
        
        setupCollectionView()
    }
    
//    override func layoutSubviews() {
//        collectionViewHeightConstraint.constant = (width / 2) + 4
//    }
    
    private func setupCollectionView(){
//        collectionView.register(HomeQuicklinksCollectionCell.self, forCellWithReuseIdentifier: "QuicklinksCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    private func setupView(){
        
    }
    
    func bind(items: [HomeHeaderTab]){
        self.items = items
        collectionView.reloadData()
    }
}

extension HomeHeaderTableCell{
    struct HomeHeaderTab {
        let id: Int
        let name: String
        let image: String
    }
}

extension HomeHeaderTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell: HomePageHeaderTabCollectionCell = collectionView.dequeueReusableCell(for: indexPath){
//            cell.bind(image: items?[indexPath.row].image ?? "")
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}

