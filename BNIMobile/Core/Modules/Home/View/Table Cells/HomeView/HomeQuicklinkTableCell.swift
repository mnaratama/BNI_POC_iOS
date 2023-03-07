//
//  HomeQuicklinkTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeQuicklinkTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var items: [HomeQuicklink]?
    var didSelectCell: ((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeQuicklinksCollectionCell", bundle: .main), forCellWithReuseIdentifier: "QuicklinksCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    func bind(data: [HomeQuicklink]){
        items = data
        collectionView.reloadData()
        //        height = bottomLine ? 170.0 : 154.0
    }
}

extension HomeQuicklinkTableCell{
    struct HomeQuicklink {
        let id: Int
        let name: String
        let image: String
    }
}

extension HomeQuicklinkTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuicklinksCollectionCell", for: indexPath) as! HomeQuicklinksCollectionCell
        cell.bind()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/4, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}
