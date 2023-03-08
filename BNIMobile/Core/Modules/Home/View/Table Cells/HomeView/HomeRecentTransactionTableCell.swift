//
//  HomeRecentTransactionTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeRecentTransactionTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //    var items: [HomeQuicklink]?
    var didSelectCell: ((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeRecentTransactionCollectionCell", bundle: .main), forCellWithReuseIdentifier: "RecentTransactionCollectionCell")
        collectionView.register(UINib(nibName: "HomeRecentTransactionHeaderCollectionCell", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RecentTransactionHeaderCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    //    func bind(data: [HomeQuicklink]){
    //        items = data
    //        collectionView.reloadData()
    //        height = bottomLine ? 170.0 : 154.0
    //    }
    
    @IBAction func viewAllTapped(_ sender: UIButton) {
    }
    
}

extension HomeRecentTransactionTableCell{
    struct HomeQuicklink {
        let id: Int
        let name: String
        let image: String
    }
}

extension HomeRecentTransactionTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RecentTransactionHeaderCollectionCell", for: indexPath) as! HomeRecentTransactionHeaderCollectionCell
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentTransactionCollectionCell", for: indexPath) as! HomeRecentTransactionCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}

